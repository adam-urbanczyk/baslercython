from pylon.usb.cbasler_usb_instant_camera_array cimport CBaslerUsbInstantCameraArray

cdef class BaslerUSBInstantCameraArray:
    cdef:
        CBaslerUsbInstantCameraArray camera_array

