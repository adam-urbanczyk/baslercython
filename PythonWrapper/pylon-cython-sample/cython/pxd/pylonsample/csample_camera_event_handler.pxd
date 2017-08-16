from pylon.usb.cbasler_usb_camera_event_handler cimport CBaslerUsbCameraEventHandler

cdef extern from "CSampleCameraEventHandler.cpp":
    cdef cppclass CSampleCameraEventHandler(CBaslerUsbCameraEventHandler):
        pass