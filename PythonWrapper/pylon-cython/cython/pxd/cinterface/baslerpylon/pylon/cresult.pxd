from exception.custom_exception cimport raise_py_error
from pylon.ctype_mappings cimport String_t
from pylon.cstream_grabber cimport StreamBufferHandle
from baslerpylon.pylon.camera_enum cimport EGrabStatus, EPayloadType, EPixelType
from base.cgctype cimport size_t

from libcpp cimport bool
from libc.stdint cimport  int32_t, int64_t, uint64_t, uint32_t

cdef extern from "pylon/Result.h" namespace 'Pylon':


    # // -------------------------------------------------------------------------
    # // class GrabResult
    # // -------------------------------------------------------------------------
    # /*!
    # \brief Low Level API: A grab result that combines the used image buffer and status information.
    #
    # \ingroup  Pylon_LowLevelApi
    #
    # Note that depending on the used interface technology, the specific camera and
    # the situation some of the attributes are not meaningful, e. g. timestamp in case
    # of an canceled grab.
    # */
    cdef cppclass GrabResult:
        GrabResult() except +raise_py_error


        # True if status is grabbed.
        bool Succeeded() except +raise_py_error
        # Get the buffer handle.
        StreamBufferHandle Handle() except +raise_py_error
        # Get the pointer to the buffer.
        void* Buffer() except +raise_py_error
        # Get the grab status.
        EGrabStatus Status() except +raise_py_error
        # Get the pointer the user provided context.
        const void* Context() except +raise_py_error

        # //
        # // Get functions for reporting frame info
        # //
        #
        # /// Get the actual payload type.
        EPayloadType GetPayloadType() except +raise_py_error

        # Get the actual pixel type
        # /*!
        # This is only defined in case of image data.
        # */
        EPixelType GetPixelType() except +raise_py_error
        # Get the camera specific tick count
        # /*!
        # In case of GigE-Vision this describes when the image exposure was started.
        # Cameras that do not support this feature return zero. If supported this
        # may be used to determine which ROIs were acquired simultaneously.
        #
        # In case of FireWire this value describes the cycle time when the first
        # packet arrives.
        # */
        uint64_t GetTimeStamp() except +raise_py_error
        # Get the actual number of columns in pixel
        # This is only defined in case of image data.*/
        int32_t GetSizeX() except +raise_py_error

        # Get the actual number of rows in pixel
        # This is only defined in case of image data.*/
        int32_t GetSizeY() const

        # Get the actual starting column
        # This is only defined in case of image data.*/
        int32_t GetOffsetX() except +raise_py_error


        # Get the actual starting row
        # This is only defined in case of image data.*/
        int32_t GetOffsetY() except +raise_py_error

        # Get the number of extra data at the end of each row in bytes
        # This is only defined in case of image data.*/
        int32_t GetPaddingX() except +raise_py_error

        # Get the number of extra data at the end of the image data in bytes
        # This is only defined in case of image data.*/
        int32_t GetPaddingY() except +raise_py_error

        # Get the actual payload size in bytes.
        int64_t GetPayloadSize() except +raise_py_error

        # Get the actual payload size in bytes as size_t.
        size_t GetPayloadSize_t() except +raise_py_error

        # Get a description of the current error.
        String_t GetErrorDescription() except +raise_py_error

        # Get the current error code
        uint32_t GetErrorCode() except +raise_py_error

        # /*!
        # \brief Provides an adapter from the grab result to Pylon::IImage interface.
        #
        # This returned adapter allows passing the grab result to saving functions or image format converter.
        #
        # \attention The returned reference is only valid as long the grab result is not destroyed.
        # */
        #CGrabResultImageRef GetImage() except +raise_py_error

        # Get the block ID of the grabbed frame (camera device specific).
        # /*!
        # \par IEEE 1394 Camera Devices
        # The value of block ID is always UINT64_MAX.
        #
        # \par GigE Camera Devices
        # The sequence number starts with 1 and
        # wraps at 65535. The value 0 has a special meaning and indicates
        # that this feature is not supported by the camera.
        #
        # \par USB Camera Devices
        # The sequence number starts with 0 and uses the full 64 Bit range.
        #
        # \attention A block ID of value UINT64_MAX indicates that the Block ID is invalid and must not be used.
        # */
        uint64_t GetBlockID() except +raise_py_error


    cdef cppclass EventResult:
        EventResult() except +raise_py_error
        bool Succeeded() except +raise_py_error
        String_t ErrorDescription() except +raise_py_error
        unsigned long ErrorCode() except +raise_py_error

