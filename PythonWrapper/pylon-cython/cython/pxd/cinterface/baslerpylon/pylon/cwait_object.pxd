from exception.custom_exception cimport raise_py_error
from libcpp cimport bool
from baslerpylon.pylon.camera_enum cimport EWaitExResult

cdef extern from "pylon/WaitObject.h" namespace 'Pylon':
    cdef cppclass WaitObject:
        WaitObject() except +raise_py_error
        void Delete "~WaitObject"() except +raise_py_error
        #Copy constructor (duplicates the wrapped handle/file descriptor)
        WaitObject(const WaitObject&) except +raise_py_error
        #Assignment operator (duplicates the wrapped handle/file descriptor)
        #WaitObject& equal "operator="(const WaitObject&)

        # /// Suspend calling thread for specified time.
        # /**
        # \param ms wait time in ms
        # */
        @staticmethod
        void Sleep(unsigned long ms) except +raise_py_error


        # /// Checks if the wait object is valid.
        # /**
        # Don't call the  Wait methods() for an invalid wait object. Wait objects returned by the pylon libraries are valid.
        # \return true if the object contains a valid handle/file descriptor
        # */
        bool IsValid() except +raise_py_error


        # /// Wait for the object to be signaled
        # /**
        # \param timeout timeout in ms
        # \return false when the timeout has been expired, true when the waiting was successful before
        # the timeout has been expired.
        # */
        bool Wait(unsigned int timeout) except +raise_py_error

        # /// Wait for the object to be signaled  (interruptible)
        # /**
        #
        # \param timeout timeout in ms
        # \param bAlertable    When the bAlertable parameter is set to true, the function waits until either the timeout elapses, the object enters
        # the signaled state, or the wait operation has been interrupted.
        # For Windows, the wait operation is interrupted by queued APCs or I/O completion routines.
        # For Linux, the wait operation can be interrupted by signals.
        #
        # \return The returned Pylon::EWaitExResult  value indicates the result of the wait operation.
        #
        # */
        EWaitExResult WaitEx(unsigned int timeout, bool bAlertable)

    cdef cppclass WaitObjectEx(WaitObject):
        #Creates an event object (manual reset event)
        @staticmethod
        WaitObjectEx Create(bool initiallySignalled = false)


        # /// Constructs an "empty" wait object, i.e., the wait object is not attached to a platform dependent wait object (IsValid() == false)
        # /** Use the static WaitObjectEx::Create() method to create instances of the WaitObjectEx class instead. */
        WaitObjectEx() except +raise_py_error

        # Set the object to signaled state
        void Signal();
        # Reset the object to unsignaled state
        void Reset();
