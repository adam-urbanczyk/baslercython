#include "stdafx.h"
#include "utility/CaptureImages.h"
#include <pylon/WaitObject.h>




//flag and mutex to trigger the cameras to capture images at the same time
bool CaptureImages::startThread;
boost::shared_mutex CaptureImages::_access;

bool CaptureImages::StartSignal() {
	boost::shared_lock<boost::shared_mutex> lock(_access);
	return startThread;
}

//this method will trigger camera to capture images and save images to the imagefolder
void CaptureImages::SaveImage(Camera_t* camera, string cameraId, int c_countOfImagesToGrab, string imageFolder, unsigned int timeIntervalInSeconds) {
	isThreadRunning = true;
	try {
		//wait to start all thread at the same time
		while (!StartSignal()) {
			cout << "camera " << cameraId << " waiting to start " << endl;
		}
		cout << "camera " << cameraId << " start to grab images " << endl;
		GrabResultPtr_t ptrGrabResult;
		int currentCount = 0;
		
		if ( timeIntervalInSeconds == 0 ){ //default path - time between frames dependent on frame rate of the camera.
			camera->StartGrabbing(c_countOfImagesToGrab);
			while (camera->IsGrabbing())
			{
				camera->RetrieveResult(50, ptrGrabResult, TimeoutHandling_ThrowException);
				if (ptrGrabResult->GrabSucceeded()) {
					//save images to folder, the image name is: cameraId_frameNo_timestamp_.bmp
					std::stringstream ss;
					ss << imageFolder << "\\" << cameraId << "_" << currentCount++ << "_" << ptrGrabResult->ChunkTimestamp.GetValue() << "_.bmp";
					std::string s = ss.str();
					CImagePersistence::Save(ImageFileFormat_Bmp, s.c_str(), ptrGrabResult);
				}
			}
		}
		else{
            // Register the standard configuration event handler for enabling software triggering.
            // The software trigger configuration handler replaces the default configuration
            // as all currently registered configuration handlers are removed by setting the registration mode to RegistrationMode_ReplaceAll.
            camera->RegisterConfiguration( new CSoftwareTriggerConfiguration, RegistrationMode_ReplaceAll, Cleanup_Delete);

            // The MaxNumBuffer parameter can be used to control the count of buffers
            // allocated for grabbing. The default value of this parameter is 10.
            camera->MaxNumBuffer = 15;

			//for (int i = 0; i < c_countOfImagesToGrab; ++i){
            //    camera->GrabOne(50, ptrGrabResult);
			//	//camera->RetrieveResult(50, ptrGrabResult, TimeoutHandling_ThrowException);
			//	if (ptrGrabResult->GrabSucceeded()) {
			//		//save images to folder, the image name is: cameraId_frameNo_timestamp_.bmp
			//		std::stringstream ss;
			//		ss << imageFolder << "\\" << cameraId << "_" << i << "_" << ptrGrabResult->ChunkTimestamp.GetValue() << "_.bmp";
			//		std::string s = ss.str();
			//		CImagePersistence::Save(ImageFileFormat_Bmp, s.c_str(), ptrGrabResult);
			//	}
			//	//boost::this_thread::sleep( boost::posix_time::seconds(timeIntervalInSeconds) );
            //    WaitObject::Sleep(timeIntervalInSeconds * 1000);
            if (camera->CanWaitForFrameTriggerReady())
            {
                //cout << "Grab using the GrabStrategy_OneByOne default strategy:" << endl << endl;

                // The GrabStrategy_OneByOne strategy is used. The images are processed
                // in the order of their arrival.
                camera->StartGrabbing( GrabStrategy_LatestImageOnly);

                // In the background, the grab engine thread retrieves the
                // image data and queues the buffers into the internal output queue.

                // Issue software triggers. For each call, wait up to 1000 ms until the camera is ready for triggering the next image.
                //for ( int i = 0; i < 5; ++i)
                //{
                    //if ( camera->WaitForFrameTriggerReady( 5000, TimeoutHandling_ThrowException))
                    //{
                        camera->ExecuteSoftwareTrigger();
                        //WaitObject::Sleep( timeIntervalInSeconds*1000);
                    //}
                //}

                // For demonstration purposes, wait for the last image to appear in the output queue.
                WaitObject::Sleep( 5* timeIntervalInSeconds*1000);

                // Check that grab results are waiting.
                //if ( camera->GetGrabResultWaitObject().Wait( 0))
               // {
                //    cout << endl << "Grab results wait in the output queue." << endl << endl;
                //}

                // All triggered images are still waiting in the output queue
                // and are now retrieved.
                // The grabbing continues in the background, e.g. when using hardware trigger mode,
                // as long as the grab engine does not run out of buffers.
                int nBuffersInQueue = 0;
                while( camera->RetrieveResult( 0, ptrGrabResult, TimeoutHandling_Return) && nBuffersInQueue < 5)
                {
                    if (!ptrGrabResult->GrabSucceeded()){
                        cout << "Error: "  << ptrGrabResult->GetErrorCode() << " " << ptrGrabResult->GetErrorDescription() << endl;
                    }
                    else{
                        nBuffersInQueue++;
                        //save images to folder, the image name is: cameraId_frameNo_timestamp_.bmp
                        std::stringstream ss;
                        ss << imageFolder << "\\" << cameraId << "_" << currentCount++ << "_" << ptrGrabResult->ChunkTimestamp.GetValue() << "_.bmp";
                        std::string s = ss.str();
                        CImagePersistence::Save(ImageFileFormat_Bmp, s.c_str(), ptrGrabResult);
                        WaitObject::Sleep( timeIntervalInSeconds*1000);
                    }
                }
                

                cout << "Retrieved " << nBuffersInQueue << " grab results from output queue." << endl << endl;

                //Stop the grabbing.
                camera->StopGrabbing();
            }
			
		}
	}
	catch (const GenericException &e)
	{
		// Error handling
		isThreadRunning = false;
		cout << e.GetDescription() << endl;
	}
	isThreadRunning = false;
}

