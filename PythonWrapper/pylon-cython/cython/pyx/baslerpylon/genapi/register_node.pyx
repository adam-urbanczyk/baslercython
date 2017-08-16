from exception.custom_exception cimport raise_py_error
from genapi.ciregister cimport IRegister

cdef class RegisterNode :
    @staticmethod
    cdef create(IRegister* iregister):
        obj = RegisterNode()
        obj.iregister = iregister
        return obj

    def get_value(self, *pBuffer, length, verify = False, ignore_cache = False):
            return self.iregister.Get(pBuffer, length, verify, ignore_cache)
    
    def set_value(self, *pBuffer, length, verify = True):
            self.iregister.Set(pBuffer, length, verify)
			
    property length:
        def __get__(self):
            return self.iregister.GetLength()	

    def get_length(self):
            return self.iregister.GetLength()	
			

    property address:
        def __get__(self):
            return self.iregister.GetLength()	
			
    def get_address(self):
            return self.iregister.GetLength()	