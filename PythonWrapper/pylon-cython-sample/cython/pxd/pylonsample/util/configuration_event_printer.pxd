
from pylon.cconfiguration_event_handler cimport CConfigurationEventHandler
from baslerpylon.pylon.configuration_event_handler cimport ConfigurationEventHandler
from pylonsample.util.cconfiguration_event_printer cimport  CConfigurationEventPrinter


cdef class ConfigurationEventPrinter(ConfigurationEventHandler):
    cdef CConfigurationEventPrinter* event_log
    cdef CConfigurationEventHandler* get_configuration_event_handler_object(self)

