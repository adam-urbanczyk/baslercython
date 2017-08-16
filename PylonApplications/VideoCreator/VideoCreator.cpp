// CreateVideo.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"


#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>

#include<stdio.h>
#include<dirent.h>
#include<iostream>

#include <pylon/PylonIncludes.h>

using namespace std;
using namespace cv;





// CreateVideo.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include "VideoCreator.h"

#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>

#include<stdio.h>


using namespace cv;



VideoCreator::VideoCreator() {

}

int VideoCreator::CompareLens(string a, string b) {

	if (a.size() == b.size()) {
		return a < b;
	}
	return (a.size() < b.size());
}

void VideoCreator::CreateVideo(string folderPathStr, int fps, boolean compressVideo) {
	DIR *pDIR;
	struct dirent *entry;


	const char* folderPath = folderPathStr.c_str();
	if (pDIR = opendir(folderPath)) {
		Mat image;
		Size size = Size(320, 240);

		//read images
		while (entry = readdir(pDIR)) {
			if (strcmp(entry->d_name, ".") != 0 && strcmp(entry->d_name, "..") != 0) {
				image = imread(folderPath + std::string("\\") + std::string(entry->d_name), CV_LOAD_IMAGE_COLOR);
				size = Size(image.size().width, image.size().height);
				break;
			}
		}

		int codec = -1;// CV_FOURCC('H', '2', '6', '4');
		if (compressVideo) {
			codec = CV_FOURCC('H', '2', '6', '4');
		}

		VideoWriter writer2;


		//initial video
		writer2.open("video.avi", codec, fps, size, true);
		if (writer2.isOpened()) {

			//cvWriteToAVI(writer, img);      // add the frame to the file
			std::cout << folderPath + std::string("\\") + std::string(entry->d_name) << "\n";
			writer2.write(image);

			vector<string> fileNames;

			//get file name and sort the file name
			while (entry = readdir(pDIR)) {
				if (strcmp(entry->d_name, ".") != 0 && strcmp(entry->d_name, "..") != 0) {
					fileNames.push_back(std::string(folderPath) + "\\" + std::string(entry->d_name));
				}
			}

			if (fileNames.size() > 0) {
				std::sort(fileNames.begin(), fileNames.end(),&VideoCreator::CompareLens);
			}

			//write to video
			for (int i = 0; i < fileNames.size(); i++) {
				image = imread(fileNames[i], CV_LOAD_IMAGE_COLOR);
				std::cout << fileNames[i] << "\n";
				writer2.write(image);
			}
			writer2.release();
		}
		else {
			closedir(pDIR);
			throw RUNTIME_EXCEPTION("cannot open video to write");
		}
	}
	else {
		throw RUNTIME_EXCEPTION("Invalid image path");
	}
}

int VideoCreator::MainMethod() {


	//get folder name
	char folderPath[1000];
	cout << "Please enter Image Path. e.g. C:\\pictures " << "\n";
	cin >> folderPath;
	cout << folderPath;
	int fps;
	cout << "Please enter video frame rate" << "\n";
	cin >> fps;

	CreateVideo(folderPath, fps);
	return 1;
}


int main(int argc, char* argv[]) {
	//get folder name
	char folderPath[1000];
	cout << "Please enter Image Path. e.g. C:\\pictures " << "\n";
	cin >> folderPath;
	cout << folderPath;
	int fps;
	cout << "Please enter video frame rate" << "\n";
	cin >> fps;

	VideoCreator cvideo;
	cvideo.CreateVideo(folderPath, fps);
	while (cin.get() != '\n');

	while (cin.get() != '\n');
	return 0;
}




