from exception.custom_exception cimport raise_py_error
from libcpp cimport bool
from libc.stdint cimport intptr_t, uint32_t, uint64_t, int64_t
from pylon.ctype_mappings cimport String_t
from baslerpylon.pylon.camera_enum cimport EPixelType
from baslerpylon.pylon.camera_enum cimport EPayloadType
from genapi.cinode_map cimport INodeMap



cdef extern from "pylon/usb/BaslerUsbGrabResultData.h" namespace 'Pylon':
    cdef cppclass CBaslerUsbGrabResultData:
        # Returns true if an image has been grabbed successfully and false in the case of an error.
        bool GrabSucceeded() except +raise_py_error
        # This method returns a description of the error if GrabSucceeded() returns false due to an error.
        String_t GetErrorDescription() except +raise_py_error

        # This method returns the error code if GrabSucceeded() returns false due to an error.
        uint32_t GetErrorCode() except +raise_py_error


        EPayloadType GetPayloadType() except +raise_py_error

        # Get the current pixel type.
        EPixelType GetPixelType() except +raise_py_error

        # Get the current number of columns.
        uint32_t GetWidth() except +raise_py_error

        # Get the current number of rows expressed as number of pixels.
        uint32_t GetHeight() except +raise_py_error

        # Get the current starting column
        uint32_t GetOffsetX() except +raise_py_error

        # Get the current starting row.
        uint32_t GetOffsetY() except +raise_py_error

        # Get the number of extra data at the end of each row in bytes.
        uint32_t GetPaddingX() except +raise_py_error

        # Get the number of extra data at the end of the image data in bytes.
        uint32_t GetPaddingY() except +raise_py_error


        # Get the pointer to the buffer.
        #
        # If the chunk data feature is activated for the device, chunk data is appended to the image data.
        # When writing past the image section while performing image processing, the chunk data will be corrupted.
        # */
        void* GetBuffer() except +raise_py_error

        # Get the current payload size in bytes.
        size_t GetPayloadSize() except +raise_py_error


        # Get the block ID of the grabbed frame (camera device specific).
        #
        # \par IEEE 1394 Camera Devices
        # The value of Block ID is always UINT64_MAX.
        #
        # \par GigE Camera Devices
        # The sequence number starts with 1 and
        # wraps at 65535. The value 0 has a special meaning and indicates
        # that this feature is not supported by the camera.
        #
        # \par USB Camera Devices
        # The sequence number starts with 0 and uses the full 64 Bit range.
        #
        # \attention A block ID with the value UINT64_MAX indicates that the block ID is invalid and must not be used.
        # */
        uint64_t GetBlockID() except +raise_py_error


        # # Get the camera specific tick count (camera device specific).
        # #
        # This describes when the image exposure was started.
        # Cameras that do not support this feature return zero. If supported, this
        # can be used to determine which image AOIs were acquired simultaneously.
        # */
        uint64_t GetTimeStamp() except +raise_py_error

        # # Get the stride in byte.
        # /*
        #     Uses Pylon::ComputeStride to compute the stride from the result data.
        #
        # \return The stride in byte.
        #
        # \pre The preconditions of Pylon::ComputeStride must be met.
        #
        # \error
        #     Throws an exception if the stride value cannot be computed from the result data.
        # */
        bool GetStride( size_t& strideBytes) except +raise_py_error


        # # Get the size of the image in byte.
        # /*
        #     Uses Pylon::ComputeBufferSize to compute the stride from the result data.
        #     PaddingY is not taken into account.
        #
        # \return The buffer size in byte.
        #
        # \pre The preconditions of Pylon::ComputeBufferSize must be met.
        #
        # \error
        #     Throws an exception if the buffer size cannot be computed from the result data.
        # */
        size_t GetImageSize() except +raise_py_error

        # # Get the context value assigned to the camera object. The context is attached to the result when it is retrieved.
        intptr_t GetCameraContext() except +raise_py_error

        # Get the ID of the grabbed image.
        # Always returns a number larger than 0. The counting starts with 1 and is never reset during the lifetime of the Instant Camera object. */
        int64_t GetID() except +raise_py_error

        # Get the number of the image. This number is incremented when an image is retrieved using CInstantCamera::RetrieveResult().
        # Always returns a number larger than 0. The counting starts with 1 and is reset with every call to CInstantCamera::StartGrabbing(). */
        int64_t GetImageNumber() except +raise_py_error


        # # Get the number of skipped images before this image.
        # #
        # This value can be larger than 0 if EGrabStrategy_LatestImageOnly grab strategy or GrabStrategy_LatestImages grab strategy is used.
        # Always returns a number larger than or equal 0. This number does not include the number of images lost in case of a buffer underrun in the driver.
        # */
        int64_t GetNumberOfSkippedImages() except +raise_py_error

        # # Returns true if chunk data is available.
        # #
        # This is the case if the chunk mode is enabled for the camera device.
        # The parameter CInstantCamera::ChunkNodeMapsEnable of the used Instant Camera object is set to true (default setting).
        # Chunk data node maps are supported by the Transport Layer of the camera device.
        # */
        bool IsChunkDataAvailable() except +raise_py_error

        # # Get the reference to the chunk data node map connected to the result.
        # # An empty node map is returned when the device does not support this feature or when chunks are disabled. */
        INodeMap& GetChunkDataNodeMap() except +raise_py_error

        # # Checks if buffer has a CRC attached. This needs not be activated for the device. See the PayloadCRC16 chunk.
        # /* The chunk feature must be supported and activated, otherwise false is returned. */
        bool HasCRC() except +raise_py_error

        # # Checks CRC sum of buffer, returns true if CRC sum is OK.
        # /*
        # \error
        #     Throws an exception if GetHasCRC() is false and chunks are activated.
        # */
        bool CheckCRC() except +raise_py_error

        # Get the context value assigned to the buffer. The context is set when CInstamtCamera is using a custom buffer factory.
        intptr_t GetBufferContext() except +raise_py_error