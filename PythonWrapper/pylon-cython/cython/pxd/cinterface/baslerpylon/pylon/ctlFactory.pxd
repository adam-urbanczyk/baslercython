from pylon.ccontainer cimport DeviceInfoList_t
from pylon.cdevice cimport IPylonDevice
from libcpp cimport bool
from pylon.cdevice_info cimport CDeviceInfo
from pylon.ctype_mappings cimport String_t
from exception.custom_exception cimport raise_py_error
from pylon.cdevice_factory cimport IDeviceFactory

cdef extern from "pylon/TlFactory.h" namespace 'Pylon':    
    cdef cppclass CTlFactory:
        # /// Retrieve the transport layer factory singleton.
        # /// Throws an exception when Pylon::PylonInitialize() has not been called before.
        @staticmethod
        CTlFactory& GetInstance() except +raise_py_error

        # returns a list of available devices, see IDeviceFactory for more information
        int EnumerateDevices( DeviceInfoList_t& list, bool addToList) except +raise_py_error
        int EnumerateDevices( DeviceInfoList_t& list) except +raise_py_error
        int EnumerateDevices( DeviceInfoList_t& list, const DeviceInfoList_t& filter, bool addToList ) except +raise_py_error
        int EnumerateDevices( DeviceInfoList_t& list, const DeviceInfoList_t& filter) except +raise_py_error

        # creates first found device from a device info object, see IDeviceFactory for more information
        IPylonDevice* CreateFirstDevice(CDeviceInfo& di) except  +raise_py_error
        IPylonDevice* CreateFirstDevice() except  +raise_py_error

        # creates a device from a device info object, see IDeviceFactory for more information
        #IPylonDevice* CreateDevice(  String_t& ) except  +raise_py_error
        IPylonDevice* CreateDevice(  CDeviceInfo& di) except  +raise_py_error

        void DestroyDevice( IPylonDevice* )  except +raise_py_error
        bool IsDeviceAccessible(CDeviceInfo& deviceInfo) except +raise_py_error
        void Destructor "~CTlFactory"()  except +raise_py_error

# Hack to overcome get exception
cdef extern from "pylon/PylonIncludes.h"  namespace 'Pylon::CTlFactory':
    CTlFactory& GetInstance()

