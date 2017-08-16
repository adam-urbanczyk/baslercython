

using namespace std;

#ifndef UTIL_H_   // #include guards
#define UTIL_H_  
//change to Util.h when create app
#include "utility/Util.h"
#endif 




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
	static __int64 GetCurTimeCounter(LARGE_INTEGER* li);
	static int WriteCameraTimeStampToFile(vector<Camera_t*> cameraArray, vector<long long> camerasTimeStamp, string imageFolder);
	void SaveTimeStampToFile(CameraArray& cameraArray, string imageFolder);
	void InitCameraArray(CameraArray& cameraArray, int c_countOfImagesToGrab);

public:
	CaptureImages();
	static int Lock();
	static int Unlock();
	int CaptureImage(int c_countOfImagesToGrab, string imageFolder);
	int CaptureImage(Camera_t* camera, int c_countOfImagesToGrab, string imageFolder, unsigned int timeIntervalInSeconds = 0);
	static int SaveTimeStampToFile(vector<Camera_t*> cameraArray, string imageFolder);
	bool IsThreadRunning();

};
