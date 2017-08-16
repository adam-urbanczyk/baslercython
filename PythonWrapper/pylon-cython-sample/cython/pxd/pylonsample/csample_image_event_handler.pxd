from pylon.usb.cbasler_usb_image_event_handler cimport CBaslerUsbImageEventHandler

cdef extern from "CSampleImageEventHandler.cpp":
    cdef cppclass CSampleImageEventHandler(CBaslerUsbImageEventHandler):
        pass

