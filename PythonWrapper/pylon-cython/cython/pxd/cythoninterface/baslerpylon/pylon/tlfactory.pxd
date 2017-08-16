from pylon.ctlfactory cimport CTlFactory

cdef class TlFactory:
    cdef:
        CTlFactory* ctlFactory

