from pylon.cconfiguration_event_handler cimport CConfigurationEventHandler
from pylon.cacquire_single_frame_configuration cimport CAcquireSingleFrameConfiguration
from baslerpylon.pylon.configuration_event_handler cimport ConfigurationEventHandler



cdef class AcquireSingleFrameConfiguration(ConfigurationEventHandler):
    def __cinit__(self):
        self.single_frame_configuration_ob = new CAcquireSingleFrameConfiguration()

    cdef CConfigurationEventHandler* get_configuration_event_handler_object(self):
         return self.single_frame_configuration_ob