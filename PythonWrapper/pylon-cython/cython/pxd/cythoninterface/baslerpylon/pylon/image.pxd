from pylon.cimage cimport IImage


cdef class Image:
    cdef:
        IImage* iimage

    @staticmethod
    cdef create(IImage* iimage)


