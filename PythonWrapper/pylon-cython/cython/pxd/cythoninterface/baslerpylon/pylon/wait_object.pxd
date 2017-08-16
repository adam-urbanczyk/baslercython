from pylon.cwait_object cimport WaitObject


cdef class PyWaitObject:
    cdef:
        WaitObject* wait_object

    @staticmethod
    cdef create(WaitObject* wait_object)
