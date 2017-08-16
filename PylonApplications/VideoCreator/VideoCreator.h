#include "stdafx.h"

class VideoCreator {
private:
	static int CompareLens(string a, string b);
public:
	VideoCreator();
	void CreateVideo(string folderPathStr, int fps, boolean compressVideo = true);
	int MainMethod();
};