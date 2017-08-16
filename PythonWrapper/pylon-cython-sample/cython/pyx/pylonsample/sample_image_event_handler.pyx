from pylonsample.csample_image_event_handler cimport CSampleImageEventHandler
from pylon.usb.cbasler_usb_image_event_handler cimport CBaslerUsbImageEventHandler
from baslerpylon.pylon.usb.basler_usb_image_event_handler cimport BaslerUsbImageEventHandler



cdef class SampleImageEventHandler(BaslerUsbImageEventHandler):

    def __cinit__(self):
        self.image_event_obj = new CSampleImageEventHandler()

    cdef CBaslerUsbImageEventHandler* get_image_event_handler_object(self):
        return self.image_event_obj