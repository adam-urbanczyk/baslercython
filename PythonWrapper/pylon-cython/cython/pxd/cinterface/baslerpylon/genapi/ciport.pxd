from exception.custom_exception cimport raise_py_error
from libc.stdint cimport int64_t
from genapi.cibase cimport IBase

cdef extern from "GenApi/IPort.h" namespace 'GENAPI_NAMESPACE':
        cdef cppclass IPort(IBase):
            #Reads a chunk of bytes from the port
            void Read(void *pBuffer, int64_t Address, int64_t Length) except +raise_py_error

            #Writes a chunk of bytes to the port
            void Write(const void *pBuffer, int64_t Address, int64_t Length) except +raise_py_error