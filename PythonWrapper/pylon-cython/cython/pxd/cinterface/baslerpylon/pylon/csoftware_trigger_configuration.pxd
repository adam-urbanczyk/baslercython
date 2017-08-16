from pylon.cconfiguration_event_handler cimport CConfigurationEventHandler

cdef extern from "pylon/SoftwareTriggerConfiguration.h" namespace 'Pylon':
    cdef cppclass CSoftwareTriggerConfiguration(CConfigurationEventHandler):
         pass