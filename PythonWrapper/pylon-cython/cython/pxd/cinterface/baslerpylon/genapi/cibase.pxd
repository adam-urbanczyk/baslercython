from exception.custom_exception cimport raise_py_error
from base.cgcbase cimport gcstring
from libcpp cimport bool
from libc.stdint cimport int64_t
from baslerpylon.genapi.enum cimport EAccessMode

cdef extern from "GenApi/IBase.h" namespace 'GENAPI_NAMESPACE':
    cdef cppclass IBase:
        EAccessMode GetAccessMode() except +raise_py_error
        # Virtual destructor enforcing virtual destructor on all derived classes
        void delete "~IBase"() except +raise_py_error
