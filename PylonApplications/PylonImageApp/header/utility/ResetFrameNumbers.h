#include "stdafx.h"

#ifndef UTIL_H_   // #include guards
#ifndef UTIL_CPP_   
#define UTIL_H_  

//change to Util.h when create app
#include "utility/Util.h"
#endif 
#endif // UTIL_CPP_  


class ResetFrameNumbers {
private:
	int FindPilotCameras(vector<string>& fileNames, vector<long long>& camerasTimeStamp, vector<string>& cameraIds);
	int FindFrameCorresponding(vector<string>& cameraIds, vector<string>& fileNames, vector<long long>& camerasTimeStamp, int pilot_camera,
		vector<long long>& pilotTimeStamp, bool isRenameFile = false, const char* imageFolder = NULL, const vector<string>& imageDestFolderStrs = vector<string>());
	void GetCameraInfoFromTSFile(string imageFolderStr, vector<long long> &camerasTimeStamp, vector<string> &cameraIds);

public:
	ResetFrameNumbers();
	int FindNumberOfCameras(string imageFolderStr);
	int FindFrameCorresponding(string imageFolderStr, vector<string>& imageDestFolderStrs = vector<string>(), bool changeFileName = false);
	int ResetFrameAuto(string imageFolderStr, vector<string> imageDestFolderStr);
	int ResetFrameManual(string imageFolderStr, vector<string> imageDestFolderStr, vector<int> frameMove);
	int PrintTS(string imageFolderStr);
	int MainMethod();

};
