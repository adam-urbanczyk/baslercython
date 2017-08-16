#include "stdafx.h"
#include "utility/ResetFrameNumbers.h"
//#include "VideoCreator.h"

int main(int argc, char* argv[])
{
	int exitCode = 1;
	try {
		
		ResetFrameNumbers resetFNObj;
		//get parameter
		char imageFolder[1000];
		char imageDestFolder[1000];
		cout << "Please enter Image Source Path. e.g. C:\\pictures " << "\n";
		cin >> imageFolder;

		bool isRenameFile;
		char renameFile[1000];
		cout << "Do you want to rename the files (Y,N) " << "\n";
		cin >> renameFile;
		if (strcmp("Y", renameFile) == 0) {
			isRenameFile = true;
		}
		else {
			isRenameFile = false;
		}

		//ResetFrameNumbers resetFN;

		int noOfCamera = resetFNObj.FindNumberOfCameras(imageFolder);
		//if rename file: ask user to rename file manual or auto, else find frame corresponding
		if (isRenameFile) {
			vector<string> imageDestFolders;
			for (int i = 0; i < noOfCamera; i++) {
				cout << "Please enter Image Destination Path (e.g. C:\\pictures) for camera " << i << "\n";
				cin >> imageDestFolder;
				imageDestFolders.push_back(imageDestFolder);
			}
			char autoRenameFile[1000];
			cout << "Do you want the system to auto rename the file (Y,N) " << "\n";
			cin >> autoRenameFile;

			if (strcmp("Y", autoRenameFile) == 0) {
				cout << "autorename" << endl;
				resetFNObj.ResetFrameAuto(imageFolder, imageDestFolders);
			}
			else {
				vector<int> frameMove;
				for (int i = 0; i < noOfCamera; i++) {
					int frameChange;
					cout << "Please enter the frame to increase for camera " << i << "\n";
					cin >> frameChange;
					frameMove.push_back(frameChange);
				}

				resetFNObj.ResetFrameManual(imageFolder, imageDestFolders, frameMove);
			}
		}
		else {
			resetFNObj.FindFrameCorresponding(imageFolder);
			//PrintTS(imageFolder);
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
