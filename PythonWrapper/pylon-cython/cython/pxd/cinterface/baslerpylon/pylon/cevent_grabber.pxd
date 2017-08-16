from exception.custom_exception cimport raise_py_error
from pylon.cwait_object cimport WaitObject
from genapi.cinode_map cimport INodeMap
from pylon.cresult cimport EventResult
from libcpp cimport bool

cdef extern from "pylon/EventGrabber.h" namespace 'Pylon':
    #     /*!
    # \interface IEventGrabber
    # \ingroup Pylon_LowLevelApi
    # \brief Low Level API: Interface of an object receiving asynchronous events.
    #
    # Asynchronous event messages are received from the camera. Internal Buffers are filled
    # and stored in an output queue. While the output queue contains data the associated
    # waitobject is signaled.
    #
    # With RetrieveEvent() the first event message is copied into a user buffer.
    # */
    cdef cppclass IEventGrabber:
        #Open the event grabber
        void Open() except +raise_py_error
        #Close the event grabber
        void Close() except +raise_py_error
        #Retrieve whether the event grabber is open
        bool IsOpen() except +raise_py_error
        #Retrieve an event message from the output queue
        # /*!
        #    \return When the event was available true is returned
        #    and the event message is copied into the EventResult.
        # */
        bool RetrieveEvent( EventResult& ) except +raise_py_error
        # /// Return the event object associated with the grabber
        # /*!
        #     This object get signaled as soon as a event has occurred.
        #     It will be reset when the output queue is empty.
        # */
        WaitObject& GetWaitObject() except +raise_py_error
        # /// Return the associated event grabber parameters
        # /*! If no parameters are available, NULL is returned. */
        INodeMap* GetNodeMap() except +raise_py_error