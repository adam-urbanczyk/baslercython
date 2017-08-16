from exception.custom_exception cimport raise_py_error
from libcpp cimport bool
from libc.stdint cimport uint32_t
from pylon.cconfiguration_event_handler cimport CConfigurationEventHandler


cdef extern from "pylon/AcquireContinuousConfiguration.h" namespace 'Pylon':
    cdef cppclass CAcquireContinuousConfiguration(CConfigurationEventHandler):
        pass