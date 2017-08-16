from pylon.cconfiguration_event_handler cimport CConfigurationEventHandler
from pylon.cacquire_continuous_configuration cimport CAcquireContinuousConfiguration
from baslerpylon.pylon.configuration_event_handler cimport ConfigurationEventHandler

cdef class AcquireContinuousConfiguration(ConfigurationEventHandler):
    cdef:
        CAcquireContinuousConfiguration* acquire_configuration_obj

    cdef CConfigurationEventHandler* get_configuration_event_handler_object(self)