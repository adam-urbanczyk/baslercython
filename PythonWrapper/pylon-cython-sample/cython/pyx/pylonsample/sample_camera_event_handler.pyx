from pylonsample.csample_camera_event_handler cimport CSampleCameraEventHandler
from baslerpylon.pylon.usb.basler_usb_camera_event_handler cimport BaslerUsbCameraEventHandler
from pylon.usb.cbasler_usb_camera_event_handler cimport CBaslerUsbCameraEventHandler

cdef class SampleCameraEventHandler(BaslerUsbCameraEventHandler):
    def __cinit__(self):
        self.camera_event_obj = new CSampleCameraEventHandler()

    cdef CBaslerUsbCameraEventHandler* get_camera_event_handler_object(self):
        return self.camera_event_obj