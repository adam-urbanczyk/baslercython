

#include <python.h>
#include <exception>
#include <string>
#include <pylon/PylonIncludes.h>

#include "dbghelp.h"

using namespace std;

#define TRACE_MAX_STACK_FRAMES 1024
#define TRACE_MAX_FUNCTION_NAME_LENGTH 1024

int printStackTrace()
{
	void *stack[TRACE_MAX_STACK_FRAMES];
	HANDLE process = GetCurrentProcess();
	SymInitialize(process, NULL, TRUE);
	WORD numberOfFrames = CaptureStackBackTrace(0, TRACE_MAX_STACK_FRAMES, stack, NULL);
	SYMBOL_INFO *symbol = (SYMBOL_INFO *)malloc(sizeof(SYMBOL_INFO) + (TRACE_MAX_FUNCTION_NAME_LENGTH - 1) * sizeof(TCHAR));
	symbol->MaxNameLen = TRACE_MAX_FUNCTION_NAME_LENGTH;
	symbol->SizeOfStruct = sizeof(SYMBOL_INFO);
	DWORD displacement;
	IMAGEHLP_LINE64 *line = (IMAGEHLP_LINE64 *)malloc(sizeof(IMAGEHLP_LINE64));
	line->SizeOfStruct = sizeof(IMAGEHLP_LINE64);
	for (int i = 0; i < numberOfFrames; i++)
	{
		DWORD64 address = (DWORD64)(stack[i]);
		SymFromAddr(process, address, NULL, symbol);
		if (SymGetLineFromAddr64(process, address, &displacement, line))
		{
			printf("\tat %s in %s: line: %lu: address: 0x%0X\n", symbol->Name, line->FileName, line->LineNumber, symbol->Address);
		}
		else
		{
			printf("\terror code %lu.\n", GetLastError());
			printf("\tat %s, address 0x%0X.\n", symbol->Name, symbol->Address);
		}
	}
	return 0;
}

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
		try {
			msg += " .";
			msg += e.GetSourceLine();
		}
		catch (std::exception e) {
			//ignore
		}
		PyErr_SetString(PyExc_RuntimeError, msg.c_str());
	}
	catch (const std::exception& e) {
		PyErr_SetString(PyExc_RuntimeError,e.what());
	}
}