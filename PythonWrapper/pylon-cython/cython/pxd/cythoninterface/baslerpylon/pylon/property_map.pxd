from genapi.cinode_map cimport INodeMap
from genapi.cinode cimport INode

cdef extern from "<vector>" namespace "std":
    cdef cppclass vector[T]:
        cppclass iterator:
            T operator*()
            iterator operator++()
            bint operator==(iterator)
            bint operator!=(iterator)
        vector()
        void push_back(T&)
        T& operator[](int)
        T& at(int)
        iterator begin()
        iterator end()



cdef class PropertyMap:
    cdef:
        INodeMap* map

    cdef vector[INodeMap*] maps

    @staticmethod
    cdef create_maps(vector[INodeMap*] map)

    @staticmethod
    cdef create(INodeMap* maps)

    cdef INode* get_inode(self, basestring key)