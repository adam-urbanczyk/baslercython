from libcpp cimport bool
from libcpp.string cimport string
from genapi.cinode cimport INode
from exception.custom_exception cimport raise_py_error

cdef class Node:    
    @staticmethod
    cdef create(INode* inode) :
        obj = Node()
        obj.inode = inode
        return obj

    # def get_name(self, bool full_qualified = False):
    #         return (<string>self.inode.GetName(full_qualified)).decode('ascii')
    #
    # property name_space:
    #     def __get__(self):
    #         return self.inode.GetNameSpace()
    #
    # property cachable:
    #     def __get__(self):
    #         return self.inode.IsCachable()
    #
    # property polling_time:
    #     def __get__(self):
    #         return self.inode.GetPollingTime()
    #
    # property tool_tip:
    #     def __get__(self):
    #         return (<string>self.inode.GetToolTip()).decode('ascii')
    #
    # property description:
    #     def __get__(self):
    #         return (<string>self.inode.GetDescription()).decode('ascii')
    #
    # property display_name:
    #     def __get__(self):
    #         return (<string>self.inode.GetDisplayName()).decode('ascii')
    #
    # property feature:
    #     def __get__(self):
    #         return self.inode.IsFeature()
    #
    # #property value:
    # #    def __get__(self):
    # #        return (<string>self.inode.GetValue()).decode('ascii')
    #
    # property streamable:
    #     def __get__(self):
    #         return self.inode.IsStreamable()
    #
    # property alias:
    #     def __get__(self):
    #         return Node.create((self.inode.GetAlias()))
    #
    # property cast_alias:
    #     def __get__(self):
    #         return Node.create((self.inode.GetCastAlias()))
    #
    # property deprecated:
    #     def __get__(self):
    #         return self.inode.IsDeprecated()
    #
    # def invalidate_node(self):
    #     self.inode.InvalidateNode()
    #
