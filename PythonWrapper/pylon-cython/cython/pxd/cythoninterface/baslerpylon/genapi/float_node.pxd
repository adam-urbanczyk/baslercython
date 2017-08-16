from exception.custom_exception cimport raise_py_error
from genapi.cifloat cimport IFloat

cdef class FloatNode :
    cdef:
        IFloat* ifloat

    @staticmethod
    cdef create(IFloat* ifloat)