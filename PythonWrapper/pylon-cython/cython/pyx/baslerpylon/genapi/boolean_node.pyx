from exception.custom_exception cimport raise_py_error
from libcpp cimport bool
from cython.operator cimport dereference as deref, preincrement as inc
from baslerpylon.genapi.value_node cimport ValueNode
from genapi.ciboolean cimport IBoolean

cdef class BooleanNode :
    @staticmethod
    cdef create(IBoolean* iboolean):
        obj = BooleanNode()
        obj.iboolean = iboolean
        return obj

    property value:
        def __get__(self):
            return (self.iboolean).GetValue()
        def __set__(self, bool value):
            (self.iboolean).SetValue(value)

    def get_value(self):
            return (self.iboolean).GetValue()
	
    def set_value(self, value):
            (self.iboolean).SetValue(value)