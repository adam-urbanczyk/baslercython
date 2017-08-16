from pylon.cconfiguration_event_handler cimport CConfigurationEventHandler

cdef class ConfigurationEventHandler:

    def __cinit__(self):
        self.configuration_event_handler_obj = new CConfigurationEventHandler()

    cdef CConfigurationEventHandler* get_configuration_event_handler_object(self):
        return self.configuration_event_handler_obj