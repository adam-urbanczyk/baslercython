from exception.custom_exception cimport raise_py_error
from libcpp cimport bool
from libc.stdint cimport int64_t
from base.cgcbase cimport gcstring
from genapi.civalue cimport IValue


cdef extern from "genapi/IEnumEntry.h" namespace 'GENAPI_NAMESPACE':
    cdef cppclass IEnumEntry (IValue):
        # Get numeric enum value
        int64_t GetValue() except +raise_py_error
        # Get double number associated with the entry
        double GetNumericValue() except +raise_py_error
        # Indicates if the corresponding EnumEntry is self clearing
        bool IsSelfClearing() except +raise_py_error
        # Get symbolic enum value
        gcstring GetSymbolic() except +raise_py_error

