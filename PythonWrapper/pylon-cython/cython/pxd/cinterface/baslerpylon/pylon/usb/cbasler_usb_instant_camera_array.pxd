from libcpp cimport bool
from baslerpylon.pylon.camera_enum cimport EGrabStrategy, EGrabLoop, ETimeoutHandling
from pylon.usb.cbasler_usb_grab_result_ptr cimport CBaslerUsbGrabResultPtr
from pylon.usb.cbasler_usb_instant_camera cimport CBaslerUsbInstantCamera
from base.cgctype cimport size_t
from exception.custom_exception cimport raise_py_error

cdef extern from "pylon/usb/BaslerUsbInstantCameraArray.h" namespace 'Pylon':
    cdef cppclass CBaslerUsbInstantCameraArray:

        # //Creation and life time------------------------------------------------
        #
        # /*!
        # \brief Creates an Instant Camera Array of size 0.
        #
        # Initialize() can be used to adjust the size of the array.
        #
        # \error
        #     Does not throw C++ exceptions.
        # */
        CBaslerUsbInstantCameraArray()  except +raise_py_error

        # /*!
        # \brief Creates an Instant Camera Array.
        #
        # Calls Initialize() to adjust the size of the array.
        #
        # \param[in]  numberOfCameras The number of cameras the array shall hold. Can be 0.
        #
        # The index operator can be used to access the individual cameras
        # for attaching a %Pylon Device or for configuration.
        #
        # Example:
        # \code
        # // Create an array of two devices.
        # CInstantCamera array(2);
        # // Attach %Pylon Devices.
        # array[0].Attach( pDevice1);
        # array[1].Attach( pDevice2);
        # \endcode
        #
        # \error
        #     Does not throw C++ exceptions, except when memory allocation fails.
        # */
        CBaslerUsbInstantCameraArray( size_t numberOfCameras) except +raise_py_error

        # /*!
        # \brief Destroys the Instant Camera Array.
        #
        # If a grab is in progress, it is stopped by calling StopGrabbing().
        #
        # \error
        #     Does not throw C++ exceptions.
        # */
        void Destructor "~CBaslerUsbInstantCameraArray"() except +raise_py_error

        #         /*!
        # \brief Initializes the array.
        #
        # <ul>
        # <li> If a grab is in progress, it is stopped by calling StopGrabbing().
        # <li> All cameras of the array are destroyed.
        # <li> A new set of cameras is created. No %Pylon Devices are attached.
        # <li> The camera context values are set to the index of the camera in the array using CInstantCamera::SetCameraContext.
        # </ul>
        #
        # The index operator can be used to access the individual cameras
        # for attaching a %Pylon Device or for configuration.
        #
        # \param[in]  numberOfCameras The number of cameras the array shall hold.
        #
        # \error
        #     Does not throw C++ exceptions, except when memory allocation fails.
        # */
        void Initialize( size_t numberOfCameras) except +raise_py_error

        #         /*!
        # \brief Returns the attachment state of cameras in the array.
        #
        # \return True if all cameras in the array have a %Pylon Device attached. False is returned if the size of the array is 0.
        #
        # \error
        #     Does not throw C++ exceptions.
        # */
        bool IsPylonDeviceAttached() except +raise_py_error

        #         /*!
        # \brief Returns the connection state of the camera devices used by the Instant Cameras in the array.
        #
        # The device removal is only detected if the Instant Cameras and therefore the attached %Pylon Devices are open.
        #
        # The %Pylon Device is not operable after this event.
        # After it is made sure that no access to the %Pylon Device or any of its node maps is made anymore
        # the %Pylon Device should be destroyed using InstantCamera::DeviceDestroy().
        # The access to the %Pylon Device can be protected using the lock provided by GetLock(), e.g. when accessing parameters.
        #
        # \return True if the camera device removal from the PC for any camera in the array has been detected.
        #
        # \error
        #     Does not throw C++ exceptions.
        # */
        bool IsCameraDeviceRemoved() except +raise_py_error

        #         /*!
        # \brief  Destroys the %Pylon Devices that are attached to the Instant Cameras in the array.
        #
        # \attention The node maps, e.g. the camera node map, of the attached %Pylon Device must not be accessed anymore while destroying the %Pylon Device.
        #
        # <ul>
        # <li> If a grab is in progress, it is stopped by calling StopGrabbing().
        # <li> DestroyDevice is called for all cameras. See CInstantCamera::DestroyDevice() for more information.
        # </ul>
        #
        # \post
        #     No %Pylon Devices are attached to the cameras in the array.
        #
        # \error
        #     Does not throw C++ exceptions.
        # */
        void DestroyDevice() except +raise_py_error

        #         /*!
        # \brief  Detaches all %Pylon Devices that are attached to the Instant Cameras in the array.
        #
        # <ul>
        # <li> If a grab is in progress, it is stopped by calling StopGrabbing().
        # <li> DetachDevice is called for all cameras, see CInstantCamera::DetachDevice() for more information.
        # </ul>
        #
        # \post
        # <ul>
        # <li> No %Pylon Devices are attached to the cameras in the array.
        # <li> The ownership of the %Pylon Devices goes to the caller who is responsible for destroying the %Pylon Devices.
        # </ul>
        #
        # \error
        #     Does not throw C++ exceptions.
        # */
        void DetachDevice() except +raise_py_error


        # /*!
        # \brief Opens all cameras in the array.
        #
        # Open is called for all cameras. See CInstantCamera::Open() for more information.
        #
        # \pre
        # <ul>
        # <li> The size of the array is larger than 0.
        # <li> All devices are attached.
        # </ul>
        #
        # \post
        #     The cameras are open.
        #
        # \error
        #     If one camera throws an exception, all cameras are closed by calling Close().
        # */
        void Open() except +raise_py_error

        #         /*!
        # \brief Returns the open state of the cameras in the array.
        # \error Does not throw C++ exceptions.
        # \return Returns true if all cameras in the array are open. False is returned if the size of the array is 0.
        # */
        bool IsOpen() except +raise_py_error

        #         /*!
        # \brief Closes all cameras in the array.
        #
        # <ul>
        # <li> If a grab is in progress, it is stopped by calling StopGrabbing().
        # <li> Close is called for all cameras, see CInstantCamera::Close() for more information.
        # </ul>
        #
        # \post
        #     All cameras in the array are closed.
        #
        # \error
        #     Does not throw C++ exceptions.
        # */
        void Close() except +raise_py_error

        #         /*!
        # \brief Returns the size of the array.
        #
        # \error
        #     Does not throw C++ exceptions.
        # */
        size_t GetSize() except +raise_py_error

        #         /*!
        # \brief Retrieve a camera by index
        #
        # \pre
        #     The index is smaller than GetSize();
        #
        # \error
        #     Throws an exception if the index is not valid.
        # */
        CBaslerUsbInstantCamera& GetIndex "operator[]"( size_t index)


        # /*!
        # \brief Starts the grabbing of images for all cameras.
        #
        # <ul>
        # <li> StartGrabbing is called for all cameras with the provided parameters, see CInstantCamera::StartGrabbing() for more information.
        # <li> The grabbing is started.
        # <li> The starting position for retrieving results is set to the first camera.
        # </ul>
        #
        # \param[in]  strategy  The grab strategy, see Pylon::InstantCamera::EStrategy for more information.
        # \param[in]  grabLoopType Indicates using the internal grab thread of the camera.
        #
        # \pre
        #     <ul>
        #     <li> The size of the array is larger than 0.
        #     <li> All devices are attached.
        #     <li> The grabbing is stopped.
        #     <li> The preconditions for calling StartGrabbing() are met for every camera in the array.
        #     </ul>
        #
        # \post
        #     The grabbing is started.
        #
        # \error
        #     The camera objects may throw an exception. The grabbing is stopped calling StopGrabbing() in this case.
        # */
        void StartGrabbing() except +raise_py_error
        void StartGrabbing( EGrabStrategy strategy) except +raise_py_error
        void StartGrabbing( EGrabLoop grabLoopType) except +raise_py_error
        void StartGrabbing( EGrabStrategy strategy, EGrabLoop grabLoopType) except +raise_py_error

        # /*!
        # \brief Retrieves a grab result according to the strategy, waits if it is not yet available
        #
        # <ul>
        # <li> The content of the passed grab result is released.
        # <li> If the grabbing is not started, the method returns immediately false.
        # <li> If GrabStrategy_UpcomingImage strategy: RetrieveResult is called for a camera. Cameras are processed using a round-robin strategy.
        # <li> If GrabStrategy_OneByOne, GrabStrategy_LatestImageOnly or GrabStrategy_LatestImages strategy: Pending images or camera events are retrieved. Cameras are processed using a round-robin strategy.
        # <li> If GrabStrategy_OneByOne, GrabStrategy_LatestImageOnly or GrabStrategy_LatestImages strategy: Wait for a grab result if it is not yet available. Camera events are handled.
        # </ul>
        #
        # The camera array index is assigned to the context value of the instant camera when Initialize() is called.
        # This context value is attached to the result when the result is retrieved and can be obtained using the grab result method GrabResultData::GetCameraContext().
        # The context value can be used to associate the result with the camera from where it originated.
        #
        # \param[in]  timeoutMs  A timeout value in ms for waiting for a grab result, or the INFINITE value.
        # \param[out] grabResult  Receives the grab result.
        # \param[in]  timeoutHandling  If timeoutHandling equals TimeoutHandling_ThrowException, a timeout exception is thrown on timeout.
        #
        # \return True if the call successfully retrieved a grab result, false otherwise.
        #
        # \pre
        #     The preconditions for calling StartGrabbing() are met for every camera in the array.
        #
        # \post
        # <ul>
        # <li> If successful, one image is removed from the output queue of a camera and is returned in the grabResult parameter.
        # <li> If not successful, an empty grab result is returned in the grabResult parameter.
        # </ul>
        #
        # \error
        #     The Instant Camera Array object is still valid after error. The grabbing is stopped by calling StopGrabbing() if an exception is thrown.
        # */
        bool RetrieveResult( unsigned int timeoutMs, CBaslerUsbGrabResultPtr& grabResult) except +raise_py_error
        bool RetrieveResult( unsigned int timeoutMs, CBaslerUsbGrabResultPtr& grabResult, ETimeoutHandling timeoutHandling) except +raise_py_error

        # /*!
        # \brief Stops the grabbing of images.
        #
        # The grabbing is stopped.
        # StopGrabbing is called for all cameras. See CInstantCamera::StopGrabbing() for more information.
        #
        # \post
        #     The grabbing is stopped.
        #
        # \error
        #     Does not throw C++ exceptions.
        #
        # \threading
        #     Can be called while one other thread is polling RetrieveResult() in a IsGrabbing()/RetrieveResult() loop
        #     to stop grabbing.
        # */
        void StopGrabbing() except +raise_py_error


        # /*!
        # \brief Returns state of grabbing.
        #
        # The camera array is grabbing after a successful call to StartGrabbing() until StopGrabbing() has been called.
        #
        # \return Returns true if still grabbing.
        #
        # \error
        #     Does not throw C++ exceptions.
        # */
        bool IsGrabbing() except +raise_py_error
