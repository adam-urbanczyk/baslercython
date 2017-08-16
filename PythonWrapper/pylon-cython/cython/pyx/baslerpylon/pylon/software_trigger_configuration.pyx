from pylon.cconfiguration_event_handler cimport CConfigurationEventHandler
from baslerpylon.pylon.configuration_event_handler cimport ConfigurationEventHandler
from pylon.csoftware_trigger_configuration cimport CSoftwareTriggerConfiguration

cdef class SoftwareTriggerConfiguration(ConfigurationEventHandler):

    def __cinit__(self):
        self.software_trigger_configuration_obj = new CSoftwareTriggerConfiguration()

    cdef CConfigurationEventHandler* get_configuration_event_handler_object(self):
         return self.software_trigger_configuration_obj