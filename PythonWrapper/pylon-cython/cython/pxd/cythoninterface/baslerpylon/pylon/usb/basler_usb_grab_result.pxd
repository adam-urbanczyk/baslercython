from pylon.usb.cbasler_usb_grab_result_ptr cimport CBaslerUsbGrabResultPtr



cdef class BaslerUsbGrabResult:
    cdef:
        CBaslerUsbGrabResultPtr cgrabresultptr

    