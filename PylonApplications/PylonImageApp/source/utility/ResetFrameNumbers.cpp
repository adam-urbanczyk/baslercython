#include "stdafx.h"
#include "utility/ResetFrameNumbers.h"



int ResetFrameNumbers::FindPilotCameras(vector<string>& fileNames, vector<long long>& camerasTimeStamp, vector<string>& cameraIds) {
	//find pilot cameras. find the camera that start latest
	int pilot_camera = 0;
	long long pilotStartTimeStamp = 0;
	//cout << camerasTimeStamp.size() << endl;
	for (int i = 0; i < fileNames.size(); i++) {
		int frameNo = Util::GetImageFrameNoFromFileName(fileNames[i]);
		string cameraId = Util::GetCameraIDFromString(fileNames[i]);
		int cameraIndex = Util::GetIndex(cameraId, cameraIds);
		if (frameNo == 0) {
			long long timestamp = Util::GetImageTimeStampFromFileName(fileNames[i]);
			if (pilotStartTimeStamp == 0) {
				pilotStartTimeStamp = timestamp;
				pilot_camera = cameraIndex;
			}
			else {
				//consider the different in the timestamp between cameras
				long long timeDiff = camerasTimeStamp[pilot_camera] - camerasTimeStamp[cameraIndex];
 
				if (timestamp + timeDiff > pilotStartTimeStamp) {
					pilotStartTimeStamp = timestamp;
					pilot_camera = cameraIndex;
				}
			}
		}
	}

	return pilot_camera;
}



////////
///pilot_camera: ---------------frame0--frame1---frame2---frame3--..............frame(N-3)---frame(N-2)---frame(n-1)---frame(n)
///camera 1:---frame0---frame1--frame2--frame3---frame4---frame4--..............frame(N-1)---frame(N)
///camera 2:------------frame0--frame1--frame2---frame3---frame4--..............frame(N-2)---frame(N-1)---frame(N)
/////after the reset: 
///pilot_camera: keep frame0 to frame(N-2)
///camera1: frame2 to frame N rename to frame0 to frame(N-2)
///camera2: frame1 to frame N-1 rename to frame0 to frame(N-2)

int ResetFrameNumbers::FindFrameCorresponding(vector<string>& cameraIds, vector<string>& fileNames, vector<long long>& camerasTimeStamp, int pilot_camera,
	vector<long long>& pilotTimeStamp, bool isRenameFile, const char* imageFolder, const vector<string>& imageDestFolderStrs) {

	vector<int> curCounter;
	vector<int> startCounter;
	vector<vector<string>> oldFileNameArray;
	vector<vector<string>> newFileNameArray;
	//use camerasTimeStamp to get the size of the camera to initialize
	for (int i = 0; i < camerasTimeStamp.size(); i++) {
		curCounter.push_back(0);
		startCounter.push_back(0);
		vector<string> oldFileNames;
		oldFileNameArray.push_back(oldFileNames);
		vector<string> newFileNames;
		newFileNameArray.push_back(newFileNames);
	}

	//output the result to resetframeresult
	std::ofstream file("resetframeresult.txt");

	for (int i = 0; i < fileNames.size(); i++) {
		long long timestamp = Util::GetImageTimeStampFromFileName(fileNames[i]);
		string cameraId = Util::GetCameraIDFromString(fileNames[i]);
		int cameraIndex = Util::GetIndex(cameraId, cameraIds);

		int frameNo = Util::GetImageFrameNoFromFileName(fileNames[i]);
		long long timeDiff = camerasTimeStamp[pilot_camera] - camerasTimeStamp[cameraIndex];
		long long min_time_stamp = timestamp + timeDiff - pilotTimeStamp[curCounter[cameraIndex]];


		//abs cause error for non c++11, so use a trivial method
		min_time_stamp = min_time_stamp < 0 ? min_time_stamp *= -1 : min_time_stamp;

		if (cameraIndex != pilot_camera) {
			int corr_frame = curCounter[cameraIndex];
			//check in the range 100
			for (int i = curCounter[cameraIndex]; i < min(pilotTimeStamp.size(), curCounter[cameraIndex] + 100); i++) {
				long long curTimeDiff = timestamp + timeDiff - pilotTimeStamp[i];
				curTimeDiff = curTimeDiff < 0 ? curTimeDiff *= -1 : curTimeDiff;
				if (min_time_stamp > curTimeDiff) {

					min_time_stamp = curTimeDiff;
					corr_frame = i;

					//cout << corr_frame << endl;
				}
			}

	
			curCounter[cameraIndex] = corr_frame;

			//set start counter to the latest frames that match fram 0 of the pilot cameras
			if (corr_frame == 0) {
				startCounter[cameraIndex] = frameNo;
			}

		}
		else {
			curCounter[cameraIndex] = frameNo;
		}

		//get the new file name and old file name to rename
		char newFileName[400];
		char oldfileName[400];

		if (isRenameFile) {
			snprintf(newFileName, sizeof(newFileName), "%s\\%s_%d_%lld_.bmp", imageDestFolderStrs[cameraIndex].c_str(), cameraId.c_str(), curCounter[cameraIndex], timestamp);
			snprintf(oldfileName, sizeof(oldfileName), "%s\\%s", imageFolder, fileNames[i].c_str());
			oldFileNameArray[cameraIndex].push_back(oldfileName);
			newFileNameArray[cameraIndex].push_back(newFileName);
			//file << "change from " << fileNames[i] << " to: " << newFileName << endl;
			//cout << "change from " << oldfileName << " to: " << newFileName << endl;
			//cout << Util::CopyImageFile(oldfileName, newFileName) << endl;
		}
		else {
			snprintf(newFileName, sizeof(newFileName), "%s_%d_%lld_.bmp", cameraId, curCounter[cameraIndex], timestamp);
			//snprintf(oldfileName, sizeof(oldfileName), "%d_%d_%lld_.bmp", cameraId, frameNo, timestamp);
			file << "change from " << fileNames[i] << " to: " << newFileName << endl;
			cout << "change from " << fileNames[i] << " to: " << newFileName << endl;

		}
	}

	if (isRenameFile) {
		int minEnd = *min_element(curCounter.begin(), curCounter.end());
		for (int i = 0; i < newFileNameArray.size(); i++) {
			cout << "rename camera index: " << i << " frame: " << startCounter[i] << " - " << startCounter[i] + minEnd << " to frame: " << 0 << " - " << minEnd << endl;
			for (int j = startCounter[i]; j <= startCounter[i]+ minEnd; j++) {
				file << "change from " << oldFileNameArray[i][j] << " to: " << newFileNameArray[i][j] << endl;
				//cout << "change from " << oldFileNameArray[i][j] << " to: " << newFileNameArray[i][j] << endl;
				Util::CopyImageFile(oldFileNameArray[i][j].c_str(), newFileNameArray[i][j].c_str());
			}
		}
	}

	return 1;
}



