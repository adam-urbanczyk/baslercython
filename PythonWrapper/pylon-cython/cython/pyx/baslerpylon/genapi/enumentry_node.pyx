from exception.custom_exception cimport raise_py_error
from baslerpylon.genapi.value_node cimport ValueNode
from genapi.cienumeration cimport IEnumeration
from libcpp.string cimport string

cdef class EnumEntryNode:    
    @staticmethod
    cdef create(IEnumEntry* ienum_entry) :
        obj = EnumEntryNode()
        obj.ienum_entry = ienum_entry
        return obj

    property value:
        def __get__(self):
            return self.ienum_entry.GetValue()

    property numeric_value:
        def __get__(self):
            return self.ienum_entry.GetNumericValue()
            
    property self_clearing:
        def __get__(self):
            return self.ienum_entry.GetNumericValue()

    property symbolic:
        def __get__(self):
            return (<string>self.ienum_entry.GetSymbolic()).decode('ascii')

