from pylon.usb.cbasler_usb_camera_event_handler cimport CBaslerUsbCameraEventHandler

cdef class BaslerUsbCameraEventHandler:

    def __cinit__(self):
        self.camera_event_handler = new CBaslerUsbCameraEventHandler()

    cdef CBaslerUsbCameraEventHandler* get_camera_event_handler_object(self):
         return self.camera_event_handler