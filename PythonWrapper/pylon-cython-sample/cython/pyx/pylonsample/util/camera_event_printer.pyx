from pylon.ccamera_event_handler cimport CCameraEventHandler
from pylonsample.util.ccamera_event_printer cimport CCameraEventPrinter
from baslerpylon.pylon.camera_event_handler cimport CameraEventHandler

cdef class CameraEventPrinter(CameraEventHandler):

    def __cinit__(self):
        self.camera_printer = new CCameraEventPrinter()

    cdef CCameraEventHandler* get_camera_event_handler_object(self):
        return self.camera_printer

