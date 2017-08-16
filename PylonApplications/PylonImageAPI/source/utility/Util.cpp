

#ifndef UTIL_H_   // #include guards
#define UTIL_H_  
#include "utility/Util.h"
#endif // UTIL_H_  





const char* Util::CAMERA_TIME_STAMP_FILE_NAME = "camera_start_timestamp.txt";


string Util::ConvertIntToString(int value) {
	std::stringstream valueSS;
	valueSS << value;
	return valueSS.str();
}


int Util::ConvertStringToInt(string str) {
	return boost::lexical_cast<int>(str);
}

long long Util::ConvertStringToLL(string str) {
	return boost::lexical_cast<long long>(str);
}

int Util::CheckDir(string dir) {
	//check if image folder is valid here
	struct stat info;
	if (stat(dir.c_str(), &info) != 0) {
		throw RUNTIME_EXCEPTION("Cannot access %s\n", dir.c_str());
	}
	else if (info.st_mode & S_IFDIR) { // S_ISDIR() doesn't exist on my windows
		return 1;
	}
	else {
		throw RUNTIME_EXCEPTION("%s is not a directory\n", dir.c_str());
	}

	return 1;
}

string Util::GetCameraIDFromString(string fileName) {
	list_type list;
boost:split(list, fileName, boost::is_any_of("_"));
	return list[0];
}

int Util::GetImageFrameNoFromFileName(string fileName) {
	list_type list;
boost:split(list, fileName, boost::is_any_of("_"));
	return ConvertStringToInt(list[1]);
}

long long Util::GetCameraTSFromLine(string string) {
	list_type list;
boost:split(list, string, boost::is_any_of("_"));
	return ConvertStringToLL(list[1]);
}

long long Util::GetImageTimeStampFromFileName(string fileName) {
	list_type list;
boost:split(list, fileName, boost::is_any_of("_"));
	return ConvertStringToLL(list[2]);
}

int Util::CompareLens(string a, string b) {

	//compare cameraID and then frameNo to group all the camera with the same ID together
	if (strcmp(GetCameraIDFromString(a).c_str(),GetCameraIDFromString(b).c_str())==0) {
		return GetImageFrameNoFromFileName(a) < GetImageFrameNoFromFileName(b);
	}
	return GetCameraIDFromString(a) < GetCameraIDFromString(b);
}


//method to copy file 
bool Util::CopyImageFile(const char *SRC, const char* DEST)
{
	std::ifstream src(SRC, std::ios::binary);
	std::ofstream dest(DEST, std::ios::binary);
	if (!src)
		cerr << "Can't open INPUT file\n";
	if (!dest)
		cerr << "Can't open OUTPUT file\n";
	dest << src.rdbuf();
	return src && dest;
}

string Util::GetCameraID(Camera_t* camera) {
	return camera->GetDeviceInfo().GetDeviceGUID();
}

int Util::GetIndex(string& element, vector<string>& array) {
	return std::find(array.begin(), array.end(), element) - array.begin();
}