__int64 CaptureImages::GetCurTimeCounter(LARGE_INTEGER* li) {
	if (!QueryPerformanceFrequency(li))
		cout << "QueryPerformanceFrequency failed!\n";
	QueryPerformanceCounter(li);
	return li->QuadPart;
}


int CaptureImages::WriteCameraTimeStampToFile(vector<Camera_t*> cameraArray, vector<long long> camerasTimeStamp, string imageFolder) {
	std::stringstream ss;
	ss << imageFolder << "\\" << Util::CAMERA_TIME_STAMP_FILE_NAME;
	std::string fileName = ss.str();
	std::ofstream file(fileName.c_str());
	for (int i = 0; i < cameraArray.size(); i++) {
		file << Util::GetCameraID(cameraArray[i]);
		file << "_";
		file << camerasTimeStamp[i];
		file << "_";
		file << cameraArray[i]->GetDeviceInfo().GetFriendlyName() << std::endl;
	}
	file.close();
	return 1;
}
//this method will save the cameras timestamp to file camera_start_timestamp.txt in the image folder
void CaptureImages::SaveTimeStampToFile(CameraArray& cameraArray, string imageFolder) {
	vector<Camera_t*> cameraVector;
	for (int i = 0; i < cameraArray.GetSize(); i++)
	{
		cameraVector.push_back(&cameraArray[i]);
	}
	//LARGE_INTEGER li;
	//if (!QueryPerformanceFrequency(&li))
	//	cout << "QueryPerformanceFrequency failed!\n";
	//QueryPerformanceFrequency(&li);
	//double PCFreq = double(li.QuadPart) / 1000000.0;
	//__int64 CounterStart = GetCurTimeCounter(&li);
	//double time2 = double(li.QuadPart - CounterStart) / PCFreq;
	//vector<long long> camerasTimeStamp;
	//for (int i = 0; i < cameraArray.GetSize(); i++)
	//{
	//	//get the time stamp of the camera, get the system time
	//	//deduct these value to get the time different between camera and the computer
	//	//save this value to file for post processing later
	//	cameraArray[i].TimestampLatch.Execute();
	//	long long timestamp = cameraArray[i].TimestampLatchValue.GetValue();
	//	cout << "camerasTimeStamp " << i << " " << timestamp << endl;
	//	long long sysTime = long long((GetCurTimeCounter(&li) - CounterStart) / PCFreq);
	//	cout << "systime " << i << " " << sysTime << endl;
	//	long long curTime = timestamp - sysTime * 1000; //system time is miniseconds decimal number, *1000 to get around the nanoseconds value
	//	camerasTimeStamp.push_back(curTime);
	//	cout << "camerasTimeStamp compared to the machine " << i << " " << curTime << endl;
	//}

	////save SaveTimeStampToFile to find, the format is: cameraNo_timestamp_cameraname
	SaveTimeStampToFile(cameraVector, imageFolder);
}


//this method will save the cameras timestamp to file camera_start_timestamp.txt in the image folder
int CaptureImages::SaveTimeStampToFile(vector<Camera_t*> cameraArray, string imageFolder) {
	LARGE_INTEGER li;
	if (!QueryPerformanceFrequency(&li))
		cout << "QueryPerformanceFrequency failed!\n";
	QueryPerformanceFrequency(&li);
	double PCFreq = double(li.QuadPart) / 1000000.0;
	__int64 CounterStart = GetCurTimeCounter(&li);
	double time2 = double(li.QuadPart - CounterStart) / PCFreq;
	vector<long long> camerasTimeStamp;
	for (int i = 0; i < cameraArray.size(); i++)
	{
		//get the time stamp of the camera, get the system time
		//deduct these value to get the time different between camera and the computer
		//save this value to file for post processing later
		cameraArray[i]->TimestampLatch.Execute();
		long long timestamp = cameraArray[i]->TimestampLatchValue.GetValue();
		cout << "camerasTimeStamp " << i << " " << timestamp << endl;
		long long sysTime = long long((GetCurTimeCounter(&li) - CounterStart) / PCFreq);
		cout << "systime " << i << " " << sysTime << endl;
		long long curTime = timestamp - sysTime * 1000; //system time is miniseconds decimal number, *1000 to get around the nanoseconds value
		camerasTimeStamp.push_back(curTime);
		cout << "camerasTimeStamp compared to the machine " << i << " " << curTime << endl;
	}

	//save values to find, the format is: cameraNo_timestamp_cameraname
	WriteCameraTimeStampToFile(cameraArray, camerasTimeStamp, imageFolder);
	return 1;
}

