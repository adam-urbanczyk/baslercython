// Include files to use the PYLON API.
#include <pylon/PylonIncludes.h>

#include <pylon/usb/BaslerUsbInstantCamera.h>
#include <pylon/usb/BaslerUsbInstantCameraArray.h>

#include <windows.h>
#include <iostream>
#include <fstream>

#include <boost/algorithm/string/split.hpp>
#include <boost/algorithm/string.hpp>
#include <boost/lexical_cast.hpp>
#include <dirent.h>
#include <sys/stat.h>


// Namespace for using pylon objects.
using namespace Pylon;
using namespace GenApi;
using namespace std;
using namespace Basler_UsbCameraParams;


typedef Pylon::CBaslerUsbInstantCamera Camera_t;
typedef Pylon::CBaslerUsbGrabResultPtr GrabResultPtr_t;
typedef Pylon::CBaslerUsbInstantCameraArray CameraArray;
typedef CBaslerUsbCameraEventHandler CameraEventHandler_t;


class Util {

private:
	typedef vector <string> list_type;
public:
	static const char* CAMERA_TIME_STAMP_FILE_NAME;
	static string ConvertIntToString(int value);
	static int CheckDir(string dir);
	static int CompareLens(string a, string b);
	static int ConvertStringToInt(string str);
	static long long ConvertStringToLL(string str);
	static string GetCameraIDFromString(string fileName);
	static int GetImageFrameNoFromFileName(string fileName);
	static  long long GetImageTimeStampFromFileName(string fileName);
	static bool CopyImageFile(const char *SRC, const char* DEST);
	static string GetCameraID(Camera_t* camera);
	static long long GetCameraTSFromLine(string string);
	static int GetIndex(string& element, vector<string>& array);
};
