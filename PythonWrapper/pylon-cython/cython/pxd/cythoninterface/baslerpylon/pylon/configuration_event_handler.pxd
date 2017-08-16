from pylon.cconfiguration_event_handler cimport CConfigurationEventHandler

cdef class ConfigurationEventHandler:
    cdef:
        CConfigurationEventHandler* configuration_event_handler_obj
    cdef CConfigurationEventHandler* get_configuration_event_handler_object(self)