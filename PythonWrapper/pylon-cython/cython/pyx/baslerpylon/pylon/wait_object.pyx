from pylon.cwait_object cimport WaitObject

cdef class PyWaitObject:
    @staticmethod  
    cdef create(WaitObject* wait_object):
        obj = PyWaitObject()
        obj.wait_object = wait_object
        return obj


    # /// Suspend calling thread for specified time.
    # /**
    # \param ms wait time in ms
    # */
    @staticmethod
    def  sleep(long ms):
        WaitObject.Sleep(ms)

    # /// Wait for the object to be signaled
    # /**
    # \param timeout timeout in ms
    # \return false when the timeout has been expired, true when the waiting was successful before
    # the timeout has been expired.
    # */
    def wait(self, int timeout):
        return self.wait_object.Wait(timeout)