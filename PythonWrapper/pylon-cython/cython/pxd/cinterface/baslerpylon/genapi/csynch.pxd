from exception.custom_exception cimport raise_py_error
from libc.stdint cimport int64_t
from libcpp cimport bool

cdef extern from "GenApi/Synch.h" namespace 'GENAPI_NAMESPACE':
        cdef cppclass CLock:
                # Constructor
                CLock() except +raise_py_error

                #Destructor
                void Destructor "~CLock"() except +raise_py_error

                #tries to enter the critical section; returns true if successful
                bool TryLock() except +raise_py_error

                #enters the critical section (may block)
                void Lock() except +raise_py_error

                #leaves the critical section
                void Unlock() except +raise_py_error