// CaptureCameraImages.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"


#include "utility/CaptureImages.h"


//#include "VideoCreator.h"

int main(int argc, char* argv[])
{
	int exitCode = 1;
	try {

		CaptureImages captureImageObj;
		//get parameter
		char imageFolder[1000];
		cout << "Please enter Image Path. e.g. C:\\pictures " << "\n";
		cin >> imageFolder;

		//check if image folder is valid here
		struct stat info;

		if (stat(imageFolder, &info) != 0) {
			throw RUNTIME_EXCEPTION("cannot access %s\n", imageFolder);
		}
		else if (info.st_mode & S_IFDIR) { // S_ISDIR() doesn't exist on my windows


			int noOfImages;
			cout << "Please enter number of images " << endl;
			cin >> noOfImages;
			//start to capture images
			//CaptureImages captureImageObj;
			captureImageObj.CaptureImage(noOfImages, imageFolder);

		}
		else {
			throw RUNTIME_EXCEPTION("%s is not a directory\n", imageFolder);
		}


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


