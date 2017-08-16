from pylon.cdevice_info cimport CDeviceInfo
from libcpp.string cimport string
from pylon.ctype_mappings cimport String_t


cdef class DeviceInfo:
    
    @staticmethod
    cdef create(CDeviceInfo* dev_info):
        obj = DeviceInfo()
        obj.dev_info = dev_info
        return obj

    property serial_number:
        def __get__(self):
            return (<string>self.dev_info.GetSerialNumber()).decode('ascii')

    property serial_number_available:
        def __get__(self):
            return (self.dev_info.IsSerialNumberAvailable()).decode('ascii') 

    property user_defined_name_available:
        def __get__(self):
            return (self.dev_info.IsUserDefinedNameAvailable()).decode('ascii')

    property user_defined_name:
        def __get__(self):
            return (<string>self.dev_info.GetUserDefinedName()).decode('ascii')
        #def __set__(self, name):
        #   self.dev_info.SetUserDefinedName(name))

    property model_name:
        def __get__(self):
            return (<string>self.dev_info.GetModelName()).decode('ascii')

    property model_name_available:
        def __get__(self):
            return self.dev_info.IsModelNameAvailable()
        
    property device_version_available:
        def __get__(self):
            return self.IsDeviceVersionAvailable()

    property device_factory:
        def __get__(self):
            return (<string>self.dev_info.GetDeviceFactory()).decode('ascii')

    property defice_factory_available:
        def __get__(self):
            return self.dev_info.IsDeviceFactoryAvailable()

    property friendly_name:
        def __get__(self):
           return (<string>self.dev_info.GetFriendlyName()).decode('ascii')

    property vendor_name:
        def __get__(self):
            return (<string>self.dev_info.GetVendorName()).decode('ascii')

    property device_class:
        def __get__(self):
            return (<string>self.dev_info.GetDeviceClass()).decode('ascii')

                



            
