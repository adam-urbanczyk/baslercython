using namespace std;


// Include files to use the PYLON API.
#include <pylon/PylonIncludes.h>


#include <pylon/usb/BaslerUsbInstantCamera.h>

#include <boost/thread.hpp>
#include <boost/thread/mutex.hpp>
#include "CaptureImages.h">

using namespace Pylon;
using namespace GenApi;



class CCameraUtility {
private:
	CaptureImages captureImageObj;
public:
		bool StartSignal();
		void SaveImage(CBaslerUsbInstantCamera* camera, int c_countOfImagesToGrab, string camera_id, string imageFolder);

		CCameraUtility();
		int Lock();
		int UnLock();
		bool IsThreadRunning();
		int CaptureImage(CBaslerUsbInstantCamera* camera, int c_countOfImagesToGrab, string camera_id, string imageFolder, unsigned int timeIntervalInSeconds = 0);
		int SaveTimeStampToFile(string imageFolder);
};

