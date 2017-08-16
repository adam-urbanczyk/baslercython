from exception.custom_exception cimport raise_py_error
from genapi.ciregister cimport IRegister

cdef class RegisterNode:
    cdef:
        IRegister* iregister

    @staticmethod
    cdef create(IRegister* iregister)