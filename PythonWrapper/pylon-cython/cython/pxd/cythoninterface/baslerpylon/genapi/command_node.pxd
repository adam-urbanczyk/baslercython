from genapi.cicommand cimport ICommand
from exception.custom_exception cimport raise_py_error

cdef class CommandNode:
    cdef:
        ICommand* icommand
    @staticmethod
    cdef create(ICommand* icommand)