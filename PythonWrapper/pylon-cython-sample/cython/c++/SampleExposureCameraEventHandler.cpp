// Grab_UsingExposureEndEvent_Usb.cpp
/*
    Note: Before getting started, Basler recommends reading the Programmer's Guide topic
    in the pylon C++ API documentation that gets installed with pylon.
    If you are upgrading to a higher major version of pylon, Basler also
    strongly recommends reading the Migration topic in the pylon C++ API documentation.

    This sample shows how to use the Exposure End event to speed up the image acquisition.
    For example, when a sensor exposure is finished, the camera can send an Exposure End event to the PC.
    The PC can receive the event before the image data of the finished exposure has been completely transferred.
    This can be used in order to avoid an unnecessary delay, for example when an imaged
    object is moved further before the related image data transfer is complete.
*/

// Include files to use the PYLON API.
#include <pylon/PylonIncludes.h>







// Namespace for using pylon objects.
using namespace Pylon;

// Settings for using Basler USB cameras.
#include <pylon/usb/BaslerUsbInstantCamera.h>
typedef Pylon::CBaslerUsbInstantCamera Camera_t;
typedef Pylon::CBaslerUsbCameraEventHandler CameraEventHandler_t; // Or use Camera_t::CameraEventHandler_t
typedef Pylon::CBaslerUsbImageEventHandler ImageEventHandler_t; // Or use Camera_t::ImageEventHandler_t
typedef Pylon::CBaslerUsbGrabResultPtr GrabResultPtr_t; // Or use Camera_t::GrabResultPtr_t
using namespace Basler_UsbCameraParams;

// Namespace for using cout.
using namespace std;

// Enumeration used for distinguishing different events.
enum MyEvents
{
    eMyExposureEndEvent,      // Triggered by a camera event.
    eMyFrameStartOvertrigger, // Triggered by a camera event.
    eMyImageReceivedEvent,    // Triggered by the receipt of an image.
    eMyMoveEvent,             // Triggered when the imaged item or the sensor head can be moved.
    eMyNoEvent                // Used as default setting.
};


// Used for logging received events without outputting the information on the screen
// because outputting will change the timing.
// This class is used for demonstration purposes only.
struct LogItem
{
    LogItem()
        : eventType( eMyNoEvent)
        , frameNumber(0)
    {
    }

    LogItem( MyEvents event, uint16_t frameNr)
        : eventType(event)
        , frameNumber(frameNr)
    {
        //Warning, measured values can be wrong on older PC hardware.
        QueryPerformanceCounter(&time);
    }

    LARGE_INTEGER time; // Recorded time stamps.
    MyEvents eventType; // Type of the received event.
    uint16_t frameNumber; // Frame number of the received event.
};



// Number of images to be grabbed.
static const uint32_t c_countOfImagesToGrab = 50;




// Example handler for GigE camera events.
// Additional handling is required for GigE camera events because the event network packets can be lost, doubled or delayed on the network.
class CSampleExposureCameraEventHandler : public CameraEventHandler_t
{
public:
    CSampleExposureCameraEventHandler()
        : m_nextExpectedFrameNumberImage(0)
        , m_nextExpectedFrameNumberExposureEnd(0)
        , m_nextFrameNumberForMove(0)
        , m_frameIDsInitialized(false)
    {
        // Reserve space to log camera, image and move events.
        m_log.reserve( c_countOfImagesToGrab * 3);
    }

    // This method is called when a camera event has been received.
    virtual void OnCameraEvent( Camera_t& camera, intptr_t userProvidedId, GenApi::INode* /* pNode */)
    {
        if ( userProvidedId == eMyExposureEndEvent)
        {
            // An Exposure End event has been received.
            uint16_t frameNumber = (uint16_t)camera.EventExposureEndFrameID.GetValue();
            m_log.push_back( LogItem( eMyExposureEndEvent, frameNumber));

            // If Exposure End event is not doubled.
            if ( GetIncrementedFrameNumber( frameNumber) != m_nextExpectedFrameNumberExposureEnd)
            {
                // Check whether the imaged item or the sensor head can be moved.
                if ( frameNumber == m_nextFrameNumberForMove)
                {
                    MoveImagedItemOrSensorHead();
                }

                // Check for missing Exposure End events.
                if ( frameNumber != m_nextExpectedFrameNumberExposureEnd)
                {
                    throw RUNTIME_EXCEPTION( "An Exposure End event has been lost. Expected frame number is %d but got frame number %d.", m_nextExpectedFrameNumberExposureEnd, frameNumber);
                }
                IncrementFrameNumber( m_nextExpectedFrameNumberExposureEnd);
            }
        }
        else if ( userProvidedId == eMyFrameStartOvertrigger)
        {
            // The camera has been overtriggered.
            m_log.push_back( LogItem( eMyFrameStartOvertrigger, 0));

            // Handle this error...
        }
        else
        {
            PYLON_ASSERT2(false, "The sample has been modified and a new event has been registered. Add handler code above.");
        }
    }

    // This method is called when an image has been grabbed.
    virtual void OnImageGrabbed( Camera_t& camera, const GrabResultPtr_t& ptrGrabResult)
    {
        // An image has been received.
        uint16_t frameNumber = (uint16_t)ptrGrabResult->GetBlockID();
        m_log.push_back( LogItem( eMyImageReceivedEvent, frameNumber));

        // Check whether the imaged item or the sensor head can be moved.
        // This will be the case if the Exposure End has been lost or if the Exposure End is received later than the image.
        if ( frameNumber == m_nextFrameNumberForMove)
        {
            MoveImagedItemOrSensorHead();
        }

        // Check for missing images.
        if ( frameNumber != m_nextExpectedFrameNumberImage)
        {
            throw RUNTIME_EXCEPTION( "An image has been lost. Expected frame number is %d but got frame number %d.", m_nextExpectedFrameNumberImage, frameNumber);
        }
        IncrementFrameNumber( m_nextExpectedFrameNumberImage);
    }

    void MoveImagedItemOrSensorHead()
    {
        // The imaged item or the sensor head can be moved now...
        // The camera may not be ready for a trigger at this point yet because the sensor is still being read out.
        // See the documentation of the CInstantCamera::WaitForFrameTriggerReady() method for more information.
        m_log.push_back( LogItem( eMyMoveEvent, m_nextFrameNumberForMove));
        IncrementFrameNumber( m_nextFrameNumberForMove);
    }

    void PrintLog()
    {

        cout << std::endl << "Warning, the printed time values can be wrong on older PC hardware." << std::endl << std::endl;
        // Print the event information header.
        cout << "Time [ms]    " << "Event                 " << "FrameNumber" << std::endl;
        cout << "------------ " << "--------------------- " << "-----------" << std::endl;

        // Print the logged information.
        size_t logSize = m_log.size();
        for ( size_t i = 0; i < logSize; ++i)
        {

            // Print the event information.
            cout <<   m_log[i].eventType  <<" "<< m_log[i].frameNumber << std::endl;
        }
    }

private:
    void IncrementFrameNumber( uint16_t& frameNumber)
    {
        frameNumber = GetIncrementedFrameNumber( frameNumber);
    }

    uint16_t GetIncrementedFrameNumber( uint16_t frameNumber)
    {
        ++frameNumber;
        return frameNumber;
    }

    uint16_t m_nextExpectedFrameNumberImage;
    uint16_t m_nextExpectedFrameNumberExposureEnd;
    uint16_t m_nextFrameNumberForMove;

    bool m_frameIDsInitialized;

    std::vector<LogItem> m_log;
};