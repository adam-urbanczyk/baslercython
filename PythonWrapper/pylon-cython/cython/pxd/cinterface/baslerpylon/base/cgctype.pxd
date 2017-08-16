from libc.stdint cimport  uint64_t

cdef extern from "Base/GCTypes.h":
    ctypedef uint64_t size_t;

