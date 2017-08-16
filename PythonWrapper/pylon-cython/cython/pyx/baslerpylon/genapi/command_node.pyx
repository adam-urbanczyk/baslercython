from exception.custom_exception cimport raise_py_error
from baslerpylon.genapi.value_node cimport ValueNode
from genapi.cicommand cimport ICommand
from libcpp cimport bool

cdef class CommandNode: 
   
    @staticmethod
    cdef create(ICommand* icommand) :
        obj = CommandNode()
        obj.icommand = icommand
        return obj
		
    def execute(self, bool verify = True):
        self.icommand.Execute(verify)

    def is_done(self, bool verify = True):
        self.icommand.IsDone(verify)		
