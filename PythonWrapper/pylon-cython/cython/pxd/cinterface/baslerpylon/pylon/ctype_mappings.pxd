from exception.custom_exception cimport raise_py_error
from base.cgcbase cimport gcstring, gcstring_vector

cdef extern from "pylon/TypeMappings.h" namespace 'Pylon':
    ctypedef gcstring String_t
    ctypedef gcstring_vector StringList_t