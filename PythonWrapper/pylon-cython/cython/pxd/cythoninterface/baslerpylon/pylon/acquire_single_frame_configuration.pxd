from pylon.cconfiguration_event_handler cimport CConfigurationEventHandler
from pylon.cacquire_single_frame_configuration cimport CAcquireSingleFrameConfiguration
from baslerpylon.pylon.configuration_event_handler cimport ConfigurationEventHandler

cdef class AcquireSingleFrameConfiguration(ConfigurationEventHandler):
    cdef:
        CAcquireSingleFrameConfiguration* single_frame_configuration_ob
    cdef CConfigurationEventHandler* get_configuration_event_handler_object(self)