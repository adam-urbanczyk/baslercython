from pylon.cconfiguration_event_handler cimport CConfigurationEventHandler

cdef extern from "util/Util.cpp":

    cdef cppclass CConfigurationEventPrinter(CConfigurationEventHandler):
        pass

