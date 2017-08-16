#include "stdafx.h"

#ifndef UTIL_H_   // #include guards
#define UTIL_H_  
//change to Util.h when create app
#include "utility/Util.h"
#endif 


#include "utility/CaptureImages.h"
#include "utility/ResetFrameNumbers.h"


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






