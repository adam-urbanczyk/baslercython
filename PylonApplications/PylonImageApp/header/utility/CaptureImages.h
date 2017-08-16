#include "stdafx.h"

using namespace std;

#ifndef UTIL_H_   // #include guards
#ifndef UTIL_CPP_   
#define UTIL_H_  

//change to Util.h when create app
#include "utility/Util.h"
#endif 
#endif // UTIL_CPP_  



#include <boost/thread.hpp>
#include <boost/thread/thread.hpp>
#include <boost/thread/mutex.hpp>
#include <sys/stat.h>




class	CaptureImages {

private:
	static bool startThread;
	bool isThreadRunning;
	static boost::shared_mutex CaptureImages::_access;
	bool StartSignal();
	void SaveImage(Camera_t* camera, string cameraId, int c_countOfImagesToGrab, string imageFolder, unsigned int timeIntervalInSecond = 0);
	__int64 GetCurTimeCounter(LARGE_INTEGER* li);
	int WriteCameraTimeStampToFile(vector<Camera_t*> cameraArray, vector<long long> camerasTimeStamp, string imageFolder);
	void SaveTimeStampToFile(CameraArray& cameraArray, string imageFolder);
	void InitCameraArray(CameraArray& cameraArray, int c_countOfImagesToGrab);

public:
	CaptureImages();
	int Lock();
	int Unlock();
	int CaptureImage(int c_countOfImagesToGrab, string imageFolder);
	int CaptureImage(Camera_t* camera, int c_countOfImagesToGrab, string imageFolder, unsigned int timeIntervalInSeconds = 0);
	int SaveTimeStampToFile(vector<Camera_t*> cameraArray, string imageFolder);
	int MainMethod();
	bool IsThreadRunning();

};
