from pylon.ccontainer cimport DeviceInfoList_t


cdef class DeviceInfoList:
	cdef DeviceInfoList_t* device_info_list_t
	@staticmethod
	cdef create(DeviceInfoList_t* device_info_list_t)