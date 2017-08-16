// PylonImageApp.cpp : Defines the entry point for the console application.
//


#include "stdafx.h"
#include "utility/CaptureImages.h"
#include "utility/ResetFrameNumbers.h"
//#include "VideoCreator.h"

int main(int argc, char* argv[])
{
	int exitCode = 1;
	try {
		int options;
		cout << "Please Enter" << endl;
		cout << "1 to Capture Images" << endl;
		cout << "2 to Reset Frame Number" << endl;
		//cout << "3 to Create Video" << endl;
		cin >> options;

		if (options == 1) {
			CaptureImages captureImageObj;
			captureImageObj.MainMethod();
		}
		else if (options == 2) {
			ResetFrameNumbers resetFNObj;
			resetFNObj.MainMethod();
		}
		/*else if (options == 3) {
			VideoCreator videoCreatorObj;
			videoCreatorObj.MainMethod();
		}*/

	}
	catch (const GenericException &e)
	{
		// Error handling
		cout << e.GetDescription() << endl;
		exitCode = 0;
	}
	cout << "Please enter to exit " << endl;
	while (cin.get() != '\n');
	while (cin.get() != '\n');
	return exitCode;
}

