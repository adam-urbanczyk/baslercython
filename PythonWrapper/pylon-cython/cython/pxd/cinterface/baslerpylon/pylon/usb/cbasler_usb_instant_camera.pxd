from libcpp cimport bool
from libc.stdint cimport intptr_t
from pylon.ctype_mappings cimport String_t
from pylon.cdevice cimport IPylonDevice
from pylon.cdevice_info  cimport CDeviceInfo
from genapi.cinode_map cimport INodeMap
from pylon.cwait_object cimport WaitObject
from baslerpylon.pylon.camera_enum cimport EGrabStrategy, ECleanup, EGrabLoop, ERegistrationMode, ECameraEventAvailability, ETimeoutHandling
from exception.custom_exception cimport raise_py_error
from pylon.usb.cbasler_usb_image_event_handler cimport CBaslerUsbImageEventHandler
from pylon.usb.cbasler_usb_camera_event_handler cimport CBaslerUsbCameraEventHandler
from pylon.usb.cbasler_usb_configuration_event_handler cimport CBaslerUsbConfigurationEventHandler
from pylon.usb.cbasler_usb_grab_result_ptr cimport CBaslerUsbGrabResultPtr
from pylon.cconfiguration_event_handler cimport CConfigurationEventHandler
from pylon.cimage_event_handler cimport CImageEventHandler
from pylon.ccamera_event_handler cimport CCameraEventHandler

cdef extern from "pylon/usb/BaslerUsbInstantCamera.h" namespace 'Pylon':

    cdef cppclass CBaslerUsbInstantCamera:
