from baslerpylon.pylon.camera_enum cimport ECleanup
from pylon.cdevice cimport IPylonDevice
from pylon.usb.cbasler_usb_instant_camera cimport CBaslerUsbInstantCamera
from utility.ccamerautility cimport CCameraUtility
from baslerpylon.pylon.property_map cimport PropertyMap

cdef class BaslerUsbInstantCamera:
    cdef:
        CBaslerUsbInstantCamera camera

    cdef CCameraUtility camera_utility

    cdef PropertyMap propertyMap

    @staticmethod
    cdef create(IPylonDevice* device, ECleanup eCleanup = ?)

    #@staticmethod
    #cdef create_cam_from_caminstant(CBaslerUsbInstantCamera &camera)
	
    cdef CBaslerUsbInstantCamera* get_ccamera(self)