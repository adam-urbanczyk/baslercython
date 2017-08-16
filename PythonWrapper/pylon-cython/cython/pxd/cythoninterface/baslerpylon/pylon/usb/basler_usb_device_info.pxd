from pylon.usb.cbasler_usb_device_info cimport CBaslerUsbDeviceInfo
from pylon.cdevice_info cimport CDeviceInfo

cdef class BaslerUsbDeviceInfo:
    cdef CBaslerUsbDeviceInfo* dev_info
    @staticmethod
    cdef create(CDeviceInfo& dev_info)

    @staticmethod
    cdef create_basler_device_info(CBaslerUsbDeviceInfo* dev_info)