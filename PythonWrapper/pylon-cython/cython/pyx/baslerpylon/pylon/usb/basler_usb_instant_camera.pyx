from pylon.cdevice cimport IPylonDevice
from baslerpylon.pylon.usb.basler_usb_device_info cimport BaslerUsbDeviceInfo
from baslerpylon.pylon.property_map cimport PropertyMap
from baslerpylon.pylon.usb.basler_usb_grab_result cimport BaslerUsbGrabResult
from baslerpylon.pylon.device cimport Device
from genapi.cinode_map cimport INodeMap
from baslerpylon.pylon.camera_enum cimport ERegistrationMode, ECleanup, Cleanup_None, EGrabStrategy, GrabStrategy_OneByOne, EGrabLoop, GrabLoop_ProvidedByUser, ETimeoutHandling, TimeoutHandling_ThrowException
from baslerpylon.pylon.usb.basler_usb_camera_event_handler cimport BaslerUsbCameraEventHandler
from base.cgcbase cimport gcstring
from baslerpylon.pylon.usb.basler_usb_image_event_handler cimport BaslerUsbImageEventHandler
from pylon.usb.cbasler_usb_device_info cimport CBaslerUsbDeviceInfo
from cython.operator cimport dereference as deref
from pylon.usb.cbasler_usb_instant_camera cimport CBaslerUsbInstantCamera
from baslerpylon.pylon.property_map cimport vector
from utility.ccamerautility cimport CCameraUtility
from baslerpylon.pylon.configuration_event_handler cimport ConfigurationEventHandler
from baslerpylon.pylon.wait_object cimport PyWaitObject
from baslerpylon.pylon.image_event_handler cimport ImageEventHandler
from baslerpylon.pylon.camera_event_handler cimport CameraEventHandler
from baslerpylon.pylon.configuration_event_handler cimport ConfigurationEventHandler
from baslerpylon.pylon.usb.basler_usb_configuration_event_handler  cimport BaslerUsbConfigurationEventHandler
from pylon.cwait_object cimport WaitObject
from base.cgcbase cimport vector

