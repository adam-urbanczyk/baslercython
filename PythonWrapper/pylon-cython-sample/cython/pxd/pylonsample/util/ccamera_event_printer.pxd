from pylon.ccamera_event_handler cimport CCameraEventHandler

cdef extern from "util/Util.cpp":
    cdef cppclass CCameraEventPrinter(CCameraEventHandler):
        pass
