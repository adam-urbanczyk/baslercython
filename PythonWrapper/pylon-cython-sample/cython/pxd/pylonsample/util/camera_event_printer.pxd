from pylon.ccamera_event_handler cimport CCameraEventHandler
from baslerpylon.pylon.camera_event_handler cimport CameraEventHandler
from pylonsample.util.ccamera_event_printer cimport CCameraEventPrinter

cdef class CameraEventPrinter(CameraEventHandler):
    cdef CCameraEventPrinter* camera_printer

    cdef CCameraEventHandler* get_camera_event_handler_object(self)

