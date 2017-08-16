from pylon.cdevice cimport IPylonDevice


cdef class Device:
    cdef:
        IPylonDevice* ipython_device

    @staticmethod
    cdef create(IPylonDevice* device)