//This method will create the cameras array and preconfigure the cameras
void CaptureImages::InitCameraArray(CameraArray& cameraArray, int c_countOfImagesToGrab) {
	// Get the transport layer factory.
	CTlFactory& tlFactory = CTlFactory::GetInstance();
	// Get all attached devices and exit application if no device is found.
	DeviceInfoList_t devices;
	if (tlFactory.EnumerateDevices(devices) == 0) {
		throw RUNTIME_EXCEPTION("No camera present.");
	}
	// Create and attach all Pylon Devices.
	int noOfCamera = (int)devices.size();
	cameraArray.Initialize(noOfCamera);
	for (int i = 0; i < noOfCamera; i++)
	{
		cameraArray[i].Attach(tlFactory.CreateDevice(devices[i]));
		cameraArray[i].Open();
		cameraArray[i].EventSelector.SetValue(EventSelector_ExposureEnd);
		// Set buffer.
		cameraArray[i].MaxNumBuffer = (int)c_countOfImagesToGrab + 10; //set the buffer to maximum number of images grabbed

																	   //enable chunk mode to capture timestamp
		if (GenApi::IsWritable(cameraArray[i].ChunkModeActive))
		{
			cameraArray[i].ChunkModeActive.SetValue(true);
			cameraArray[i].ChunkEnable.SetValue(true);
			cameraArray[i].ChunkSelector.SetValue(ChunkSelector_Timestamp);
		}
		else
		{
			throw RUNTIME_EXCEPTION("The camera doesn’t support chunk features. ");
		}
	}
}


CaptureImages::CaptureImages() {

}

//call lock to acquire unique lock, so that camra cannot start to capture image until we unlock 
int CaptureImages::Lock() {
	boost::unique_lock< boost::shared_mutex > unlock(CaptureImages::_access);
	startThread = false;
	return 1;
}

int CaptureImages::Unlock() {
	boost::unique_lock< boost::shared_mutex > unlock(CaptureImages::_access);
	startThread = true;
	return 1;
}


bool CaptureImages::IsThreadRunning() {
	return isThreadRunning;
}
int CaptureImages::CaptureImage(int c_countOfImagesToGrab, string imageFolder) {

	// The exit code of the sample application.
	int exitCode = 1;

	// Before using any pylon methods, the pylon runtime must be initialized. 
	//Helper class to automagically call PylonInitialize and PylonTerminate in constructor and destructor
	PylonAutoInitTerm autoInitTerm;
	try
	{
		//preprocessing
		//configure that cameras, save timestamp to file
		CameraArray cameraArray;
		InitCameraArray(cameraArray, c_countOfImagesToGrab);
		SaveTimeStampToFile(cameraArray, imageFolder);

		//Lock so that no thread can capture the images
		Lock();
		//create thread for cameras to start the capturing process, one thread one cameras
		boost::thread_group threadGroup;
		for (int i = 0; i < cameraArray.GetSize(); i++) {
			threadGroup.add_thread(new boost::thread(&CaptureImages::SaveImage, (this), &cameraArray[i], Util::GetCameraID(&cameraArray[i]), c_countOfImagesToGrab, imageFolder, 0));
		}
		//Unlock, so all cameras can start to capture images at the same time
		Unlock();

		//wait until all threads are finished
		threadGroup.join_all();
	}
	catch (const GenericException &e)
	{
		throw RUNTIME_EXCEPTION(e.GetDescription());
	}
	return exitCode;
}

int CaptureImages::CaptureImage(Camera_t* camera, int c_countOfImagesToGrab, string imageFolder,unsigned int timeIntervalInSeconds){
	if (camera->IsGrabbing()) {
		throw RUNTIME_EXCEPTION("Grabbing method is called before");
	}

	//check if image folder is valid here, will throw exception if imageFolder is not a valid directory
	if (Util::CheckDir(imageFolder) == 1) {
		
		boost::thread th = boost::thread(&CaptureImages::SaveImage, this, camera, Util::GetCameraID(camera), c_countOfImagesToGrab, imageFolder, timeIntervalInSeconds);
	}

	return 1;

}


int CaptureImages::MainMethod() {
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
		CaptureImage(noOfImages, imageFolder);

	}
	else {
		throw RUNTIME_EXCEPTION("%s is not a directory\n", imageFolder);
	}

	return 1;
}










