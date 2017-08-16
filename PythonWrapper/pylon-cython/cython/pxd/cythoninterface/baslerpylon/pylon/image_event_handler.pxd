from pylon.cimage_event_handler cimport CImageEventHandler
from libcpp.string cimport string

cdef class ImageEventHandler:
    cdef:
        CImageEventHandler* image_event_handler_obj
    cdef CImageEventHandler* get_image_event_handler_object(self)