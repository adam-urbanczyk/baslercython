from exception.custom_exception cimport raise_py_error
from genapi.cinode_map cimport INodeMap
from pylon.cwait_object cimport WaitObject
from libc.stdint cimport  uint32_t, uint8_t
from libcpp cimport bool
from pylon.cresult cimport GrabResult

cdef extern from "pylon/StreamGrabber.h" namespace 'Pylon':

    ctypedef void* StreamBufferHandle

    cdef cppclass IStreamGrabber:
        # /// Opens the stream grabber
        # //*! Opens the stream grabber and starts the result queue. */
        void Open() except +raise_py_error
        # /// Closes the stream grabber
        # /*! Flushes the result queue and stops the thread. */
        void Close()  except +raise_py_error
        # /// Retrieve whether the stream grabber is open.
        # virtual bool IsOpen(void) const = 0;


        # /// Registers a buffer for subsequent use.
        # /*! Stream must be locked to register buffers  The Buffer size may not exceed
        # the value specified when PrepareGrab was called. */
        # virtual StreamBufferHandle RegisterBuffer( void* Buffer, size_t BufferSize ) = 0;
        # /// Deregisters the buffer
        # /*! Deregistering fails while the buffer is in use, so retrieve the buffer from
        # the output queue after grabbing.
        # \note Do not delete buffers before they are deregistered. */
        void* DeregisterBuffer() except +raise_py_error

        # /// Prepares grabbing
        # /*! Allocates resources, synchronizes with the camera and locks critical parameter */
        void PrepareGrab()  except +raise_py_error
        # /// Stops grabbing
        # /*! Releases the resources and camera. Pending grab requests are canceled. */
        void FinishGrab()  except +raise_py_error

        # /// Enqueues a buffer in the input queue.
        # /*! PrepareGrab is required to queue buffers. The context is returned together with the
        # buffer and the grab result. It is not touched by the stream grabber.
        # It is illegal to queue a buffer a second time before it is fetched from the
        # result queue.*/
        void QueueBuffer( StreamBufferHandle, const void* Context=NULL )  except +raise_py_error

        # /// Cancels pending requests
        # /*! , resources remain allocated. Following, the results must be retrieved from the
        # Output Queue. */
        void CancelGrab()  except +raise_py_error

        # /// Retrieves a grab result from the output queue
        # /*! \return When result was available true is returned and and the
        # first result is copied into the grabresult. Otherwise the grabresult remains
        # unchanged and false is returned. */
        bool RetrieveResult( GrabResult& )  except +raise_py_error
        # /// Returns the result event object.
        # /*! This object is associated with the result queue. The event is signaled when
        # queue is non-empty */
        WaitObject& GetWaitObject()  except +raise_py_error
        # /// Returns the associated stream grabber parameters.
        # /*! If no parameters are available, NULL is returned. */
        INodeMap* GetNodeMap()  except +raise_py_error