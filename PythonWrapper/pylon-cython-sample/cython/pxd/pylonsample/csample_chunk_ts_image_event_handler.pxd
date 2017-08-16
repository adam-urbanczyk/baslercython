from pylon.usb.cbasler_usb_image_event_handler cimport CBaslerUsbImageEventHandler

cdef extern from "CSampleChunkTSImageEventHandler.cpp":
    cdef cppclass CSampleChunkTSImageEventHandler(CBaslerUsbImageEventHandler):
        pass