from pylon.ccontainer cimport DeviceInfoList_t


cdef class DeviceInfoList:                             
  
    @staticmethod  
    cdef create(DeviceInfoList_t* device_info_list_t):
        obj = DeviceInfoList()
        obj.device_info_list_t = device_info_list_t
        return obj	

    def _init_(self):
        cdef DeviceInfoList_t device_info_list_t = DeviceInfoList_t()
        return DeviceInfoList.create(<DeviceInfoList_t*>&device_info_list_t)