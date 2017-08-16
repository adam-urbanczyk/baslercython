from genapi.cienumentry cimport IEnumEntry
from exception.custom_exception cimport raise_py_error

cdef class EnumEntryNode:
    cdef:
        IEnumEntry* ienum_entry
    @staticmethod
    cdef create(IEnumEntry* ienum_entry)