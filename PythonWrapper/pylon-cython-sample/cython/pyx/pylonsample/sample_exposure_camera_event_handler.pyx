from pylon.usb.cbasler_usb_camera_event_handler cimport CBaslerUsbCameraEventHandler
from pylon.usb.cbasler_usb_image_event_handler cimport CBaslerUsbImageEventHandler
from baslerpylon.pylon.usb.basler_usb_camera_event_handler cimport BaslerUsbCameraEventHandler
from baslerpylon.pylon.usb.basler_usb_image_event_handler cimport BaslerUsbImageEventHandler
from pylonsample.csample_exposure_camera_event_handler cimport   CSampleExposureCameraEventHandler


cdef class SampleExposureCameraEventHandler(BaslerUsbCameraEventHandler):

    def __cinit__(self):
        self.cameraEventObject  = new CSampleExposureCameraEventHandler()

    cdef CBaslerUsbCameraEventHandler* get_camera_event_handler_object(self):
        return self.cameraEventObject #new CSampleExposureCameraEventHandler()

    def print_log(self):
       self.cameraEventObject.PrintLog()