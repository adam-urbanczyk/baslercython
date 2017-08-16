from pylon.ccamera_event_handler cimport CCameraEventHandler

cdef class CameraEventHandler:
    cdef CCameraEventHandler* camera_event_obj
    cdef CCameraEventHandler* get_camera_event_handler_object(self)