cdef class BaslerUsbInstantCamera:



    @staticmethod
    cdef create(IPylonDevice* device, ECleanup eCleanup = Cleanup_None):
        obj =  BaslerUsbInstantCamera()
        obj.camera.Attach(device, eCleanup)
        cdef vector[INodeMap*] maps
        maps.push_back(<INodeMap*>&obj.camera.GetNodeMap())
        maps.push_back(<INodeMap*>&obj.camera.GetInstantCameraNodeMap())
        #maps[:] = [obj.camera.GetNodeMap(),obj.camera.GetInstantCameraNodeMap()]
        obj.propertyMap = PropertyMap.create_maps(maps)
        return obj

    @staticmethod
    def create_cam(Device device):
        return BaslerUsbInstantCamera.create(device.ipython_device)

    #@staticmethod
    #cdef create_cam_from_caminstant(CBaslerUsbInstantCamera &camera):
    #    obj =  BaslerUsbInstantCamera()
    #    obj.camera =  deref(<CBaslerUsbInstantCamera*>&camera)
    #    return obj
	
    cdef CBaslerUsbInstantCamera* get_ccamera(self):
        return &self.camera
		
    #def attach(self, Device device):
    #    self.camera.Attach(device.ipython_device)

	        #
        # Opened by user flag is set, preventing closing of the device on StopGrabbing().
        # If the %Pylon device is already open, nothing more is done.
        # The OnOpen configuration event is fired. The notification of event handlers stops when an event call triggers an exception.
        # The %Pylon device is opened.
        # A device removal call back is registered at the %Pylon device.
        # Callbacks for camera events are registered at the camera node map.
        # The OnOpened configuration event is fired if the %Pylon device has been opened successfully. The notification of event handlers stops when an event call triggers an exception.
        #

        #pre A %Pylon device is attached.

        #post
        #
        # The %Pylon device is open.
        # Opened by user flag is set, preventing closing of the %Pylon device on StopGrabbing().
        #
		
    def open(self):
        if not self.opened:
            self.camera.Open()

        #brief Closes the attached %Pylon device.

        #
        # If no %Pylon device is attached, nothing is done.
        # If the %Pylon device is already closed, nothing is done.
        # If a grab is in progress, it is stopped by calling StopGrabbing().
        # The configuration event OnClose is fired. Possible C++ exceptions from event calls are caught and ignored. All event handlers are notified.
        # The %Pylon device is closed.
        # The configuration event OnClosed is fired if the %Pylon device has been closed successfully. Possible C++ exceptions from event calls are caught and ignored. All event handlers are notified.
        #

        #post The %Pylon device is closed.			
    def close(self):
        self.camera.Close()

    def __del__(self):
        self.close()
        self.camera.DetachDevice()
        self.camera.DestroyDevice()
        self.camera.Destructor()

    def __repr__(self):
        return '<Camera {0} open={1}>'.format(self.device_info.friendly_name, self.opened)

	#
    #brief Starts the grabbing of images.
        #
        # If a grab loop thread has been used in the last grab session, the grab loop thread context is joined with the caller's context.
        # If the %Pylon device is not already open, it is opened by calling Open().
        # The configuration event OnGrabStart is fired. The notification of event handlers stops when an event call triggers an exception.
        # Grab-specific parameters of the camera object are locked, e.g. MaxNumBuffers.
        # If the camera device parameter ChunkModeActive is enabled, the Instant Camera chunk parsing support is initialized.
        # If the Instant Camera parameter GrabCameraEvents is enabled, the Instant Camera event grabbing support is initialized.
        # The grabbing is started.
        # The configuration event OnGrabStarted is fired if the grab has been started successfully. The notification of event handlers stops when an event call triggers an exception.
        # If grabLoopType equals GrabLoop_ProvidedByInstantCamera, an additional grab loop thread is started calling RetrieveResult( GrabLoopThreadTimeout, grabResult) in a loop.
        #


        #pre
        #
        # A %Pylon device is attached.
        # The stream grabber of the %Pylon device is closed.
        # The grabbing is stopped.
        # The attached %Pylon device supports grabbing.
        # Must not be called while holding the lock provided by GetLock() when using the grab loop thread.
        #

        #post
        #
        # The grabbing is started.
        # Grab-specific parameters of the camera object are locked, e.g. MaxNumBuffers.
        # If grabLoopType equals GrabLoop_ProvidedByInstantCamera, an additional grab loop thread is running that calls RetrieveResult( GrabLoopThreadTimeout, grabResult) in a loop. Images are processed by registered image event handlers.
        # Operating the stream grabber from outside the camera object will result in undefined behavior.
        #

    def start_grabbing(self, size_t nr_images = 0, EGrabStrategy grabStrategy = GrabStrategy_OneByOne, EGrabLoop grabLoopType = GrabLoop_ProvidedByUser):

        #if not self.opened:
        #    raise Exception('Operation Invalid', 'Camera is not open')

        #if self.camera.IsGrabbing():
        #    raise Exception('Operation Invalid', 'Camera is grabbing')

        if nr_images is not 0:
            self.camera.StartGrabbing(nr_images, grabStrategy, grabLoopType)
        else:
            self.camera.StartGrabbing(grabStrategy, grabLoopType)

        /*!
        \brief Stops the grabbing of images.

        #
        # Nothing is done if the Instant Camera is not currently grabbing.
        # The configuration event OnGrabStop is fired. Possible C++ exceptions from event calls are caught and ignored. All event handlers are notified.
        # The grabbing is stopped.
        # All buffer queues of the Instant Camera are cleared.
        # The OnGrabStopped configuration event is fired if the grab has been stopped successfully. Possible C++ exceptions from event calls are caught and ignored. All event handlers are notified.
        # If the Instant Camera has been opened by StartGrabbing, it is closed by calling Close().
        # Grab-specific parameters of the camera object are unlocked, e.g. MaxNumBuffers.
        #

        \post
        #
        # The grabbing is stopped.
        # If the %Pylon device has been opened by StartGrabbing and no other camera object service requires it to be open, it is closed.
        # Grab specific parameters of the camera object are unlocked, e.g. MaxNumBuffers.
        #
    def stop_grabbing(self):
        self.camera.StopGrabbing()


        /*!
        \brief Returns state of grabbing.

        The camera object is grabbing after a successful call to StartGrabbing() until StopGrabbing() is called.

        \return Returns true if still grabbing.

    def is_grabbing(self):
        return self.camera.IsGrabbing();

      /*!
        \brief Grabs one image.

        The following code shows a simplified version of what is done (happy path):

        \code
            //grab one image
            StartGrabbing( 1, GrabStrategy_OneByOne, GrabLoop_ProvidedByUser);

            //grab is stopped automatically due to maxImages = 1
            return RetrieveResult( timeoutMs, grabResult, timeoutHandling) && grabResult->GrabSucceeded();
        \endcode

        GrabOne() can be used to together with the CAcquireSingleFrameConfiguration.

        \note Using GrabOne is more efficient if the %Pylon device is already open, otherwise the %Pylon device is opened and closed for each call.

        \note Grabbing single images using Software Trigger (CSoftwareTriggerConfiguration) is recommended if you want to maximize frame rate.
              This is because the overhead per grabbed image is reduced compared to Single Frame Acquisition.
              The grabbing can be started using StartGrabbing().
              Images are grabbed using the WaitForFrameTriggerReady(), ExecuteSoftwareTrigger() and RetrieveResult() methods instead of using GrabOne.
              The grab can be stopped using StopGrabbing() when done.

        \param[in]  timeoutMs  A timeout value in ms for waiting for a grab result, or the INFINITE value.
        \param[out] grabResult  Receives the grab result.
        \param[in]  timeoutHandling  If timeoutHandling equals TimeoutHandling_ThrowException, a timeout exception is thrown on timeout.

        \return Returns true if the call successfully retrieved a grab result and the grab succeeded (CGrabResultData::GrabSucceeded()).

        \pre Must meet the preconditions of start grabbing.
        \post Meets the postconditions of stop grabbing.

        \error
            The Instant Camera object is still valid after error. See StartGrabbing(), RetrieveResult(), and StopGrabbing() .
            In the case of exceptions after StartGrabbing() the grabbing is stopped using StopGrabbing().
        */
		
    def grab_one(self, unsigned int timeoutMs, BaslerUsbGrabResult grabResult, ETimeoutHandling timeoutHandling = TimeoutHandling_ThrowException):
        #if not self.camera.IsOpen():
        #    raise Exception('Operation Invalid', 'Camera is not open')

        return self.camera.GrabOne(timeoutMs, (grabResult.cgrabresultptr), timeoutHandling)

        /*!
        \brief Retrieves a grab result according to the strategy, waits if it is not yet available

        #
        # The content of the passed grab result is released.
        # If no %Pylon device is attached or the grabbing is not started, the method returns immediately "false".
        # Wait for a grab result if it is not yet available. The access to the camera is not locked during waiting. Camera events are handled.
        # Only if camera events are used: Incoming camera events are handled.
        # One grab result is retrieved per call according to the strategy applied.
        # Only if chunk mode is used: The chunk data parsing is performed. The grab result data is updated using chunk data.
        # The image event OnImagesSkipped is fired if grab results have been skipped according to the strategy. The notification of event handlers stops when an event call triggers an exception.
        # The image event OnImageGrabbed is fired if a grab result becomes available. The notification of event handlers stops when an event call triggers an exception.
        # Stops the grabbing by calling StopGrabbing() if the maximum number of images has been grabbed.
        #

        It needs to be checked whether the grab represented by the grab result has been successful, see CGrabResultData::GrabSucceeded().

        \param[in]  timeoutMs  A timeout value in ms for waiting for a grab result, or the INFINITE value.
        \param[out] grabResult  Receives the grab result.
        \param[in]  timeoutHandling  If timeoutHandling equals TimeoutHandling_ThrowException, a timeout exception is thrown on timeout.

        \return True if the call successfully retrieved a grab result, false otherwise.

        \pre
        #
        # There is no other thread waiting for a result. This will be the case when the Instant Camera grab loop thread is used.
        #

        \post
        #
        # If a grab result has been retrieved, one image is removed from the output queue and is returned in the grabResult parameter.
        # If no grab result has been retrieved, an empty grab result is returned in the grabResult parameter.
        # If the maximum number of images has been grabbed, the grabbing is stopped.
        # If camera event handling is enabled and camera events were received, at least one or more camera event messages have been processed.
        #

        \error
            The Instant Camera object is still valid after error. The grabbing is stopped if an exception is thrown.

        \threading
            This method is synchronized using the lock provided by GetLock() while not waiting.
        */
    def retrieve_result(self, unsigned int timeoutMs, BaslerUsbGrabResult grabResult, ETimeoutHandling timeoutHandling = TimeoutHandling_ThrowException):
        result = self.camera.RetrieveResult(timeoutMs, (grabResult.cgrabresultptr) ,timeoutHandling)
        return result
        #if not result:
        #    raise Exception('Operation Invalid', 'Cannot retreive Grab Result')

    #def set_value(self, property, value):
    #    attr = getattr(self,property)
    #    attr.SetValue(value)

    #def get_value(self,property):
    #    attr = getattr(self,property)
    #    return attr.GetValue()

    #def destroy_device(self):
    #    self.camera.DestroyDevice()


    #def get_node(self, key):
    #    return  self.propertyMap.get_node(key)

        /*!
        \brief Adds an image event handler to the list of registered image event handler objects.

        #
        # If mode equals RegistrationMode_ReplaceAll, the list of registered image event handlers is cleared.
        # If pointer \c pImageEventHandler is not NULL, it is appended to the list of image event handlers.
        #

        \param[in]  pImageEventHandler  The receiver of image events.
        \param[in]  mode  Indicates how to register the new imageEventHandler.
        \param[in]  cleanupProcedure If cleanupProcedure equals Cleanup_Delete, the passed event handler is deleted when no longer needed.

        \post The imageEventHandler is registered and called on image related events.

        \error
            Does not throw C++ exceptions, except when memory allocation fails.

    def register_image_event_handler(self,  image_event_handler, ERegistrationMode mode, ECleanup cleanupProcedure):
        #cdef CImageEventHandler* image = new CSampleChunkTSImageEventHandler()
        if isinstance(image_event_handler, BaslerUsbImageEventHandler):
            self.camera.RegisterImageEventHandler((<BaslerUsbImageEventHandler>image_event_handler).get_image_event_handler_object() ,  mode,  cleanupProcedure)
        elif isinstance(image_event_handler, ImageEventHandler):
            self.camera.RegisterImageEventHandler((<ImageEventHandler>image_event_handler).get_image_event_handler_object() ,  mode,  cleanupProcedure)

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
        # #
        # # The imageEventHandler is deregistered.
        # # If the image event handler has been registered by passing a pointer and the cleanup procedure is Cleanup_Delete, the event handler is deleted.
        # #
        #
        # \error
        #     Does not throw C++ exceptions.
		
    def deregister_image_event_handler(self,  image_event_handler):
        if isinstance(image_event_handler, BaslerUsbImageEventHandler):
            return self.camera.DeregisterImageEventHandler((<BaslerUsbImageEventHandler>image_event_handler).get_image_event_handler_object())
        elif isinstance(image_event_handler, ImageEventHandler):
            return self.camera.DeregisterImageEventHandler((<ImageEventHandler>image_event_handler).get_image_event_handler_object())

 # /*!
        # \brief Adds an camera event handler to the list of registered camera event handler objects.
        #
        # #
        # # If mode equals RegistrationMode_ReplaceAll, the list of registered camera event handlers is cleared.
        # # If the pointer \c pCameraEventHandler is not NULL, it is appended to the list of camera event handlers.
        # #
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
		
    def register_camera_event_handler(self, camera_event,basestring nodeName,int userProvidedId, ERegistrationMode mode, ECleanup cleanupProcedure):
        cdef bytes btes_name = nodeName.encode()
        if isinstance(camera_event, BaslerUsbCameraEventHandler):
            self.camera.RegisterCameraEventHandler((<BaslerUsbCameraEventHandler>camera_event).get_camera_event_handler_object(),gcstring(btes_name), userProvidedId, mode, cleanupProcedure)
        if isinstance(camera_event, CameraEventHandler):
            self.camera.RegisterCameraEventHandler((<CameraEventHandler>camera_event).get_camera_event_handler_object(),gcstring(btes_name), userProvidedId, mode, cleanupProcedure)

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
        # #
        # # The cameraEventHandler is deregistered.
        # # If the camera event handler has been registered by passing a pointer and the cleanup procedure is Cleanup_Delete, the event handler is deleted.
        # #
        #
        # \error
        #     Does not throw C++ exceptions.
        #
		
    def deregister_camera_event_handler(self,  camera_event,basestring nodeName):
        cdef bytes btes_name = nodeName.encode()
        if isinstance(camera_event, BaslerUsbCameraEventHandler):
            return self.camera.DeregisterCameraEventHandler((<BaslerUsbCameraEventHandler>camera_event).get_camera_event_handler_object(),gcstring(btes_name))
        if isinstance(camera_event, CameraEventHandler):
            return self.camera.DeregisterCameraEventHandler((<CameraEventHandler>camera_event).get_camera_event_handler_object(),gcstring(btes_name))

        # //Event handling--------------------------------------------------------
        #
        # /*!
        # \brief Adds a configurator to the list of registered configurator objects.
        #
        # #
        # # If mode equals RegistrationMode_ReplaceAll, the list of registered configurators is cleared.
        # # If pointer \c pConfigurator is not NULL, it is appended to the list of configurators.
        # #
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
    def register_configuration(self, event,ERegistrationMode mode, ECleanup cleanupProcedure):
        if isinstance(event, BaslerUsbConfigurationEventHandler):
            self.camera.RegisterConfiguration((<BaslerUsbConfigurationEventHandler>event).get_configuration_event_handler_object(), mode, cleanupProcedure)
        if isinstance(event, ConfigurationEventHandler):
            self.camera.RegisterConfiguration((<ConfigurationEventHandler>event).get_configuration_event_handler_object(), mode, cleanupProcedure)

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
        # #
        # # The configurator is deregistered.
        # # If the configuration has been registered by passing a pointer and the cleanup procedure is Cleanup_Delete, the event handler is deleted.
        # #
        #
        # \error
        #     Does not throw C++ exceptions.
        #
    def deregister_configuration(self, ConfigurationEventHandler event):
        if isinstance(event, BaslerUsbConfigurationEventHandler):
            return self.camera.DeregisterConfiguration((<BaslerUsbConfigurationEventHandler>event).get_configuration_event_handler_object())
        if isinstance(event, ConfigurationEventHandler):
            return self.camera.DeregisterConfiguration((<ConfigurationEventHandler>event).get_configuration_event_handler_object())


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
    def wait_for_frame_trigger_ready(self, int timeout, ETimeoutHandling timeoutHandling):
        return self.camera.WaitForFrameTriggerReady(timeout, timeoutHandling)

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
    def can_wait_for_frame_trigger_ready(self):
        return self.camera.CanWaitForFrameTriggerReady()

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
        # #
        # # The grabbing is started.
        # # The camera device supports software trigger.
        # # The software trigger is available. This depends on the configuration of the camera device.
        # #
        #
        # \error
        #     Accessing the camera registers may fail. Throws an exception on timeout if \c timeoutHandling is TimeoutHandling_ThrowException.
        #
    def execute_software_trigger(self):
        self.camera.ExecuteSoftwareTrigger()

	#def capture_images_multiple_cameras(int number_of_images, imageFolder):
	#	CPylonUtility.CaptureImageMultipleCameras(number_of_images, imageFolder)

		
    #def is_readable(self, key):
    #    return  self.propertyMap.is_readable( key)

    #def is_writable(self, key):
    #    return  self.propertyMap.is_writable(key)

    #def is_available(self, key):
    #    return  self.propertyMap.is_writable(key)




   # /*!
        # \brief Provides access to a wait object indicating available grab results.
        #
        # \return A wait object indicating available grab results.
        #
        # \error
        #     Does not throw C++ exceptions.
        #
		
    def get_grab_result_wait_object(self):
        return PyWaitObject.create(<WaitObject*>&self.camera.GetGrabResultWaitObject())

        # /*!
        # \brief Returns the %Pylon device attached state of the Instant Camera object.
        #
        # \return True if a %Pylon device is attached.
        #
        # \error
        #     Does not throw C++ exceptions.
		
    property pylon_device_attached:
        def __get__(self):
            return self.is_pylon_device_attached()
    
	def is_pylon_device_attached(self):
         return self.camera.IsPylonDeviceAttached()

        # /*!
        # \brief Returns the ownership of the attached %Pylon device.
        #
        # \return True if a %Pylon device is attached and the Instant Camera object has been given the ownership
        #         by passing the cleanup procedure Cleanup_Delete when calling Attach().
        #
        # \error
        #     Does not throw C++ exceptions.
        #		 
    property ownership:
        def __get__(self):
            return self.has_owner_ship()

    def has_owner_ship(self):
            return self.camera.HasOwnership()
			
    #property properties:
    #    def __get__(self):
    #         return self.propertyMap

	#return the node map array of the cameras, including: camera.GetNodeMap(), camera.GetInstantCameraNodeMap(), 
    def get_node_map(self):
        return self.propertyMap
            #return PropertyMap.create(<INodeMap*>&self.camera.GetNodeMap())


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
    def get_tl_node_map(self):
        cdef vector[INodeMap*] maps
        maps.push_back(<INodeMap*>&self.camera.GetTLNodeMap())
        return PropertyMap.create_maps(maps)

        # /*!
        # \brief Provides access to the stream grabber node map of the attached %Pylon device.
        # \return Reference to the stream grabber node map of the attached %Pylon device
        #     or the reference to the empty node map if grabbing is not supported.
        #     The GENAPI_NAMESPACE::INodeMap::GetNumNodes() method can be used to check whether the node map is empty.
        #
        # \pre
        # #
        # # A %Pylon device is attached.
        # # The %Pylon device is open.
        # #
        #
        # \error
        #     The Instant Camera object is still valid after error.
        #
    def get_stream_grabber_node_map(self):
        cdef vector[INodeMap*] maps
        maps.push_back(<INodeMap*>&self.camera.GetStreamGrabberNodeMap())
        return PropertyMap.create_maps(maps)

        # /*!
        # \brief Provides access to the event grabber node map of the attached %Pylon device.
        # \return Reference to the event grabber node map of the attached %Pylon device
        #     or a reference to the empty node map if event grabbing is not supported.
        #     The GENAPI_NAMESPACE::INodeMap::GetNumNodes() method can be used to check whether the node map is empty.
        #
        # \pre
        # #
        # # A %Pylon device is attached.
        # # The %Pylon device is open.
        # #
        #
        # \error
        #     The Instant Camera object is still valid after error.
        #
    def get_event_grabber_node_map(self):
        cdef vector[INodeMap*] maps
        maps.push_back(<INodeMap*>&self.camera.GetEventGrabberNodeMap())
        return PropertyMap.create_maps(maps)

        # /*!
        # \brief Provides access to the device info object of the attached %Pylon device or an empty one.
        # \return The info object of the attached %Pylon device or an empty one.
        #
        # \error
        #     Does not throw C++ exceptions.
		
    property device_info:
        def __get__(self):
            return self.get_device_info()

    def get_device_info(self):
            return BaslerUsbDeviceInfo.create_basler_device_info(<CBaslerUsbDeviceInfo*>&(self.camera.GetDeviceInfo()))

    #grab images and save to image_folders. This function is executed in another thread.			
    def capture_images(self, int number_of_images, image_folder, unsigned int time_interval_seconds = 0):
        #cdef CCameraUtility* utility = (new CCameraUtility())
        self.camera_utility.CaptureImage(&self.camera, number_of_images, image_folder, time_interval_seconds)

    #save camera timestamp of the camera array into image folder
    def save_camera_timestamp(self, cameraArray, imageFolder):
        cdef vector[CBaslerUsbInstantCamera*] cameraVector
        for camera in cameraArray:
            cameraVector.push_back((<BaslerUsbInstantCamera>camera).get_ccamera())
        self.camera_utility.SaveTimeStampToFile(cameraVector,imageFolder)

    #check if the thread creates by function capture_images has finished
    def is_thread_running(self):
        return self.camera_utility.IsThreadRunning()

	#set the flag, so the thread creates by function save_camera_timestamp does not start to capture images
    def lock_capture_image_thread(self):
        return  self.camera_utility.Lock()

    #unlock thread
    def un_lock_capture_image_thread(self):
        return  self.camera_utility.UnLock()


		
    #property opened:
    #    def __get__(self):
    #        return self.camera.IsOpen()
    #    def __set__(self, opened):
    #        if self.opened and not opened:
    #            self.camera.Close()
    #        elif not self.opened and opened:
    #            self.camera.Open()
