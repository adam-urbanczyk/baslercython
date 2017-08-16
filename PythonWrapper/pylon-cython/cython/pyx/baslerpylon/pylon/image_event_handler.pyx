from pylon.cimage_event_handler cimport CImageEventHandler

cdef class ImageEventHandler:

    def __cinit__(self):
        self.image_event_handler_obj = new CImageEventHandler()

    cdef CImageEventHandler* get_image_event_handler_object(self):
        return self.image_event_handler_obj