void ResetFrameNumbers::GetCameraInfoFromTSFile(string imageFolderStr, vector<long long> &camerasTimeStamp, vector<string> &cameraIds) {
	char time_stamp_file[400];
	snprintf(time_stamp_file, sizeof(time_stamp_file), "%s\\%s", imageFolderStr.c_str(), Util::CAMERA_TIME_STAMP_FILE_NAME);
	ifstream file(time_stamp_file);
	string line;
	//vector<string> cameraIds;
	//open file to check the number of line, e.g. the number of cameras
	if (file.is_open())
	{
		while (getline(file, line))
		{
			string cameraID = Util::GetCameraIDFromString(line);
			if (std::find(cameraIds.begin(), cameraIds.end(), cameraID) == cameraIds.end()) {
				cameraIds.push_back(cameraID);
			}

			camerasTimeStamp.push_back(Util::GetCameraTSFromLine(line));

		}
		file.close();
	}
	else {
		throw RUNTIME_EXCEPTION("Cannot Open camera_start_timestamp.txt file ");
	}
}




ResetFrameNumbers::ResetFrameNumbers() {

}

int ResetFrameNumbers::FindNumberOfCameras(string imageFolderStr) {
	vector<long long> cameraTS;
	vector<string> cameraIds;
	GetCameraInfoFromTSFile(imageFolderStr, cameraTS, cameraIds);
	return (int)cameraIds.size();
}

int ResetFrameNumbers::FindFrameCorresponding(string imageFolderStr, vector<string>& imageDestFolderStrs, bool changeFileName) {
	//get parameter
	DIR *pDIR;
	struct dirent *entry;

	const char* imageFolder = imageFolderStr.c_str();

	int noOfCamera = 0;
	//string line;
	//char time_stamp_file[400];
	//snprintf(time_stamp_file, sizeof(time_stamp_file), "%s\\%s", imageFolder, Util::CAMERA_TIME_STAMP_FILE_NAME);

	//ifstream file(time_stamp_file);
	vector<long long> camerasTimeStamp;
	vector<long long> pilotTimeStamp;
	vector<string> cameraIds;
	
	GetCameraInfoFromTSFile(imageFolderStr, camerasTimeStamp, cameraIds);


	//open file to read the timestamp from the camera_start_timestamp.txt
	//file.open(time_stamp_file);
	//if (file.is_open())
	//{
	//	while (getline(file, line))
	//	{
	//		camerasTimeStamp[Util::GetIndex(Util::GetCameraIDFromString(line), cameraIds)] = Util::GetCameraTSFromLine(line);
	//	}
	//	file.close();
	//}

	vector<string> fileNames;

	if (pDIR = opendir(imageFolder)) {
		//get all the file names
		while (entry = readdir(pDIR)) {
			if (strcmp(entry->d_name, ".") != 0 && strcmp(entry->d_name, "..") != 0 && strcmp(entry->d_name, Util::CAMERA_TIME_STAMP_FILE_NAME) != 0) {
				fileNames.push_back(entry->d_name);
			}
		}

		//sort file name
		if (fileNames.size() > 0) {
			cout << "Sorting the file names......" << endl;
			std::sort(fileNames.begin(), fileNames.end(), Util::CompareLens);
			cout << "Finish sorting the file names......" << endl;
		}

		//find pilot cameras. find the camera that start latest
		int pilot_camera = FindPilotCameras(fileNames, camerasTimeStamp, cameraIds);

		cout << "pilot_camera " << pilot_camera << endl;
		//get timestamp of all the frames of pilot cameras
		for (int i = 0; i < fileNames.size(); i++) {
			int cameraIndex = Util::GetIndex(Util::GetCameraIDFromString(fileNames[i]), cameraIds);
			if (cameraIndex == pilot_camera) {
				long long timestamp = Util::GetImageTimeStampFromFileName(fileNames[i]);
				pilotTimeStamp.push_back(timestamp);
			}
		}

		FindFrameCorresponding(cameraIds, fileNames, camerasTimeStamp, pilot_camera, pilotTimeStamp, changeFileName, imageFolderStr.c_str(), imageDestFolderStrs);

		//file.close();
		closedir(pDIR);
	}

	return 1;
}


