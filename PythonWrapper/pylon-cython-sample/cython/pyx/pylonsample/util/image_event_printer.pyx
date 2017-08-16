from pylon.cimage_event_handler cimport CImageEventHandler
from baslerpylon.pylon.image_event_handler cimport ImageEventHandler
from pylonsample.util.cimage_event_printer cimport  CImageEventPrinter


cdef class ImageEventPrinter(ImageEventHandler):
    def __cinit__(self):
        self.image_printer = new CImageEventPrinter()

    cdef CImageEventHandler* get_image_event_handler_object(self):
        return self.image_printer