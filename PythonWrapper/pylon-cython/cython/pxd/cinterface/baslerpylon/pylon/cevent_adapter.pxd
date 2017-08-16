from exception.custom_exception cimport raise_py_error
from libc.stdint cimport  uint32_t, uint8_t

cdef extern from "pylon/EventAdapter.h" namespace 'Pylon':
    cdef cppclass IEventAdapter:
        #Deliver message
        void DeliverMessage( const uint8_t msg[], uint32_t numBytes ) except +raise_py_error