from pylon.cconfiguration_event_handler cimport CConfigurationEventHandler
from baslerpylon.pylon.configuration_event_handler cimport ConfigurationEventHandler
from pylonsample.util.cconfiguration_event_printer cimport  CConfigurationEventPrinter


cdef class ConfigurationEventPrinter(ConfigurationEventHandler):

    def __cinit__(self):
        self.event_log = new CConfigurationEventPrinter()

    cdef CConfigurationEventHandler* get_configuration_event_handler_object(self):
        return self.event_log