int ResetFrameNumbers::ResetFrameAuto(string imageFolderStr, vector<string> imageDestFolderStr) {
	return FindFrameCorresponding(imageFolderStr, imageDestFolderStr, true);
}

int ResetFrameNumbers::ResetFrameManual(string imageFolderStr, vector<string> imageDestFolderStr, vector<int> frameMove) {
	//get parameter
	DIR *pDIR;
	struct dirent *entry;
	vector<string> fileNames;

	const char* imageFolder = imageFolderStr.c_str();
	//const char* imageDestFolder = imageDestFolderStr.c_str();

	if (pDIR = opendir(imageFolder)) {
		//get all the file names
		while (entry = readdir(pDIR)) {
			if (strcmp(entry->d_name, ".") != 0 && strcmp(entry->d_name, "..") != 0 && strcmp(entry->d_name, Util::CAMERA_TIME_STAMP_FILE_NAME) != 0) {
				fileNames.push_back(entry->d_name);
			}
		}

		//sort file name
		if (fileNames.size() > 0) {
			cout << "Sorting the file names......" << endl;
			std::sort(fileNames.begin(), fileNames.end(), Util::CompareLens);
			cout << "Finish sorting the file names......" << endl;
		}
	}

	//get cameraIds array
	vector<string> cameraIds;
	vector<long long> cameraTS;
	GetCameraInfoFromTSFile(imageFolderStr, cameraTS, cameraIds);

	for (int i = 0; i < fileNames.size(); i++) {
		long long timestamp = Util::GetImageTimeStampFromFileName(fileNames[i]);
		string cameraId = Util::GetCameraIDFromString(fileNames[i]);
		int cameraIndex = Util::GetIndex(cameraId, cameraIds);


		if (cameraIndex < frameMove.size()) {
			int frameNo = Util::GetImageFrameNoFromFileName(fileNames[i]);
			int corr_frame = frameNo + frameMove[cameraIndex];

			char newFileName[400];
			char oldfileName[400];

			snprintf(newFileName, sizeof(newFileName), "%s\\%s_%d_%lld_.bmp", imageDestFolderStr[cameraIndex].c_str(), cameraId.c_str(), corr_frame, timestamp);
			snprintf(oldfileName, sizeof(oldfileName), "%s\\%s", imageFolder, fileNames[i].c_str());
			cout << "change from " << oldfileName << " to: " << newFileName << endl;
			cout << Util::CopyImageFile(oldfileName, newFileName) << endl;
		}
	}

	return 1;
}


int ResetFrameNumbers::PrintTS(string imageFolderStr) {
	DIR *pDIR;
	struct dirent *entry;

	const char* imageFolder = imageFolderStr.c_str();



	vector<string> fileNames;

	if (pDIR = opendir(imageFolder)) {
		//get all the file names
		while (entry = readdir(pDIR)) {
			if (strcmp(entry->d_name, ".") != 0 && strcmp(entry->d_name, "..") != 0 && strcmp(entry->d_name, Util::CAMERA_TIME_STAMP_FILE_NAME) != 0) {
				fileNames.push_back(entry->d_name);
			}
		}

		//sort file name
		if (fileNames.size() > 0) {
			std::sort(fileNames.begin(), fileNames.end(), Util::CompareLens);
		}

		string cur = "";
		for (int i = 0; i < fileNames.size(); i++) {
			long long timestamp = Util::GetImageTimeStampFromFileName(fileNames[i]);
			string cameraId = Util::GetCameraIDFromString(fileNames[i]);
			//if (cameraId != cur) {
			//cout << cameraId << endl;
			//}

			cout << timestamp << endl;
		}

	}
}

int ResetFrameNumbers::MainMethod()
{
	
	return 1;
}
