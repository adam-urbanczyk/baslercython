from pylon.usb.cbasler_usb_image_event_handler cimport CBaslerUsbImageEventHandler

cdef class BaslerUsbImageEventHandler:

    def __cinit__(self):
        self.image_event_object = new CBaslerUsbImageEventHandler()

    cdef CBaslerUsbImageEventHandler* get_image_event_handler_object(self):
        return self.image_event_object