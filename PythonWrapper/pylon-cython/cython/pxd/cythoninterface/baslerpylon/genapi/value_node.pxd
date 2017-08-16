from genapi.civalue cimport IValue
from exception.custom_exception cimport raise_py_error

cdef class ValueNode:
    cdef:
        IValue* ivalue

    @staticmethod
    cdef create(IValue* ivalue)