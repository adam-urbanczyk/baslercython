from exception.custom_exception cimport raise_py_error

from base.cgcbase cimport gcstring
from libcpp cimport bool
from libc.stdint cimport int64_t, uint64_t
from cinode cimport NodeList_t
from cinode cimport INode
from genapi.ciport cimport IPort
from genapi.csynch cimport CLock

cdef extern from "GenApi/INodeMap.h" namespace 'GENAPI_NAMESPACE':
        cdef cppclass INodeMap:
            #Retrieves all nodes in the node map
            void GetNodes(NodeList_t &Nodes) except +raise_py_error
    
            #Retrieves the node from the central map by Name
            INode* GetNode(gcstring& Name) except +raise_py_error
    
            #Invalidates all nodes
            void InvalidateNodes() except +raise_py_error
    
            #Connects a port to a port node with given name
            bool Connect( IPort* pPort, gcstring& PortName) except +raise_py_error
    
            #Connects a port to the standard port "Device"
            bool Connect( IPort* pPort) except +raise_py_error
    
            #Get device name
            # /*! The device name identifies a device instance, e.g. for debuggin purposes.
            # The default ist "Device". */
            GetDeviceName() except +raise_py_error
    
            #Fires nodes which have a polling time
            void Poll( int64_t ElapsedTime ) except +raise_py_error
    
            #Returns the lock which guards the node map
            CLock& GetLock() except +raise_py_error

            #Get the number of nodes in the map
            uint64_t GetNumNodes() except +raise_py_error
