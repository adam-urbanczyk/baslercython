from pylon.ctlfactory cimport CTlFactory
from pylon.ccontainer cimport DeviceInfoList_t
from pylon.ctlfactory cimport *
from baslerpylon.pylon.usb.basler_usb_device_info cimport BaslerUsbDeviceInfo
from pylon.cpylon_include cimport *
from cython.operator cimport dereference as deref, preincrement as inc
from baslerpylon.pylon.device cimport Device
from pylon.usb.cbasler_usb_device_info cimport CBaslerUsbDeviceInfo
from pylon.cdevice_info cimport CDeviceInfo

cdef class TlFactory:
    def __cinit__(self):
        PylonInitialize()

    #def __dealloc__(self):
    #    PylonTerminate()

    def terminate(self):
        PylonTerminate()
		
    @staticmethod
    def get_instance():
        obj = TlFactory()
        #check for exception before calling a method
        CTlFactory.GetInstance()
        obj.ctlFactory = &GetInstance()
        return obj

    
    def create_device(self, BaslerUsbDeviceInfo di ):
        cdef IPylonDevice* cdevice = self.ctlFactory.CreateDevice(deref(di.dev_info))
        return Device.create(cdevice)

			
    def create_first_device(self, BaslerUsbDeviceInfo di = None):
        cdef IPylonDevice* cdevice
        if di is not None:
            cdevice = self.ctlFactory.CreateFirstDevice(deref(di.dev_info))
            return Device.create(cdevice)
        else:
            cdevice = self.ctlFactory.CreateFirstDevice()
            return Device.create(cdevice)


    def is_device_accessible(self,BaslerUsbDeviceInfo deviceInfo):
        return self.ctlFactory.IsDeviceAccessible(deref(deviceInfo.dev_info))


    def find_devices_info_list(self):
        cdef DeviceInfoList_t devices
        cdef int nr_devices = self.ctlFactory.EnumerateDevices(devices)

        found_devices = list()
        # Iterate through the discovered devices
        cdef DeviceInfoList_t.iterator it = devices.begin()
        while it != devices.end():
            found_devices.append(BaslerUsbDeviceInfo.create(deref(it)))
            inc(it)

        return found_devices