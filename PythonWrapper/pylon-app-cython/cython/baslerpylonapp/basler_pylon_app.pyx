from libcpp.string cimport string
from libcpp cimport bool
import numpy as np

from exception.custom_exception cimport raise_py_error

cdef extern from "<vector>" namespace "std":
    cdef cppclass vector[T]:
        cppclass iterator:
            T operator*()
            iterator operator++()
            bint operator==(iterator)
            bint operator!=(iterator)
        vector()
        void push_back(T&)
        T& operator[](int)
        T& at(int)
        iterator begin()
        iterator end()
		
cdef extern from "utility/CameraUtility.cpp":
    cdef cppclass CCameraUtility:
        int CaptureImage(int c_countOfImagesToGrab, string imageFolder) except +raise_py_error
        int FindFrameCorresponding(string imageFolderStr) except +raise_py_error
        int ResetFrameAuto(string imageFolderStr, vector[string] imageDestFolderStr) except +raise_py_error
        int ResetFrameManual(string imageFolderStr, vector[string] imageDestFolderStr, vector[int] frameMove) except +raise_py_error
		
#cdef extern from "VideoCreator/VideoCreator.cpp":
#    cdef cppclass VideoCreator:
#        void CreateVideo(string folderPathStr, int fps, bool compressVideo)
		


cdef class BaslerPylonApp:
    def capture_image(self,int c_countOfImagesToGrab, string imageFolder):
        (new CCameraUtility()).CaptureImage( c_countOfImagesToGrab,  imageFolder)
	
    def find_frame_corresponding(self,string imageFolderStr):
        (new CCameraUtility()).FindFrameCorresponding( imageFolderStr)
		
    def reset_frame_auto(self,string imageFolderStr, imageDestFolderStrs):
        cdef vector[string] imageDestFolders;
        for i in (imageDestFolderStrs):
            imageDestFolders.push_back(i)
        (new CCameraUtility()).ResetFrameAuto(imageFolderStr,imageDestFolders)
		
    def reset_frame_manual(self,string imageFolderStr, imageDestFolderStrs,  frameMove):
        cdef vector[int] frameMoveVector;
        for i in (frameMove):
            frameMoveVector.push_back(i)
		
        cdef vector[string] imageDestFolders;
        for i in (imageDestFolderStrs):
            imageDestFolders.push_back(i)
			
        (new CCameraUtility()).ResetFrameManual(imageFolderStr,imageDestFolders,frameMoveVector)

    #def create_video(self, string folderPathStr, int fps, bool compressVideo = False):
    #    (new VideoCreator()).CreateVideo( folderPathStr,  fps,  compressVideo)
