from genapi.cinode cimport INode
from exception.custom_exception cimport raise_py_error

cdef class Node:
    cdef:
        INode* inode

    @staticmethod
    cdef create(INode* inode)