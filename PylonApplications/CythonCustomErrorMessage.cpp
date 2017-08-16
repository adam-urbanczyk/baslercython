

#include <python.h>
#include <exception>
#include <string>
#include <pylon/PylonIncludes.h>



using namespace std;


void raise_py_error()
{
	try {
		//printStackTrace();
		throw;
	}
	catch (const GenericException &e) {
		string msg = e.GetSourceFileName();
		msg += " .";
		msg += e.GetDescription();
		PyErr_SetString(PyExc_RuntimeError, msg.c_str());
	}
	catch (const std::exception& e) {
		PyErr_SetString(PyExc_RuntimeError,e.what());
	}
}