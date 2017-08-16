from pylon.usb.cbasler_usb_image_event_handler cimport CBaslerUsbImageEventHandler

cdef extern from "SampleExposureImageEventHandler.cpp":
    cdef cppclass CSampleExposureImageEventHandler(CBaslerUsbImageEventHandler):
        void PrintLog()