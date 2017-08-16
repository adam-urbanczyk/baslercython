cdef extern from "pylon/WaitObject.h" namespace 'Pylon':
    cpdef enum EWaitExResult:
        waitex_timeout  ,# The time-out interval elapsed
        waitex_signaled , # The wait operation completed successfully
        waitex_abandoned ,# Windows only (see MSDN for more information)
        waitex_alerted # The wait was interrupted (Windows: queued APC or I/O completion routine; UNIX: signal)

cdef extern from "pylon/Result.h" namespace 'Pylon':
    cpdef enum EGrabStatus:
        _UndefinedGrabStatus,
        Idle,       # Currently not used.
        Queued,     # Grab request is in the input queue.
        Grabbed,    # Grab request terminated successfully. Buffer is filled with data.
        Canceled,   # Grab request was canceled. Buffer doesn't contain valid data.
        Failed      # Grab request failed. Buffer doesn't contain valid data.

cdef extern from "pylon/InstantCamera.h" namespace 'Pylon':
    #Lists the possible grab strategies.
    cpdef enum EGrabStrategy:
        GrabStrategy_OneByOne,        #< The images are processed in the order of their arrival. This is the default grab strategy.
        GrabStrategy_LatestImageOnly, #< Only the latest image is kept in the output queue, all other grabbed images are skipped.
                                      #< If no image is in the output queue when retrieving an image with \c CInstantCamera::RetrieveResult(),
                                      #< the processing waits for the upcoming image.

        GrabStrategy_LatestImages,   #< This strategy can be used to grab images while keeping only the latest images. If the application does not
                                     #< retrieve all images in time, all other grabbed images are skipped. The CInstantCamera::OutputQueueSize parameter can be used to
                                     #< control how many images can be queued in the output queue. When setting the output queue size to 1, this strategy is equivalent to
                                     #< GrabStrategy_LatestImageOnly grab strategy. When setting the output queue size to CInstantCamera::MaxNumBuffer,
                                     #< this strategy is equivalent to GrabStrategy_OneByOne.

        GrabStrategy_UpcomingImage #< The input buffer queue is kept empty. This prevents grabbing.
                                   #< However, when retrieving an image with a call to the \c CInstantCamera::RetrieveResult() method
                                   #< a buffer is queued into the input queue and then the call waits for the upcoming image.
                                   #< The buffer is removed from the queue on timeout.
                                   #< Hence after the call to the \c CInstantCamera::RetrieveResult() method the input buffer queue is empty again.
                                   #< The upcoming image grab strategy cannot be used together with USB camera devices. See the advanced topics section of
                                   #< the %pylon Programmer's Guide for more information.

    #Defines who deletes a passed object if it is not needed anymore.
    cpdef enum ECleanup:
        Cleanup_None,
        Cleanup_Delete


    #Defines the use of an additional grab loop thread.
    cpdef enum EGrabLoop:
        GrabLoop_ProvidedByInstantCamera, #< The grab loop thread is provided by the Instant Camera. It calls RetrieveResult() in a loop. Grabbed images are processed by registered image event handlers. The grab loop thread is started when the grab starts.
        GrabLoop_ProvidedByUser           #< The user code calls RetrieveResult() in a loop to process grabbed images and camera events.

    #Defines how to register an item.
    cpdef enum ERegistrationMode:
        RegistrationMode_Append,        #< The item is appended to the list of registered items.
        RegistrationMode_ReplaceAll     #< The item replaces all other registered items.

    #Defines how to register a camera event handler.
    cpdef enum ECameraEventAvailability:
        CameraEventAvailability_Mandatory,   #< The camera event must be provided by the camera, otherwise an exception is thrown.
        CameraEventAvailability_Optional     #< The camera event handler is not used if the camera does not support the camera event.

    #Defines how to handle a timeout for a method.
    cpdef enum ETimeoutHandling:
        TimeoutHandling_Return,           #< The method returns on timeout. What data is returned can be found in the documentation of the method.
        TimeoutHandling_ThrowException    #< An exception is thrown on timeout.

cdef extern from "pylon/PayloadType.h" namespace 'Pylon':
    cpdef enum EPayloadType:
        pass

cdef extern from "pylon/PixelType.h" namespace 'Pylon':
    cpdef enum EPixelType:
        pass

cdef extern from "pylon/Image.h" namespace 'Pylon':
    cpdef enum EImageOrientation:
        ImageOrientation_TopDown, #<The first row of the image is located at the start of the image buffer. This is the default for images taken by a camera.
        ImageOrientation_BottomUp #<The last row of the image is located at the start of the image buffer.


cdef extern from "pylon/ImagePersistence.h" namespace 'Pylon':
    cpdef enum EImageFileFormat:
        ImageFileFormat_Bmp,       # ///< Windows Bitmap, no compression.
        ImageFileFormat_Tiff,      # ///< Tagged Image File Format, no compression, supports mono images with more than 8 bit bit depth.
        ImageFileFormat_Jpeg,      # ///< Joint Photographic Experts Group, lossy data compression.
        ImageFileFormat_Png

cdef extern from "pylon/DeviceFactory.h" namespace 'Pylon':
     cpdef enum EDeviceAccessiblityInfo:
         Accessibility_Unknown, # The accessibility could not be determined. The state of accessibility is unknown.
         Accessibility_Ok, # The device could be opened.
         Accessibility_Opened, # The device is reachable, but can be opened in read only mode only.
         Accessibility_OpenedExclusively, # The device is reachable, but currently opened exclusively by another application.
         Accessibility_NotReachable # The device could not be reached or does not exist. No connection to the device is possible.

cdef extern from "pylon/DeviceAccessMode.h" namespace 'Pylon':
    cpdef enum EDeviceAccessMode:
        Control,      # access the control and status registers
        Stream,      # access a streaming data channel
        Event,      # access the event data channel
        Exclusive,    # exclusive access to the device
        _NumModes