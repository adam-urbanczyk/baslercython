from genapi.civalue cimport IValue

cdef extern from "genapi/ICategory.h" namespace 'GENAPI_NAMESPACE':
    cdef cppclass ICategory (IValue):
        pass