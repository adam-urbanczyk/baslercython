from pylon.usb.cbasler_usb_image_event_handler cimport CBaslerUsbImageEventHandler
from baslerpylon.pylon.usb.basler_usb_image_event_handler cimport BaslerUsbImageEventHandler
from pylonsample.csample_image_event_handler cimport CSampleImageEventHandler


cdef class SampleImageEventHandler(BaslerUsbImageEventHandler):

    cdef:
        CSampleImageEventHandler* image_event_obj
    cdef CBaslerUsbImageEventHandler* get_image_event_handler_object(self)