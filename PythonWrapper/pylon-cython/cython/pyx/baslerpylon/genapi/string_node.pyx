from exception.custom_exception cimport raise_py_error
from libcpp cimport bool
from base.cgcbase cimport gcstring
from libcpp.string cimport string
from genapi.cistring cimport IString

cdef class StringNode :
    @staticmethod
    cdef create(IString* istring) :
        obj = StringNode()
        obj.istring = istring
        return obj

    def get_value(self,bool verify = False, bool ignore_cache = False):
            return (<string>self.istring.GetValue(verify,ignore_cache)).decode('ascii')
    
    def set_value(self, string value, bool verify = True):
        cdef bytes value_bytes = value.encode()
        self.istring.SetValue(gcstring(value_bytes), verify)
            
    property max_length:
        def __get__(self):
            return self.istring.GetMaxLength()
	
    def get_max_length(self):
            return self.istring.GetMaxLength()
