from exception.custom_exception cimport raise_py_error
from genapi.cinode_map cimport INodeMap
from pylon.cevent_adapter cimport IEventAdapter
from pylon.cdevice_info cimport CDeviceInfo
from pylon.cdevice_access_mode cimport *
from pylon.cevent_grabber cimport IEventGrabber
from pylon.cchunk_parser cimport IChunkParser
from pylon.cresult cimport EventResult
from pylon.cstream_grabber cimport IStreamGrabber

from libcpp cimport bool
from libc.stdint cimport  uint32_t




cdef extern from "pylon/Device.h" namespace 'Pylon':

    ctypedef  void* DeviceCallbackHandle

    cdef cppclass IDevice:
		# # Opens a device
        #
        #  The open method initializes all involved drivers and establishes a connection
        #  to the device.
        #
        #  A device may support different access modes, e.g. EDeviceAccessMode::Exclusive providing
        #  an exclusive access to the device.
        #
        #  \param mode The desired device access mode

        void Open(AccessModeSet mode = (Stream | Control | Event)) except +raise_py_error


        # # Closes a device
        #    The close method closes all involved drivers and an existing connection to
        #    the device will be released. Other applications now can access the device.

        void Close() except +raise_py_error



        # # Checks if a device already is opened
        #
        #     \return true, when the device already has been opened by the calling application.
        #
        #     \note When a device has been opened an application A, IsOpen() will return false
        #     when called by an application B not having called the device's open method.
        #

        bool IsOpen() except +raise_py_error

        # # Returns the access mode used to open the device
        # AccessModeSet AccessMode(void) except +raise_py_error
        #
        #
		# \brief Returns the device info object storing information like
        #   the device's name.
        #
        #   \return A reference to the device info object used to create the device by a device factory
        #

        CDeviceInfo& GetDeviceInfo() except +raise_py_error

    cdef cppclass IPylonDevice(IDevice):
        #Returns the number of stream grabbers the camera object provides
        uint32_t GetNumStreamGrabberChannels() except +raise_py_error


        # # Returns a pointer to a stream grabber
        #
        #     Stream grabbers (IStreamGrabber) are the objects used to grab images
        #     from a camera device. A camera device might be able to send image data
        #     over more than one logical channel called stream. A stream grabber grabs
        #     data from one single stream.
        #
        #     \param index The number of the grabber to return
        #     \return A pointer to a stream grabber, NULL if index is out of range


        IStreamGrabber* GetStreamGrabber(uint32_t index) except +raise_py_error


        # # Returns a pointer to an event grabber
        #
        #     Event grabbers are used to handle events sent from a camera device.


        IEventGrabber* GetEventGrabber() except +raise_py_error


        # # Returns the set of camera parameters.
        #
        #   \return Pointer to the GenApi node map holding the parameters


        INodeMap* GetNodeMap() except +raise_py_error


        # # Returns the set of camera related transport layer parameters.
        #
        #     \return Pointer to the GenApi node holding the transport layer parameter. If
        #     there are no transport layer parameters for the device, NULL is returned.


        INodeMap* GetTLNodeMap() except +raise_py_error


         # \brief Creates a chunk parser used to update those camera object members
         #    reflecting the content of additional data chunks appended to the image data.
         #
         #    \return Pointer to the created chunk parser
         #
         #    \note Don't try to delete a chunk parser pointer by calling free or delete. Instead,
         #    use the DestroyChunkParser() method


        IChunkParser* CreateChunkParser() except +raise_py_error


        # # Deletes a chunk parser
        #
        # \param pChunkParser Pointer to the chunk parser to be deleted


        void DestroyChunkParser(IChunkParser* pChunkParser) except +raise_py_error


        #Creates an Event adapter
        IEventAdapter* CreateEventAdapter() except +raise_py_error


        #Deletes an Event adapter
        void DestroyEventAdapter(IEventAdapter*) except +raise_py_error


        #Creates a a self-reliant chunk parser, returns NULL if not supported

        #ISelfReliantChunkParser* CreateSelfReliantChunkParser() except +raise_py_error


        #Deletes a self-reliant chunk parser

        #void DestroySelfReliantChunkParser(ISelfReliantChunkParser*) except +raise_py_error

        # # Registers a surprise removal callback object
        #
        #     \param d reference to a device callback object
        #     \return A handle which must be used to deregister a callback
        #     It is recommended to use one of the RegisterRemovalCallback() helper functions
        #     to register a callback.
        #
        #     Example how to register a C function
        #     \code
        #         void MyRemovalCallback( Pylon::IPylonDevice* pDevice)
        #         {
        #             // handle removal
        #         }
        #
        #         DeviceCallbackHandle h =
        #             Pylon::RegisterRemovalCallback( m_pCamera, &MyRemovalCallback);
        #     \endcode
        #
        #     Example how to register a class member function
        #     \code
        #         class C
        #         {
        #             void MyRemovalCallback( Pylon::IPylonDevice* pDevice )
        #             {
        #               // handle removal
        #             }
        #         } c;
        #
        #         DeviceCallbackHandle h =
        #             Pylon::RegisterRemovalCallback( m_pCamera, c, &C::MyRemovalCallback);
        #     \endcode

        #DeviceCallbackHandle RegisterRemovalCallback(DeviceCallback& d) except +raise_py_error

        # # Deregisters a surprise removal callback object
        #
        # \param h Handle of the callback to be removed

        #bool DeregisterRemovalCallback(DeviceCallbackHandle h) except +raise_py_error