# /*!
        # \brief Creates an Instant Camera object and calls Attach().
        #
        # See Attach() for more information.
        #
        # \param[in]  pDevice The %Pylon device to attach.
        # \param[in]  cleanupProcedure If cleanupProcedure equals Cleanup_Delete, the %Pylon device is destroyed when the Instant Camera object is destroyed.
        #
        # \error
        #     May throw an exception if the passed %Pylon device is open.
        #     Does not throw C++ exceptions if the passed %Pylon device is closed or NULL.
        # */
        CBaslerUsbInstantCamera()
        CBaslerUsbInstantCamera( IPylonDevice* pDevice, ECleanup cleanupProcedure) except +raise_py_error
        CBaslerUsbInstantCamera( IPylonDevice* pDevice) except +raise_py_error

        #         /*!
        # \brief Destroys an Instant Camera object.
        #
        # Calls Attach( NULL) for destroying or removing a %Pylon device depending on the passed cleanup procedure.
        #
        # \error
        #     Does not throw C++ exceptions.
        # */
        void Destructor "~CBaslerUsbInstantCamera"() except +raise_py_error

        # /*!
        # \brief  Attaches a %Pylon device to the Instant Camera.
        #
        # \param[in]  pDevice The %Pylon device to attach.
        # \param[in]  cleanupProcedure If cleanupProcedure equals Cleanup_Delete, the %Pylon device is destroyed when the Instant Camera object is destroyed.
        #
        # <ul>
        # <li> If a %Pylon device is currently attached, it is destroyed (DestroyDevice()) or removed (DetachDevice()) depending on the previously set cleanup procedure value.
        # <li> If the pDevice parameter is NULL, nothing more is done.
        # <li> The OnAttach configuration event is fired. Possible C++ exceptions from event calls are caught and ignored. All event handlers are notified.
        # <li> The new %Pylon device is attached.
        # <li> If the passed %Pylon device is open, callbacks for camera events are registered at the camera node map. (This may fail)
        # <li> If the passed %Pylon device is open, a device removal call back is registered. (This may fail)
        # <li> If the passed %Pylon device is open, access modifiers (see IPylonDevice::Open()) are overtaken as camera parameters.
        # <li> The OnAttached configuration event is fired. Possible C++ exceptions from event calls are caught and ignored. All event handlers are notified.
        # </ul>
        #
        # \post
        # <ul>
        # <li>If the passed pointer to the %Pylon device is NULL, the Instant Camera object is in the "no device attached" state.
        # <li>If the passed pointer to the %Pylon device is not NULL, the passed %Pylon device is attached.
        # <li>If the set cleanup procedure equals Cleanup_Delete, the %Pylon device is destroyed when the Instant Camera object is destroyed or a new device is attached.
        # <li>If the passed %Pylon device is open and the registration of callbacks fails, the Instant Camera object is in the "no device attached" state.
        # <li>The opened-by-user flag is set, preventing closing of the %Pylon device on StopGrabbing() when the attached %Pylon device is already open.
        # </ul>
        #
        # \error
        #     May throw an exception if the passed %Pylon device is open.
        #     Does not throw C++ exceptions if the passed %Pylon device is closed or NULL.
        #
        #  \threading
        #     This method is synchronized using the lock provided by GetLock().
        # */
        void Attach( IPylonDevice* pDevice, ECleanup cleanupProcedure) except +raise_py_error
        void Attach( IPylonDevice* pDevice) except +raise_py_error

        # /*!
        # \brief Returns the %Pylon device attached state of the Instant Camera object.
        #
        # \return True if a %Pylon device is attached.
        #
        # \error
        #     Does not throw C++ exceptions.
        #
        # \threading
        #     This method is synchronized using the lock provided by GetLock().
        # */
        bool IsPylonDeviceAttached() except +raise_py_error

        # /*!
        # \brief Returns the connection state of the camera device.
        #
        # The device removal is only detected while the Instant Camera and therefore the attached %Pylon device are open.
        #
        # The attached %Pylon device is not operable anymore if the camera device has been removed from the PC.
        # After it is made sure that no access to the %Pylon device or any of its node maps is made anymore
        # the %Pylon device should be destroyed using InstantCamera::DeviceDestroy().
        # The access to the %Pylon device can be protected using the lock provided by GetLock(), e.g. when accessing parameters.
        #
        # \return True if the camera device removal from the PC has been detected.
        #
        # \error
        #     Does not throw C++ exceptions.
        #
        # \threading
        #     This method is synchronized using the lock provided by GetLock().
        # */
        bool IsCameraDeviceRemoved() except +raise_py_error


        # /*!
        # \brief Returns the ownership of the attached %Pylon device.
        #
        # \return True if a %Pylon device is attached and the Instant Camera object has been given the ownership
        #         by passing the cleanup procedure Cleanup_Delete when calling Attach().
        #
        # \error
        #     Does not throw C++ exceptions.
        #
        # \threading
        #     This method is synchronized using the lock provided by GetLock().
        # */
        bool HasOwnership() except +raise_py_error


        # /*!
        # \brief  Destroys the attached %Pylon device.
        #
        # \attention The node maps, e.g. the camera node map, of the attached %Pylon device must not be accessed anymore while destroying the %Pylon device.
        #
        # <ul>
        # <li> If no %Pylon device is attached, nothing is done.
        # <li> If the %Pylon device is open, it is closed by calling Close().
        # <li> The configuration event OnDestroy is fired. Possible C++ exceptions from event calls are caught and ignored. All event handlers are notified.
        # <li> The %Pylon device is destroyed even if the cleanup procedure Cleanup_None has been passed when calling Attach() before.
        # <li> The configuration event OnDestroyed is fired. Possible C++ exceptions from event calls are caught and ignored. All event handlers are notified.
        # </ul>
        #
        # \post No %Pylon device is attached.
        #
        # \error
        #     Does not throw C++ exceptions. Possible C++ exceptions are caught and ignored.
        #
        # \threading
        #     This method is synchronized using the lock provided by GetLock().
        # */
        void DestroyDevice() except +raise_py_error

        # /*!
        # \brief  Detaches an attached %Pylon device.
        #
        # <ul>
        # <li> If no %Pylon device is attached, nothing is done.
        # <li> If a grab is in progress, it is stopped by calling StopGrabbing().
        # <li> The configuration event OnDetach is fired. Possible C++ exceptions from event calls are caught and ignored. All event handlers are notified.
        # <li> The %Pylon device is detached.
        # <li> The configuration event OnDetached is fired. Possible C++ exceptions from event calls are caught and ignored. All event handlers are notified.
        # </ul>
        #
        # \return The attached %Pylon device or NULL if nothing has been attached before.
        #
        # \post
        # <ul>
        # <li> No %Pylon device is attached.
        # <li> The ownership of the %Pylon device goes to the caller who is responsible for destroying the %Pylon device.
        # </ul>
        #
        # \error
        #     Does not throw C++ exceptions. Possible C++ exceptions are caught and ignored.
        #
        # \threading
        #     This method is synchronized using the lock provided by GetLock().
        # */
        IPylonDevice* DetachDevice()

        # //Control opening and closing of the device-----------------------------
        #
        # /*!
        # \brief Opens the attached %Pylon device.
        #
        # <ul>
        # <li> Opened by user flag is set, preventing closing of the device on StopGrabbing().
        # <li> If the %Pylon device is already open, nothing more is done.
        # <li> The OnOpen configuration event is fired. The notification of event handlers stops when an event call triggers an exception.
        # <li> The %Pylon device is opened.
        # <li> A device removal call back is registered at the %Pylon device.
        # <li> Callbacks for camera events are registered at the camera node map.
        # <li> The OnOpened configuration event is fired if the %Pylon device has been opened successfully. The notification of event handlers stops when an event call triggers an exception.
        # </ul>
        #
        # \pre A %Pylon device is attached.
        #
        # \post
        # <ul>
        # <li> The %Pylon device is open.
        # <li> Opened by user flag is set, preventing closing of the %Pylon device on StopGrabbing().
        # </ul>
        #
        # \error
        #     The Instant Camera object is still valid after error.
        #     The %Pylon device open may throw.
        #     Configuration event calls may throw.
        #     Callback registrations may throw.
        #     The %Pylon device is closed with Close() if the OnOpened event call triggers an exception.
        #
        # \threading
        #     This method is synchronized using the lock provided by GetLock().
        # */
        void Open() except +raise_py_error


        # /*!
        # \brief Returns the open state of the %Pylon device.
        # \error Does not throw C++ exceptions.
        # \return Returns true if a %Pylon device is attached and it is open.
        # \threading
        #     This method is synchronized using the lock provided by GetLock().
        # */
        bool IsOpen() except +raise_py_error

        # /*!
        # \brief Closes the attached %Pylon device.
        #
        # <ul>
        # <li> If no %Pylon device is attached, nothing is done.
        # <li> If the %Pylon device is already closed, nothing is done.
        # <li> If a grab is in progress, it is stopped by calling StopGrabbing().
        # <li> The configuration event OnClose is fired. Possible C++ exceptions from event calls are caught and ignored. All event handlers are notified.
        # <li> The %Pylon device is closed.
        # <li> The configuration event OnClosed is fired if the %Pylon device has been closed successfully. Possible C++ exceptions from event calls are caught and ignored. All event handlers are notified.
        # </ul>
        #
        # \post The %Pylon device is closed.
        #
        # \error
        #     Does not throw C++ exceptions. Possible C++ exceptions are caught and ignored.
        #
        # \threading
        #     This method is synchronized using the lock provided by GetLock().
        # */
        void Close() except +raise_py_error

        # //Grab -----------------------------------------------------------------
        #
        # /*!
        # \brief Starts the grabbing of images.
        #
        # <ul>
        # <li> If a grab loop thread has been used in the last grab session, the grab loop thread context is joined with the caller's context.
        # <li> If the %Pylon device is not already open, it is opened by calling Open().
        # <li> The configuration event OnGrabStart is fired. The notification of event handlers stops when an event call triggers an exception.
        # <li> Grab-specific parameters of the camera object are locked, e.g. MaxNumBuffers.
        # <li> If the camera device parameter ChunkModeActive is enabled, the Instant Camera chunk parsing support is initialized.
        # <li> If the Instant Camera parameter GrabCameraEvents is enabled, the Instant Camera event grabbing support is initialized.
        # <li> The grabbing is started.
        # <li> The configuration event OnGrabStarted is fired if the grab has been started successfully. The notification of event handlers stops when an event call triggers an exception.
        # <li> If grabLoopType equals GrabLoop_ProvidedByInstantCamera, an additional grab loop thread is started calling RetrieveResult( GrabLoopThreadTimeout, grabResult) in a loop.
        # </ul>
        #
        # \param[in]  strategy The grab strategy. See Pylon::EGrabStrategy for more information
        # \param[in]  grabLoopType If grabLoopType equals GrabLoop_ProvidedByInstantCamera, an additional grab loop thread is used to run the grab loop.
        #
        # \pre
        # <ul>
        # <li> A %Pylon device is attached.
        # <li> The stream grabber of the %Pylon device is closed.
        # <li> The grabbing is stopped.
        # <li> The attached %Pylon device supports grabbing.
        # <li> Must not be called while holding the lock provided by GetLock() when using the grab loop thread.
        # </ul>
        #
        # \post
        # <ul>
        # <li> The grabbing is started.
        # <li> Grab-specific parameters of the camera object are locked, e.g. MaxNumBuffers.
        # <li> If grabLoopType equals GrabLoop_ProvidedByInstantCamera, an additional grab loop thread is running that calls RetrieveResult( GrabLoopThreadTimeout, grabResult) in a loop. Images are processed by registered image event handlers.
        # <li> Operating the stream grabber from outside the camera object will result in undefined behavior.
        # </ul>
        #
        # \error
        #     The Instant Camera object is still valid after error. Open() may throw. Configuration event calls may throw. The grab implementation may throw.
        #     The grabbing is stopped with StopGrabbing() if the OnGrabStarted event call triggers an exception. Throws a C++ exception, if Upcoming Image grab strategy
        #     is used together with USB camera devices.
        #
        # \threading
        #     This method is synchronized using the lock provided by GetLock().
        # */
        void StartGrabbing() except +raise_py_error
        void StartGrabbing( size_t maxImages, EGrabStrategy strategy, EGrabLoop grabLoopType) except +raise_py_error
        void StartGrabbing( EGrabStrategy strategy) except +raise_py_error
        void StartGrabbing( EGrabLoop grabLoopType) except +raise_py_error
        void StartGrabbing( size_t maxImages)  except +raise_py_error
        void StartGrabbing( size_t maxImages, EGrabLoop grabLoopType) except +raise_py_error
        void StartGrabbing( size_t maxImages, EGrabStrategy strategy) except +raise_py_error
        void StartGrabbing( EGrabStrategy strategy, EGrabLoop grabLoopType) except +raise_py_error

        # /*!
        # \brief Retrieves a grab result according to the strategy, waits if it is not yet available
        #
        # <ul>
        # <li> The content of the passed grab result is released.
        # <li> If no %Pylon device is attached or the grabbing is not started, the method returns immediately "false".
        # <li> Wait for a grab result if it is not yet available. The access to the camera is not locked during waiting. Camera events are handled.
        # <li> Only if camera events are used: Incoming camera events are handled.
        # <li> One grab result is retrieved per call according to the strategy applied.
        # <li> Only if chunk mode is used: The chunk data parsing is performed. The grab result data is updated using chunk data.
        # <li> The image event OnImagesSkipped is fired if grab results have been skipped according to the strategy. The notification of event handlers stops when an event call triggers an exception.
        # <li> The image event OnImageGrabbed is fired if a grab result becomes available. The notification of event handlers stops when an event call triggers an exception.
        # <li> Stops the grabbing by calling StopGrabbing() if the maximum number of images has been grabbed.
        # </ul>
        #
        # It needs to be checked whether the grab represented by the grab result has been successful, see CGrabResultData::GrabSucceeded().
        #
        # \param[in]  timeoutMs  A timeout value in ms for waiting for a grab result, or the INFINITE value.
        # \param[out] grabResult  Receives the grab result.
        # \param[in]  timeoutHandling  If timeoutHandling equals TimeoutHandling_ThrowException, a timeout exception is thrown on timeout.
        #
        # \return True if the call successfully retrieved a grab result, false otherwise.
        #
        # \pre
        # <ul>
        # <li> There is no other thread waiting for a result. This will be the case when the Instant Camera grab loop thread is used.
        # </ul>
        #
        # \post
        # <ul>
        # <li> If a grab result has been retrieved, one image is removed from the output queue and is returned in the grabResult parameter.
        # <li> If no grab result has been retrieved, an empty grab result is returned in the grabResult parameter.
        # <li> If the maximum number of images has been grabbed, the grabbing is stopped.
        # <li> If camera event handling is enabled and camera events were received, at least one or more camera event messages have been processed.
        # </ul>
        #
        # \error
        #     The Instant Camera object is still valid after error. The grabbing is stopped if an exception is thrown.
        #
        # \threading
        #     This method is synchronized using the lock provided by GetLock() while not waiting.
        # */
        bool RetrieveResult( unsigned int timeoutMs, CBaslerUsbGrabResultPtr& grabResult)  except +raise_py_error
        bool RetrieveResult( unsigned int timeoutMs, CBaslerUsbGrabResultPtr& grabResult, ETimeoutHandling timeoutHandling)  except +raise_py_error

        # /*!
        # \brief Stops the grabbing of images.
        #
        # <ul>
        # <li> Nothing is done if the Instant Camera is not currently grabbing.
        # <li> The configuration event OnGrabStop is fired. Possible C++ exceptions from event calls are caught and ignored. All event handlers are notified.
        # <li> The grabbing is stopped.
        # <li> All buffer queues of the Instant Camera are cleared.
        # <li> The OnGrabStopped configuration event is fired if the grab has been stopped successfully. Possible C++ exceptions from event calls are caught and ignored. All event handlers are notified.
        # <li> If the Instant Camera has been opened by StartGrabbing, it is closed by calling Close().
        # <li> Grab-specific parameters of the camera object are unlocked, e.g. MaxNumBuffers.
        # </ul>
        #
        # \post
        # <ul>
        # <li> The grabbing is stopped.
        # <li> If the %Pylon device has been opened by StartGrabbing and no other camera object service requires it to be open, it is closed.
        # <li> Grab specific parameters of the camera object are unlocked, e.g. MaxNumBuffers.
        # </ul>
        #
        # \error
        #     Does not throw C++ exceptions. Possible C++ exceptions are caught and ignored.
        #
        # \threading
        #     This method is synchronized using the lock provided by GetLock().
        # */
        void StopGrabbing() except +raise_py_error

        # /*!
        # \brief Returns state of grabbing.
        #
        # The camera object is grabbing after a successful call to StartGrabbing() until StopGrabbing() is called.
        #
        # \return Returns true if still grabbing.
        #
        # \error
        #     Does not throw C++ exceptions.
        #
        # \threading
        #     This method is synchronized using the lock provided by GetLock().
        # */
        bool IsGrabbing()  except +raise_py_error

        # /*!
        # \brief Grabs one image.
        #
        # The following code shows a simplified version of what is done (happy path):
        #
        # \code
        #     //grab one image
        #     StartGrabbing( 1, GrabStrategy_OneByOne, GrabLoop_ProvidedByUser);
        #
        #     //grab is stopped automatically due to maxImages = 1
        #     return RetrieveResult( timeoutMs, grabResult, timeoutHandling) && grabResult->GrabSucceeded();
        # \endcode
        #
        # GrabOne() can be used to together with the CAcquireSingleFrameConfiguration.
        #
        # \note Using GrabOne is more efficient if the %Pylon device is already open, otherwise the %Pylon device is opened and closed for each call.
        #
        # \note Grabbing single images using Software Trigger (CSoftwareTriggerConfiguration) is recommended if you want to maximize frame rate.
        #       This is because the overhead per grabbed image is reduced compared to Single Frame Acquisition.
        #       The grabbing can be started using StartGrabbing().
        #       Images are grabbed using the WaitForFrameTriggerReady(), ExecuteSoftwareTrigger() and RetrieveResult() methods instead of using GrabOne.
        #       The grab can be stopped using StopGrabbing() when done.
        #
        # \param[in]  timeoutMs  A timeout value in ms for waiting for a grab result, or the INFINITE value.
        # \param[out] grabResult  Receives the grab result.
        # \param[in]  timeoutHandling  If timeoutHandling equals TimeoutHandling_ThrowException, a timeout exception is thrown on timeout.
        #
        # \return Returns true if the call successfully retrieved a grab result and the grab succeeded (CGrabResultData::GrabSucceeded()).
        #
        # \pre Must meet the preconditions of start grabbing.
        # \post Meets the postconditions of stop grabbing.
        #
        # \error
        #     The Instant Camera object is still valid after error. See StartGrabbing(), RetrieveResult(), and StopGrabbing() .
        #     In the case of exceptions after StartGrabbing() the grabbing is stopped using StopGrabbing().
        # */
        bool GrabOne( unsigned int timeoutMs, CBaslerUsbGrabResultPtr& grabResult) except +raise_py_error
        bool GrabOne( unsigned int timeoutMs, CBaslerUsbGrabResultPtr& grabResult, ETimeoutHandling timeoutHandling) except +raise_py_error



        # /*!
        # \brief Provides access to a wait object indicating available grab results.
        #
        # \return A wait object indicating available grab results.
        #
        # \error
        #     Does not throw C++ exceptions.
        #
        # \threading
        #     This method is synchronized using the lock provided by GetLock().
        # */
        WaitObject& GetGrabResultWaitObject()

      # /*!
      #   \brief Provides access to a wait object indicating that the grabbing has stopped.
      #
      #   \return A wait object indicating that the grabbing has stopped.
      #
      #   \error
      #       Does not throw C++ exceptions.
      #
      #   \threading
      #       This method is synchronized using the lock provided by GetLock().
      #   */
        WaitObject& GetGrabStopWaitObject()

        # /*!
        # \brief Provides access to a wait object indicating available camera events.
        #
        # This wait object is %Pylon device specific and changes when a new %Pylon device is attached to
        # the camera.
        #
        # \return A wait object indicating available camera events.
        #
        # \pre
        # <ul>
        # <li> A %Pylon device is attached.
        # <li> The %Pylon device is open.
        # </ul>
        #
        # \error
        #     The Instant Camera object is still valid after error.
        #
        # \threading
        #     This method is synchronized using the lock provided by GetLock().
        # */
        WaitObject& GetCameraEventWaitObject()

        # //Event handling--------------------------------------------------------
        #
        # /*!
        # \brief Adds a configurator to the list of registered configurator objects.
        #
        # <ul>
        # <li> If mode equals RegistrationMode_ReplaceAll, the list of registered configurators is cleared.
        # <li> If pointer \c pConfigurator is not NULL, it is appended to the list of configurators.
        # </ul>
        #
        # \param[in]  pConfigurator  The receiver of configuration events.
        # \param[in]  mode  Indicates how to register the new configurator.
        # \param[in]  cleanupProcedure If cleanupProcedure equals Cleanup_Delete, the passed event handler is deleted when no longer needed.
        #
        # \post The configurator is registered and called on configuration events.
        #
        # \error
        #     Does not throw C++ exceptions, except when memory allocation fails.
        #
        # \threading
        #     This method is synchronized using the lock provided by GetLock().
        # */
        void RegisterConfiguration( CBaslerUsbConfigurationEventHandler* pConfigurator, ERegistrationMode mode, ECleanup cleanupProcedure) except +raise_py_error
        void RegisterConfiguration( CConfigurationEventHandler* pConfigurator, ERegistrationMode mode, ECleanup cleanupProcedure) except +raise_py_error

        # /*!
        # \brief Removes a configurator from the list of registered configurator objects.
        #
        # If the configurator is not found, nothing is done.
        #
        # \param[in]  configurator  The registered receiver of configuration events.
        #
        # \return True if successful
        #
        # \post
        # <ul>
        # <li> The configurator is deregistered.
        # <li> If the configuration has been registered by passing a pointer and the cleanup procedure is Cleanup_Delete, the event handler is deleted.
        # </ul>
        #
        # \error
        #     Does not throw C++ exceptions.
        #
        # \threading
        #     This method is synchronized using the lock provided by GetLock().
        # */
        bool DeregisterConfiguration( CBaslerUsbConfigurationEventHandler* configurator) except +raise_py_error
		bool DeregisterConfiguration( CConfigurationEventHandler* configurator) except +raise_py_error
		
        # /*!
        # \brief Adds an image event handler to the list of registered image event handler objects.
        #
        # <ul>
        # <li> If mode equals RegistrationMode_ReplaceAll, the list of registered image event handlers is cleared.
        # <li> If pointer \c pImageEventHandler is not NULL, it is appended to the list of image event handlers.
        # </ul>
        #
        # \param[in]  pImageEventHandler  The receiver of image events.
        # \param[in]  mode  Indicates how to register the new imageEventHandler.
        # \param[in]  cleanupProcedure If cleanupProcedure equals Cleanup_Delete, the passed event handler is deleted when no longer needed.
        #
        # \post The imageEventHandler is registered and called on image related events.
        #
        # \error
        #     Does not throw C++ exceptions, except when memory allocation fails.
        #
        # \threading
        #     This method is synchronized using the internal image event handler registry lock.
        # */
        void RegisterImageEventHandler( CBaslerUsbImageEventHandler* pImageEventHandler, ERegistrationMode mode, ECleanup cleanupProcedure) except +raise_py_error
        void RegisterImageEventHandler( CImageEventHandler* pImageEventHandler, ERegistrationMode mode, ECleanup cleanupProcedure) except +raise_py_error

        # /*!
        # \brief Removes an image event handler from the list of registered image event handler objects.
        #
        # If the image event handler is not found, nothing is done.
        #
        # \param[in]  imageEventHandler  The registered receiver of configuration events.
        #
        # \return True if successful
        #
        # \post
        # <ul>
        # <li> The imageEventHandler is deregistered.
        # <li> If the image event handler has been registered by passing a pointer and the cleanup procedure is Cleanup_Delete, the event handler is deleted.
        # </ul>
        #
        # \error
        #     Does not throw C++ exceptions.
        #
        # \threading
        #     This method is synchronized using the internal image event handler registry lock.
        # */
        bool DeregisterImageEventHandler( CBaslerUsbImageEventHandler* imageEventHandler) except +raise_py_error
        bool DeregisterImageEventHandler( CImageEventHandler* imageEventHandler) except +raise_py_error


        # /*!
        # \brief Adds an camera event handler to the list of registered camera event handler objects.
        #
        # <ul>
        # <li> If mode equals RegistrationMode_ReplaceAll, the list of registered camera event handlers is cleared.
        # <li> If the pointer \c pCameraEventHandler is not NULL, it is appended to the list of camera event handlers.
        # </ul>
        #
        # \param[in]  pCameraEventHandler  The receiver of camera events.
        # \param[in]  nodeName  The name of the event data node updated on camera event, e.g. "ExposureEndEventTimestamp" for exposure end event.
        # \param[in]  userProvidedId  This ID is passed as a parameter in CCameraEventHandler::OnCameraEvent and can be used to distinguish between different events.
        #                             It is recommended to create an own application specific enum and use it's values as IDs.
        # \param[in]  mode  Indicates how to register the new cameraEventHandler.
        # \param[in]  cleanupProcedure If cleanupProcedure equals Cleanup_Delete, the passed event handler is deleted when no longer needed.
        # \param[in]  availability  If availability equals CameraEventAvailability_Mandatory, the camera must support the data node specified by node name.
        #                           If not, an exception is thrown when the Instant Camera is open, the Instant Camera is opened, or an open %Pylon device is attached.
        #
        # Internally, a GenApi node call back is registered for the node identified by \c nodeName.
        # This callback triggers a call to the \c CCameraEventHandler::OnCameraEvent() method.
        # That's why a Camera Event Handler can be registered for any node of the camera node map to get informed about changes.
        #
        # \post The cameraEventHandler is registered and called on camera events.
        #
        # \error
        #     Throws an exception if the availability is set to CameraEventAvailability_Mandatory and the node with the name \c nodeName is not available in the camera node map (see GetNodeMap()).
        #     Throws an exception fail if the node callback registration fails.
        #     The event handler is not registered when an C++ exception is thrown.
        #
        # \threading
        #     This method is synchronized using the camera event handler lock. If the camera is open, the lock provided by GetLock() and the camera
        #     node map lock are also used for synchronization.
        # */
        void RegisterCameraEventHandler(
            CBaslerUsbCameraEventHandler* pCameraEventHandler,
            const String_t& nodeName,
            intptr_t userProvidedId,
            ERegistrationMode mode,
            ECleanup cleanupProcedure,
            ECameraEventAvailability availability) except +raise_py_error

        void RegisterCameraEventHandler(
            CCameraEventHandler* pCameraEventHandler,
            const String_t& nodeName,
            intptr_t userProvidedId,
            ERegistrationMode mode,
            ECleanup cleanupProcedure,
            ECameraEventAvailability availability) except +raise_py_error

        #void RegisterCameraEventHandler(
        #    CBaslerUsbCameraEventHandler* pCameraEventHandler,
        #    const String_t& nodeName,
        #    intptr_t userProvidedId,
        #    ERegistrationMode mode,
        #    ECleanup cleanupProcedure) except +raise_py_error

        #void RegisterCameraEventHandler(
        #    CCameraEventHandler* pCameraEventHandler,
        #    const String_t& nodeName,
        #    intptr_t userProvidedId,
        #    ERegistrationMode mode,
        #    ECleanup cleanupProcedure) except +raise_py_error

        # /*!
        # \brief Removes a camera event handler from the list of registered camera event handler objects.
        #
        # If the camera event handler is not found, nothing is done.
        #
        # \param[in]  cameraEventHandler  The registered receiver of camera events.
        # \param[in]  nodeName  The name of the event data node updated on camera event, e.g. "ExposureEndEventTimestamp" for exposure end event.
        #
        # \return True if successful
        #
        # \post
        # <ul>
        # <li> The cameraEventHandler is deregistered.
        # <li> If the camera event handler has been registered by passing a pointer and the cleanup procedure is Cleanup_Delete, the event handler is deleted.
        # </ul>
        #
        # \error
        #     Does not throw C++ exceptions.
        #
        # \threading
        # This method is synchronized using the camera event handler lock. If the camera is open, the camera node map lock
        # is also used for synchronization.
        # */
        bool DeregisterCameraEventHandler( CBaslerUsbCameraEventHandler* cameraEventHandler, const String_t& nodeName) except +raise_py_error
        bool DeregisterCameraEventHandler( CCameraEventHandler* cameraEventHandler, const String_t& nodeName) except +raise_py_error


        # //Additional features---------------------------------------------------
        #
        # /*!
        # \brief Actively waits until the the camera is ready to accept a frame trigger.
        #
        # The implementation selects 'FrameTriggerWait' for the 'AcquisitionStatusSelector'
        # and waits until the 'AcquisitionStatus' is true.
        # If the above mentioned nodes are not available and the 'SoftwareTrigger' node is readable,
        # the implementation waits for SoftwareTrigger.IsDone().
        #
        # The WaitForFrameTriggerReady method does not work for A600 Firewire cameras.
        #
        # \param[in]  timeoutMs The timeout in ms for active waiting.
        # \param[in]  timeoutHandling  If timeoutHandling equals TimeoutHandling_ThrowException, a timeout exception is thrown on timeout.
        # \return True if the camera can execute a frame trigger.
        #
        # \pre The 'AcquisitionStatusSelector' node is writable and the 'AcquisitionStatus' node is readable or the 'SoftwareTrigger' node is readable.
        #      This depends on the used camera model.
        #
        # \error
        #     Accessing the camera registers may fail.
        #
        # \threading
        #     This method is synchronized using the lock provided by GetLock().
        # */
        bool WaitForFrameTriggerReady( unsigned int timeoutMs, ETimeoutHandling timeoutHandling) except +raise_py_error

        # /*!
        # \brief Checks to see whether the camera device can be queried whether it is ready to accept the next frame trigger.
        #
        # If 'FrameTriggerWait' can be selected for 'AcquisitionStatusSelector' and 'AcquisitionStatus' is readable, the
        # camera device can be queried whether it is ready to accept the next frame trigger.
        #
        # If the nodes mentioned above are not available and the 'SoftwareTrigger' node is readable, the
        # camera device can be queried whether it is ready to accept the next frame trigger.
        #
        # \note If a camera device can't be queried whether it is ready to accept the next frame trigger, the camera device is
        # ready to accept the next trigger after the last image triggered has been grabbed, e.g. after you have retrieved
        # the last image triggered using RetrieveResult(). Camera devices that can be queried whether they are ready to accept the
        # next frame trigger, may not be ready for the next frame trigger after the last image triggered has been grabbed.
        #
        # \return Returns true if the camera is open and the camera device can be queried whether it is ready to accept the next frame trigger.
        #
        # \post The 'AcquisitionStatusSelector' is set to 'FrameTriggerWait' if writable.
        #
        # \error
        # Accessing the camera registers may fail.
        #
        # \threading
        # This method is synchronized using the lock provided by GetLock().
        # */
        bool CanWaitForFrameTriggerReady() except +raise_py_error

        # /*!
        # \brief Executes the software trigger command.
        #
        # The camera needs to be configured for software trigger mode.
        # Additionally, the camera needs to be ready to accept triggers.
        # When triggering a frame this can be checked using the WaitForFrameTriggerReady() method;
        #
        # \note The application has to make sure that the correct trigger is selected
        #       before calling ExecuteSoftwareTrigger().
        #       This can be done via the camera's TriggerSelector node.
        #       The \c Pylon::CSoftwareTriggerConfiguration
        #       selects the correct trigger when the Instant Camera is opened.
        #
        # \pre
        # <ul>
        # <li> The grabbing is started.
        # <li> The camera device supports software trigger.
        # <li> The software trigger is available. This depends on the configuration of the camera device.
        # </ul>
        #
        # \error
        #     Accessing the camera registers may fail. Throws an exception on timeout if \c timeoutHandling is TimeoutHandling_ThrowException.
        #
        # \threading
        #     This method is synchronized using the lock provided by GetLock().
        # */
        void ExecuteSoftwareTrigger()

        # /*!
        # \brief Sets a context that is attached to each grab result of the camera object on RetrieveResult().
        # This is useful when handling multiple cameras. It has nothing in common with the context passed to the stream grabber when queuing a buffer.
        #
        # \error
        #     Does not throw C++ exceptions.
        #
        # \threading
        #     This method is synchronized using the lock provided by GetLock().
        # */
        void SetCameraContext( intptr_t context) except +raise_py_error

        # /*!
        # \brief Returns the context that is attached to each grab result of the camera object
        #
        # \error
        #     Does not throw C++ exceptions.
        #
        # \threading
        #     This method is synchronized using the lock provided by GetLock().
        # */
        intptr_t GetCameraContext() except +raise_py_error

        # /*!
        # \brief Provides access to the device info object of the attached %Pylon device or an empty one.
        # \return The info object of the attached %Pylon device or an empty one.
        #
        # \error
        #     Does not throw C++ exceptions.
        #
        # \threading
        #     This method is synchronized using the lock provided by GetLock().
        # */
        CDeviceInfo& GetDeviceInfo()

        # /*!
        # \brief Provides access to the node map of the camera device.
        #
        # The %Pylon device must be opened before reading ore writing any parameters of the camera device.
        # This can be done using the Open() method of the Instant Camera class.
        #
        # \return Reference to the node map of the camera device.
        #
        # \pre A %Pylon device is attached.
        #
        # \error
        #     The Instant Camera object is still valid after error.
        #
        # \threading
        #     This method is synchronized using the lock provided by GetLock().
        # */
        INodeMap& GetNodeMap()


        # /*!
        # \brief Provides access to the transport layer node map of the attached %Pylon device.
        # \return Reference to the transport layer node map of the attached %Pylon device
        #     or the reference to the empty node map if a transport layer node map is not supported.
        #     The GENAPI_NAMESPACE::INodeMap::GetNumNodes() method can be used to check whether the node map is empty.
        #
        # \pre A %Pylon device is attached.
        #
        # \error
        #     The Instant Camera object is still valid after error.
        #
        # \threading
        #     This method is synchronized using the lock provided by GetLock().
        # */
        INodeMap& GetTLNodeMap()

        # /*!
        # \brief Provides access to the stream grabber node map of the attached %Pylon device.
        # \return Reference to the stream grabber node map of the attached %Pylon device
        #     or the reference to the empty node map if grabbing is not supported.
        #     The GENAPI_NAMESPACE::INodeMap::GetNumNodes() method can be used to check whether the node map is empty.
        #
        # \pre
        # <ul>
        # <li> A %Pylon device is attached.
        # <li> The %Pylon device is open.
        # </ul>
        #
        # \error
        #     The Instant Camera object is still valid after error.
        #
        # \threading
        #     This method is synchronized using the lock provided by GetLock().
        # */
        INodeMap& GetStreamGrabberNodeMap()

        # /*!
        # \brief Provides access to the event grabber node map of the attached %Pylon device.
        # \return Reference to the event grabber node map of the attached %Pylon device
        #     or a reference to the empty node map if event grabbing is not supported.
        #     The GENAPI_NAMESPACE::INodeMap::GetNumNodes() method can be used to check whether the node map is empty.
        #
        # \pre
        # <ul>
        # <li> A %Pylon device is attached.
        # <li> The %Pylon device is open.
        # </ul>
        #
        # \error
        #     The Instant Camera object is still valid after error.
        #
        # \threading
        #     This method is synchronized using the lock provided by GetLock().
        # */
        INodeMap& GetEventGrabberNodeMap()

        # /*!
        # \brief Provides access to the node map of the Instant Camera object.
        #
        # The node map of the camera device is made available by the GetNodeMap() method.
        #
        # \return Reference to the node map of the Instant Camera object.
        #
        # \error
        #     Does not throw C++ exceptions.
        #
        # \threading
        #     This method is synchronized using the lock provided by GetLock().
        # */
        INodeMap& GetInstantCameraNodeMap()
        #INodeMap& GetInstantCameraNodeMap()
        #void SetBufferFactory( IBufferFactory* pFactory, ECleanup cleanupProcedure = Cleanup_Delete)



        # /*!
        # \brief Returns true if a USB %Pylon device is attached to the Instant Camera object.
        #
        # This method is provided for convenience only. The device type can also be determined as shown in the following example.
        #
        # \code
        # #include <pylon/DeviceClass.h>
        # ...
        # if (camera.GetDeviceInfo().GetDeviceClass() == BaslerUsbDeviceClass)
        # {
        # ...
        # }
        # \endcode
        #
        # \threading
        # This method is synchronized using the lock provided by GetLock().
        # */
        bool IsUsb() except +raise_py_error
        #VersionInfo GetSfncVersion() const


