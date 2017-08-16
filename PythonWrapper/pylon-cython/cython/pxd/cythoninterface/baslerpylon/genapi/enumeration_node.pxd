from genapi.cienumeration cimport IEnumeration
from exception.custom_exception cimport raise_py_error

cdef class EnumerationNode:
    cdef:
         IEnumeration* ienumeration

    @staticmethod
    cdef create(IEnumeration* ienumeration)