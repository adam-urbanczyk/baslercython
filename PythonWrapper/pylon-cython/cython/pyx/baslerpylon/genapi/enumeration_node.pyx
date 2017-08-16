from exception.custom_exception cimport raise_py_error
from baslerpylon.genapi.enumentry_node cimport EnumEntryNode
from libcpp.string cimport string
from genapi.cienumeration cimport IEnumeration
from base.cgcbase cimport gcstring
from libcpp cimport bool

cdef class EnumerationNode:
    @staticmethod
    cdef create(IEnumeration* ienumeration):
        obj = EnumerationNode()
        obj.ienumeration = ienumeration
        return obj

    #property symbolics:
    #    def __get__(self, StringList_t & Symbolics):
    #        return self.ienumeration.GetSymbolics(Symbolics)
            
    #def get_entries(self, NodeList_t & Entries):
    #    return self.ienumeration.GetEntries(Entries)
            
    #def set_entries(self, int64_t value, bool verify = True):
    #    return self.ienumeration.SetIntValue(value, verify)
    
    def get_int_value(self, bool verify = False, bool ignore_cache = False):
        return self.ienumeration.GetIntValue(verify, ignore_cache)
    
    def get_entry(self, string symbolic):
        cdef bytes btes_symbolic = symbolic.encode()
        return EnumEntryNode.create(self.ienumeration.GetEntryByName(gcstring(btes_symbolic)))
    
    def get_current_entry(self, bool verify = False, bool ignore_cache = False):
        return EnumEntryNode.create(self.ienumeration.GetCurrentEntry(verify,ignore_cache))
    