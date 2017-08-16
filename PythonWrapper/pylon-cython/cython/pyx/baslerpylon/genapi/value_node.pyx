from exception.custom_exception cimport raise_py_error
from libcpp.string cimport string
from baslerpylon.genapi.node cimport Node
from genapi.civalue cimport IValue
from base.cgcbase cimport gcstring

cdef class ValueNode:    
    @staticmethod
    cdef create(IValue* ivalue):
        obj = ValueNode()
        obj.ivalue = ivalue
        return obj

    #property node:
    #    def __get__(self):
    #        return Node.create(self.ivalue.GetNode())


    #property value_catche_valid:
    #    def __get__(self):
    #       return self.ivalue.IsValueCacheValid()
            
            
    def to_string(self,verify = False, ignore_cache = False):
        return (<string>self.ivalue.ToString(verify,ignore_cache)).decode('ascii')

    def from_string(self,value, verify = True):
        cdef bytes value_bytes = value.encode()
        self.ivalue.FromString(gcstring(value_bytes),verify)
