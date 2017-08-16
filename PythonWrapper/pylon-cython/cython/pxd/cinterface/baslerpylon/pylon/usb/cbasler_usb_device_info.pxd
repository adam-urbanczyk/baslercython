from pylon.ctype_mappings cimport String_t
from exception.custom_exception cimport raise_py_error
from pylon.cdevice_info cimport CDeviceInfo

from libcpp cimport bool

cdef extern from "pylon/usb/BaslerUsbDeviceInfo.h" namespace 'Pylon':
    cdef cppclass CBaslerUsbDeviceInfo(CDeviceInfo):
        CBaslerUsbDeviceInfo()
        CBaslerUsbDeviceInfo(CDeviceInfo& di)

        #Retrieves the device GUID.
        #This property is identified by Key::DeviceGUID.
        String_t GetDeviceGUID() except +raise_py_error
        #Returns true if the above property is available.
        bool IsDeviceGUIDAvailable() except +raise_py_error

        #Retrieves the manufacturer info.
        #This property is identified by Key::ManufacturerInfo.
        String_t GetManufacturerInfo() except +raise_py_error
        #Returns true if the above property is available.
        bool IsManufacturerInfoAvailable() except +raise_py_error

        #Retrieves the device index. For internal use only.
        #This property is identified by Key::DeviceIdx.
        String_t GetDeviceIdx() except +raise_py_error
        #Returns true if the above property is available.
        bool IsDeviceIdxAvailable() except +raise_py_error

        #Retrieves the product ID. For internal use only.
        #This property is identified by Key::DeviceIdx.
        String_t GetProductId() except +raise_py_error
        #Returns true if the above property is available.
        bool IsProductIdAvailable() except +raise_py_error

        #Retrieves the vendor ID. For internal use only.
        #This property is identified by Key::DeviceIdx.
        String_t GetVendorId() except +raise_py_error
        #Returns true if the above property is available.
        bool IsVendorIdAvailable() except +raise_py_error

        #Retrieves the driver key name. For internal use only.
        #This property is identified by Key::DriverKeyName.
        String_t GetDriverKeyName() except +raise_py_error
        #Returns true if the above property is available.
        bool IsDriverKeyNameAvailable() except +raise_py_error

        #Retrieves the usb driver type. For internal use only.
        #This property is identified by Key::UsbDriverTypeKey.
        String_t GetUsbDriverType() except +raise_py_error
        #Returns true if the above property is available.
        bool IsUsbDriverTypeAvailable() except +raise_py_error

        #Retrieves the transfer mode. For internal use only.
        #This property is identified by Key::TransferModeKey
        #Returns either dtx or btx (direct vs. buffered transfer)
        String_t GetTransferMode() except +raise_py_error
        #Returns true if the above property is available.
        bool IsTransferModeAvailable() except +raise_py_error

        ###############################################
        ##method inherit from cdevice_info

        # /* The underlying implementation does not need to support all the listed properties.
        # The properties that are not supported always have the value "N/A" which is the value of CInfoBase::PropertyNotAvailable */
        #
        # ///Retrieves the serial number if it supported by the underlying implementation
        # ///This property is identified by Key::SerialNumberKey.
        String_t GetSerialNumber() except +raise_py_error


        #Returns true if the above property is available.
        bool IsSerialNumberAvailable() except +raise_py_error

        # ///Retrieves the user-defined name if present.
        # ///This property is identified by Key::UserDefinedNameKey.
        String_t GetUserDefinedName() except +raise_py_error

        #Returns true if the above property is available.
        bool IsUserDefinedNameAvailable() except +raise_py_error

        # ///Retrieves the model name of the device.
        # ///This property is identified by Key::ModelNameKey.
        String_t GetModelName() except +raise_py_error

        #Returns true if the above property is available.
        bool IsModelNameAvailable() except +raise_py_error

        #Retrieves the version string of the device.
        #This property is identified by Key::DeviceVersionKey.
        String_t GetDeviceVersion() except +raise_py_error

        #Returns true if the above property is available.
        bool IsDeviceVersionAvailable() except +raise_py_error

        #Retrieves the identifier for the transport layer able to create this device.
        #This property is identified by Key::DeviceFactoryKey.
        String_t GetDeviceFactory() except +raise_py_error

        #Returns true if the above property is available.
        bool IsDeviceFactoryAvailable() except +raise_py_error

        # ///Retrieves the location where the XML file was loaded from.
        # ///This property is identified by Key::XMLSourceKey.
        # ///You must use the DeviceInfo of an opened IPylonDevice to retrieve this property.
        String_t GetXMLSource() except +raise_py_error

        #Returns true if the above property is available.
        bool IsXMLSourceAvailable() except +raise_py_error

        ###method inherit from infobase
        # /* The underlying implementation does not need to support all the listed properties.
        # The properties that are not supported always have the value "N/A" which is the value of CInfoBase::PropertyNotAvailable */
        #
        # ///Retrieves the human readable name of the device.
        # ///This property is identified by Key::FriendlyNameKey.
        String_t GetFriendlyName() except +raise_py_error
        #Returns true if the above property is available.
        bool IsFriendlyNameAvailable() except +raise_py_error

        # ///Retrieves the full name identifying the device.
        # ///This property is identified by Key::FullNameKey.
        String_t GetFullName() except +raise_py_error
        #Returns true if the above property is available.
        bool IsFullNameAvailable() except +raise_py_error

        # ///Retrieves the vendor name of the device.
        # ///This property is identified by Key::VendorNameKey.
        String_t GetVendorName() except +raise_py_error
        #Returns true if the above property is available.
        bool IsVendorNameAvailable() except +raise_py_error

        # ///Retrieves the device class device, e.g. Basler1394.
        # ///This property is identified by Key::DeviceClassKey.
        String_t GetDeviceClass() except +raise_py_error
        #Returns true if the above property is available.
        bool IsDeviceClassAvailable() except +raise_py_error




