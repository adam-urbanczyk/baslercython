from pylon.usb.cbasler_usb_image_event_handler cimport CBaslerUsbImageEventHandler
from pylon.usb.cbasler_usb_camera_event_handler cimport CBaslerUsbCameraEventHandler

cdef extern from "SampleExposureCameraEventHandler.cpp":
    cdef cppclass CSampleExposureCameraEventHandler(CBaslerUsbCameraEventHandler):
        void PrintLog()