#include <string>
#include <pylon/PylonIncludes.h>
#include <pylon/usb/BaslerUsbInstantCamera.h>
#include <iostream>
#include <fstream>

using namespace Pylon;
using namespace GenApi;
using namespace std;
using namespace Basler_UsbCameraParams;

typedef Pylon::CBaslerUsbInstantCamera Camera_t;
typedef CBaslerUsbCameraEventHandler CameraEventHandler_t; // Or use Camera_t::CameraEventHandler_t


														   //Enumeration used for distinguishing different events.
class CSampleCameraEventHandler : public CBaslerUsbCameraEventHandler
{
public:
	// Only very short processing tasks should be performed by this method. Otherwise, the event notification will block the
	// processing of images.
	virtual void OnCameraEvent( CBaslerUsbInstantCamera& camera, intptr_t userProvidedId, GENAPI_NAMESPACE::INode* pNode)
	{

		cout << "Exposure End event. FrameID: " << camera.EventExposureEndFrameID.GetValue() << " Timestamp: " << camera.EventExposureEndTimestamp.GetValue() << std::endl << std::endl;

	}
};