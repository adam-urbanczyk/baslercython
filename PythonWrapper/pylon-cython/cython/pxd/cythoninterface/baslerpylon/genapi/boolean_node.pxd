from genapi.ciboolean cimport IBoolean
from exception.custom_exception cimport raise_py_error

cdef class BooleanNode:
    cdef:
        IBoolean* iboolean

    @staticmethod
    cdef create(IBoolean* iboolean)