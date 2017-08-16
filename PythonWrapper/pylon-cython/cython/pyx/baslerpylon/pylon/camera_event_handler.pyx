from pylon.ccamera_event_handler cimport CCameraEventHandler

cdef class CameraEventHandler:

    def __cinit__(self):
        self.camera_event_obj = new CCameraEventHandler()

    cdef CCameraEventHandler* get_camera_event_handler_object(self):
         return self.camera_event_obj