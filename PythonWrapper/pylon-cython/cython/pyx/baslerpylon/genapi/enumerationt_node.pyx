from exception.custom_exception cimport raise_py_error
from baslerpylon.genapi.enumeration_node cimport EnumerationNode
from genapi.cienumerationt cimport IEnumerationT
from libcpp cimport bool

cdef class EnumerationTNode (EnumerationNode):
    @staticmethod
    cdef create(IEnumerationT enumerationT):
        obj = EnumerationTNode()
        obj.enumerationT = enumerationT
        return obj

    property value:
        def __set__(self, EnumT value, bool verify = True ):
            return enumerationT.SetValue(value, verify)
        
        def __get__(self, bool verify = False, bool ignore_cache = False):
            return enumerationT.GetValue(verify,ignore_cache)
            
    property entry:
        def __get__(self,EnumT value):
            return enumerationT.GetEntry(value)        
    
    property current_entry:
        def __get__(self,bool verify = False, bool ignore_cache = False):
            return ENumEntryNode.create(enumerationT.GetCurrentEntry(verify,ignore_cache))        
    