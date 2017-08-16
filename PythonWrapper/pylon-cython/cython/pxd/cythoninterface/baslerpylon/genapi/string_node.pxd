from genapi.cistring cimport IString
from exception.custom_exception cimport raise_py_error

cdef class StringNode:
    cdef:
        IString* istring

    @staticmethod
    cdef create(IString* istring)