from exception.custom_exception cimport raise_py_error
from pylon.usb.cbasler_usb_device_info cimport CBaslerUsbDeviceInfo
from pylon.cdevice_info cimport CDeviceInfo

cdef extern from "pylon/Container.h" namespace 'Pylon':
	cdef cppclass DeviceInfoList_t:
		cppclass iterator:
			CDeviceInfo operator*()
			iterator operator++() 
			bint operator==(iterator) 
			bint operator!=(iterator) 
		DeviceInfoList_t() 
		CDeviceInfo& operator[](int)
		CDeviceInfo& at(int)
		iterator begin()
		iterator end() 

