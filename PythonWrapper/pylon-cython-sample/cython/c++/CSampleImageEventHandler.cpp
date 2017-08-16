
#include <pylon/PylonIncludes.h>
#include <pylon/usb/BaslerUsbInstantCamera.h>
#include <iostream>
#include <fstream>

using namespace Pylon;
using namespace GenApi;
using namespace std;
using namespace Basler_UsbCameraParams;

typedef Pylon::CBaslerUsbInstantCamera Camera_t;
typedef CBaslerUsbCameraEventHandler CameraEventHandler_t; // Or use Camera_t::CameraEventHandler_t


														   //Example of an image event handler.
class CSampleImageEventHandler : public CBaslerUsbImageEventHandler
{
public:
	virtual void OnImageGrabbed(Camera_t& camera, const CBaslerUsbGrabResultPtr& ptrGrabResult)
	{
		//std::ofstream file;
		//file.open("note.txt");
		cout << "CSampleImageEventHandler::OnImageGrabbed called." << endl;
		//file.close();
	}
};
