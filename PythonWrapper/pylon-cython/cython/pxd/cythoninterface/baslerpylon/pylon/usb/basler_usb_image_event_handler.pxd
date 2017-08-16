from pylon.usb.cbasler_usb_image_event_handler cimport CBaslerUsbImageEventHandler
from libcpp.string cimport string

cdef class BaslerUsbImageEventHandler:
    cdef:
        CBaslerUsbImageEventHandler* image_event_object
    cdef CBaslerUsbImageEventHandler* get_image_event_handler_object(self)