from pylon.usb.cbasler_usb_device_info cimport CBaslerUsbDeviceInfo
from libcpp.string cimport string
from pylon.ctype_mappings cimport String_t
from pylon.cdevice_info cimport CDeviceInfo

cdef class BaslerUsbDeviceInfo:
    #@staticmethod
    #cdef create(CBaslerUsbDeviceInfo* dev_info):
    #    obj = BaslerUsbDeviceInfo()
    #    obj.dev_info = dev_info
    #    return obj

    @staticmethod
    cdef create(CDeviceInfo& dev_info):
        obj = BaslerUsbDeviceInfo()
        obj.dev_info = new CBaslerUsbDeviceInfo(dev_info)
        return obj

    @staticmethod
    cdef create_basler_device_info(CBaslerUsbDeviceInfo* dev_info):
        obj = BaslerUsbDeviceInfo()
        obj.dev_info = dev_info
        return obj

    # ///Retrieves the serial number if it supported by the underlying implementation
    # ///This property is identified by Key::SerialNumberKey.
    property serial_number:
        def __get__(self):
            return self.get_serial_number()

    def get_serial_number(self):
            return (<string>self.dev_info.GetSerialNumber()).decode('ascii')
	
    #Returns true if the above property is available.
    property serial_number_available:
        def __get__(self):
            return self.get_serial_number_available()

    def get_serial_number_available(self):
            return (self.dev_info.IsSerialNumberAvailable()).decode('ascii')

    #Returns true if the above property is available.			
    property user_defined_name_available:
        def __get__(self):
            return self.get_user_defined_name_available()

    def get_user_defined_name_available(self):
            return (self.dev_info.IsUserDefinedNameAvailable()).decode('ascii')

    # ///Retrieves the user-defined name if present.
    # ///This property is identified by Key::UserDefinedNameKey			
    property user_defined_name:
        def __get__(self):
            return self.get_user_defined_name()

    def get_user_defined_name(self):
            return (<string>self.dev_info.GetUserDefinedName()).decode('ascii')

    # ///Retrieves the model name of the device.
    # ///This property is identified by Key::ModelNameKey.
    property model_name:
        def __get__(self):
            return self.get_model_name()

    def get_model_name(self):
            return (<string>self.dev_info.GetModelName()).decode('ascii')

    #Returns true if the above property is available.			
    property model_name_available:
        def __get__(self):
            return self.get_model_name_available()

    def get_model_name_available(self):
            return self.dev_info.IsModelNameAvailable()

    #Returns true if the above property is available.			
    property device_version_available:
        def __get__(self):
            return self.get_device_version_available()

    def get_device_version_available(self):
            return self.IsDeviceVersionAvailable()

    #Retrieves the identifier for the transport layer able to create this device.
    #This property is identified by Key::DeviceFactoryKey.
    property device_factory:
        def __get__(self):
            return self.get_device_factory()

    def get_device_factory(self):
            return (<string>self.dev_info.GetDeviceFactory()).decode('ascii')

    #Returns true if the above property is available.			
    property defice_factory_available:
        def __get__(self):
            return self.get_defice_factory_available()

			
    def get_defice_factory_available(self):
            return self.dev_info.IsDeviceFactoryAvailable()

    # ///Retrieves the human readable name of the device.
    # ///This property is identified by Key::FriendlyNameKey.			
    property friendly_name:
        def __get__(self):
           return self.get_friendly_name()

    def get_friendly_name(self):
           return (<string>self.dev_info.GetFriendlyName()).decode('ascii')

    # ///Retrieves the vendor name of the device.
    # ///This property is identified by Key::VendorNameKey.		   
    property vendor_name:
        def __get__(self):
            return self.get_vendor_name()

    def get_vendor_name(self):
            return (<string>self.dev_info.GetVendorName()).decode('ascii')

    # ///Retrieves the device class device, e.g. BaslerUsb.
    # ///This property is identified by Key::DeviceClassKey.			
    property device_class:
        def __get__(self):
            return self.get_device_class()

    def get_device_class():
            return (<string>self.dev_info.GetDeviceClass()).decode('ascii')
       




