from pylon.cconfiguration_event_handler cimport CConfigurationEventHandler
from pylon.cacquire_continuous_configuration cimport CAcquireContinuousConfiguration
from baslerpylon.pylon.configuration_event_handler cimport ConfigurationEventHandler



cdef class AcquireContinuousConfiguration(ConfigurationEventHandler):

    def __cinit__(self):
        self.acquire_configuration_obj = new CAcquireContinuousConfiguration()

    cdef CConfigurationEventHandler* get_configuration_event_handler_object(self):
         return self.acquire_configuration_obj