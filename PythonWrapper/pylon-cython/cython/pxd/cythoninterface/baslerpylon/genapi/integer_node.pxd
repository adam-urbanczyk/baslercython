from genapi.ciinteger cimport IInteger
from exception.custom_exception cimport raise_py_error

cdef class IntegerNode :
    cdef:
        IInteger* iinteger

    @staticmethod
    cdef create(IInteger* iinteger)