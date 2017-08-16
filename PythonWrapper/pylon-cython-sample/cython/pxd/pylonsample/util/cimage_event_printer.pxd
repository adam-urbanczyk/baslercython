from pylon.cimage_event_handler cimport CImageEventHandler

cdef extern from "util/Util.cpp":

    cdef cppclass CImageEventPrinter(CImageEventHandler):
        pass