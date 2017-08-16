from pylon.usb.cbasler_usb_camera_event_handler cimport CBaslerUsbCameraEventHandler
from baslerpylon.pylon.usb.basler_usb_camera_event_handler cimport BaslerUsbCameraEventHandler
from pylonsample.csample_camera_event_handler cimport CSampleCameraEventHandler


cdef class SampleCameraEventHandler(BaslerUsbCameraEventHandler):

    cdef:
        CSampleCameraEventHandler* camera_event_obj

    cdef CBaslerUsbCameraEventHandler* get_camera_event_handler_object(self)