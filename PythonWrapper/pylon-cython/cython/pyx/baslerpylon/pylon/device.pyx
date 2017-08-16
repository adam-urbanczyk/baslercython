from pylon.cdevice cimport IPylonDevice

cdef class Device:
    @staticmethod  
    cdef create(IPylonDevice* ipython_device):
        obj = Device()
        obj.ipython_device = ipython_device
        return obj