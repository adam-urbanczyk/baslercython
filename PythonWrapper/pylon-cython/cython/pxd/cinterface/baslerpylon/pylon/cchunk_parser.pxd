from exception.custom_exception cimport raise_py_error
from genapi.cinode_map cimport INodeMap
from pylon.cevent_adapter cimport IEventAdapter
from pylon.cdevice_info cimport CDeviceInfo
from pylon.cdevice_access_mode cimport *
from pylon.cevent_grabber cimport IEventGrabber
from pylon.cresult cimport EventResult
from pylon.cstream_grabber cimport IStreamGrabber
from pylon.cdevice cimport IPylonDevice

from libcpp cimport bool
from libc.stdint cimport  int64_t




cdef extern from "pylon/ChunkParser.h" namespace 'Pylon':
    cdef cppclass IChunkParser:
        # /// Pass in a buffer and let the chunk parser analyze it.
        # /*! Corresponding parameters of the camera object reflecting the chunked data
        #     will be updated.
        #     \param pBuffer Pointer to the new buffer
        #     \param BufferLength Size of the new buffer in bytes
        #     \param pAttachStatistics (optional) Pointer to a record taking statistic
        #     data of the analyzed buffer
        #  */
        #void AttachBuffer(const void *pBuffer, int64_t BufferLength, AttachStatistics_t *pAttachStatistics = NULL)  except +raise_py_error
        # 
        # /// \brief Detaches a buffer from the chunk parser. The buffer will no longer accessed by the chunk parser
        # /*!
        # //  An attached buffer must be detached before freeing it. When attaching a new buffer, the previous
        # //  one gets detached automatically.
        # */
        void DetachBuffer() except +raise_py_error

        # /// \brief Pass in a buffer and let the chunk parser update the camera object's parameters.
        # /*!
        #     This method can be used when the layout of the chunk data hasn't changed since a previous buffer
        #     has been attached to the chunk parser. In this case UpdateBuffer is slightly faster then AttachBuffer,
        #     because the buffer's layout is remembered.
        #     \param pBaseAddress Pointer to the new buffer
        # */
        void UpdateBuffer(const void *pBaseAddress) except +raise_py_error
        
       # /// Checks if buffer has a CRC attached
       #  /*!
       #      \return true if the buffer contains CRC value.
       #  */
        bool HasCRC() except +raise_py_error

        # /// Checks CRC sum of buffer
        # /*!
        #     \return true if the contained CRC equals the computed value.
        # */
        bool CheckCRC() except +raise_py_error