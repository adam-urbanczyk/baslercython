
#ifndef UTIL_CPP_   
#define UTIL_CPP_  
//include util.cpp here so captureimages will not include util.h
#include "utility/Util.cpp"
#endif 


#include "utility/CaptureImages.cpp"
#include "utility/ResetFrameNumbers.cpp"


class CCameraUtility {
private:
	CaptureImages captureCameraObj;
	ResetFrameNumbers resetFNObj;
public:
	CCameraUtility() {

	}

	int Lock() {
		return captureCameraObj.Lock();
	}

	int UnLock() {
		return captureCameraObj.Unlock();
	}

	int CaptureImage(CBaslerUsbInstantCamera* camera, int c_countOfImagesToGrab, string imageFolder, unsigned int timeIntervalInSeconds) {
		return captureCameraObj.CaptureImage(camera, c_countOfImagesToGrab, imageFolder, timeIntervalInSeconds);
	}

	int CaptureImage(int c_countOfImagesToGrab, string imageFolder) {
		return captureCameraObj.CaptureImage(c_countOfImagesToGrab, imageFolder);
	}

	int IsThreadRunning() {
		return captureCameraObj.IsThreadRunning();
	}

	int  SaveTimeStampToFile(vector<Camera_t*> cameraArray, string imageFolder) {
		return captureCameraObj.SaveTimeStampToFile(cameraArray, imageFolder);
	}

	int FindFrameCorresponding(string imageFolderStr) {
		return resetFNObj.FindFrameCorresponding(imageFolderStr);
	}
	
	int ResetFrameAuto(string imageFolderStr, vector<string> imageDestFolderStr) {
			return resetFNObj.ResetFrameAuto(imageFolderStr, imageDestFolderStr);
	}
	
	int ResetFrameManual(string imageFolderStr, vector<string> imageDestFolderStrs, vector<int> frameMove) {
			return resetFNObj.ResetFrameManual(imageFolderStr, imageDestFolderStrs, frameMove);
	}
};






