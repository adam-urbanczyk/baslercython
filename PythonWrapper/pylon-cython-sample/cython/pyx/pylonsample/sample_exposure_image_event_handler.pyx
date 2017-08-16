from pylon.usb.cbasler_usb_camera_event_handler cimport CBaslerUsbCameraEventHandler
from pylon.usb.cbasler_usb_image_event_handler cimport CBaslerUsbImageEventHandler
from baslerpylon.pylon.usb.basler_usb_camera_event_handler cimport BaslerUsbCameraEventHandler
from baslerpylon.pylon.usb.basler_usb_image_event_handler cimport BaslerUsbImageEventHandler
from pylonsample.csample_exposure_image_event_handler cimport  CSampleExposureImageEventHandler



cdef class SampleExposureImageEventHandler(BaslerUsbImageEventHandler):

    def __cinit__(self):
        self.sample_image_event_object  = new CSampleExposureImageEventHandler()

    cdef CBaslerUsbImageEventHandler* get_image_event_handler_object(self):
        return self.sample_image_event_object

    def print_log(self):
       self.sample_image_event_object.PrintLog()

