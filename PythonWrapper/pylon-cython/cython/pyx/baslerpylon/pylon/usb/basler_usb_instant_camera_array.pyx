from baslerpylon.pylon.usb.cbasler_usb_instant_camera_array cimport CBaslerUsbInstantCameraArray
from baslerpylon.pylon.camera_enum cimport EGrabStrategy, EGrabLoop, ETimeoutHandling, GrabStrategy_OneByOne, TimeoutHandling_ThrowException, GrabLoop_ProvidedByUser, GrabStrategy_OneByOne
from baslerpylon.pylon.usb.cbasler_usb_grab_result_ptr cimport CBaslerUsbGrabResultPtr
from pylon.device cimport Device
from pylon.usb.basler_usb_instant_camera cimport BaslerUsbInstantCamera
from pylon.usb.cbasler_usb_instant_camera cimport CBaslerUsbInstantCamera
from pylon.ctype_mappings cimport String_t
from cython.operator cimport dereference as deref


cdef class BaslerUSBInstantCameraArray:
    #cdef CBaslerUsbInstantCameraArray* getCInstantCameraArray(self):
    #    return self.camera_array

    #def get_index(self, int index):
    #    return BaslerUsbInstantCamera.create_cam_from_caminstant(self.camera_array.GetIndex(index));

    def attach(self, int index, Device device):
        self.camera_array.GetIndex(index).Attach(device.ipython_device)

    def initialize(self, size_t numberOfCameras):
        self.camera_array.Initialize(numberOfCameras)

    property pylon_device_attached:
        def __get__(self):
            return self.camera_array.IsPylonDeviceAttached()

    property camera_device_removed:
        def __get__(self):
            return self.camera_array.IsCameraDeviceRemoved()

    def __del__(self):
        self.camera_array.Close()
        self.camera_array.DetachDevice()
        self.camera_array.DestroyDevice()
        self.camera_array.Destructor()

    def detach_device(self):
        self.camera_array.DetachDevice()

    def get_size(self):
        return self.camera_array.GetSize()

    #def operator(self,int index):
    #    return Camera.create(self.camera_array.operator(index))

    property opened:
        def __get__(self):
            return self.camera_array.IsOpen()
        def __set__(self, opened):
            if self.opened and not opened:
                self.camera_array.Close()
            elif not self.opened and opened:
                self.camera_array.Open()

    def close(self):
        self.camera_array.Close()

    def open(self):
        if not self.opened:
            self.camera_array.Open()

    def start_grabbing(self, EGrabStrategy grabStrategy = GrabStrategy_OneByOne, EGrabLoop grabLoopType = GrabLoop_ProvidedByUser):
        if not self.Open:
            raise Exception('Operation Invalid', 'Camera is not open')

        if self.is_grabbing():
            raise Exception('Operation Invalid', 'Camera is grabbing')

        self.camera_array.StartGrabbing(grabStrategy, grabLoopType)

    def stop_grabbing(self):
        self.camera_array.StopGrabbing()

    def is_grabbing(self):
        return self.camera_array.IsGrabbing();

    #def retrieve_result(self, unsigned int timeoutMs, CBaslerUsbGrabResultPtr grabResult, ETimeoutHandling timeoutHandling = TimeoutHandling_ThrowException):
    #    result = self.camera_array.RetrieveResult(timeoutMs, deref(grabResult.cgrabresultptr),timeoutHandling)
    #    if not result:
    #        raise Exception('Operation Invalid', 'Cannot retreive Grab Result')
