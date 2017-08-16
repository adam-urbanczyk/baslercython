from libcpp.string cimport string
from exception.custom_exception cimport raise_py_error
from pylon.usb.cbasler_usb_instant_camera cimport CBaslerUsbInstantCamera
from libcpp cimport bool
from base.cgcbase cimport vector

cdef extern from "utility/CameraUtility.cpp":
    cdef cppclass CCameraUtility:
        CCameraUtility()
        #int CaptureImageMultipleCameras(int c_countOfImagesToGrab, string imageFolder) except +raise_py_error
        #int CaptureImage(CBaslerUsbInstantCamera* camera, int c_countOfImagesToGrab,string imageFolder) except +raise_py_error
        int CaptureImage(CBaslerUsbInstantCamera* camera, int c_countOfImagesToGrab, string imageFolder, unsigned int timeIntervalInSeconds) except +raise_py_error
        bool IsThreadRunning() except +raise_py_error
        int Lock() except +raise_py_error
        int UnLock() except +raise_py_error
        int SaveTimeStampToFile(vector[CBaslerUsbInstantCamera*] cameraArray, string imageFolder) except +raise_py_error
        