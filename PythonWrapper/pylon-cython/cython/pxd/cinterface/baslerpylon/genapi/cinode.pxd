from exception.custom_exception cimport raise_py_error
from base.cgcbase cimport gcstring
from libcpp cimport bool
from genapi.cibase cimport IBase
from baslerpylon.genapi.enum cimport ENameSpace, EVisibility, EYesNo, ECachingMode, ELinkType, EInterfaceType, EAccessMode
from genapi.cnode_callback cimport CNodeCallback
from genapi.cinode_map cimport INodeMap
from base.cgcbase cimport gcstring_vector
from libc.stdint cimport int64_t, intptr_t

cdef extern from "GenApi/INode.h" namespace 'GENAPI_NAMESPACE':


        cdef cppclass NodeList_t:
            cppclass iterator:
                INode* operator*() except +raise_py_error
                iterator operator++() except +raise_py_error
                bint operator==(iterator) except +raise_py_error
                bint operator!=(iterator) except +raise_py_error
            NodeList_t() except +raise_py_error
            iterator begin() except +raise_py_error
            iterator end() except +raise_py_error

        ctypedef intptr_t CallbackHandleType

        cdef cppclass INode(IBase):
            # Get node name
            gcstring GetName(bool FullQualified) except +raise_py_error
            gcstring GetName() except +raise_py_error

            # Get name space
            ENameSpace GetNameSpace() except +raise_py_error
    
            # Get the recommended visibility of the node
            EVisibility GetVisibility()   except +raise_py_error
    
            # Indicates that the node's value may have changed.
            # Fires the callback on this and all dependent nodes */
            void InvalidateNode() except +raise_py_error
    
            # Is the node value cachable
            bool IsCachable() except +raise_py_error
    
            # True if the AccessMode can be cached
            EYesNo IsAccessModeCacheable() except +raise_py_error
    
            # Get Caching Mode
            ECachingMode GetCachingMode() except +raise_py_error
    
            # recommended polling time (for not cachable nodes)
            int64_t GetPollingTime() except +raise_py_error
    
            # Get a short description of the node
            gcstring GetToolTip() except +raise_py_error
    
            # Get a long description of the node
            gcstring GetDescription() except +raise_py_error
    
            # Get a name string for display
            gcstring GetDisplayName() except +raise_py_error
    
            # Get a name of the device
            gcstring GetDeviceName() except +raise_py_error
    
            #
            # \brief Get all nodes this node directly depends on.
            # \param[out] Children List of children nodes
            # \param LinkType The link type
            # */
            void GetChildren(NodeList_t &Children, ELinkType LinkType) except +raise_py_error
    
            #
            # \brief Gets all nodes this node is directly depending on
            # \param[out] Parents List of parent nodes
            # */
            void GetParents(NodeList_t &Parents) except +raise_py_error
    
            # Register change callback
            # Takes ownership of the CNodeCallback object */
            CallbackHandleType RegisterCallback( CNodeCallback *pCallback ) except +raise_py_error
    
            # De register change callback
            # Destroys CNodeCallback object
            # \return true if the callback handle was valid
            # */
            bool DeregisterCallback( CallbackHandleType hCallback ) except +raise_py_error
    
            # Retrieves the central node map
            INodeMap* GetNodeMap() except +raise_py_error
    
            # Get the EventId of the node
            gcstring GetEventID() except +raise_py_error
    
            # True if the node is streamable
            bool IsStreamable() except +raise_py_error
    
            # Returns a list of the names all properties set during initialization
            void GetPropertyNames(gcstring_vector &PropertyNames) except +raise_py_error
    
            # Retrieves a property plus an additional attribute by name
            # If a property has multiple values/attribute they come with Tabs as delimiters */
            bool GetProperty(const gcstring& PropertyName, gcstring& ValueStr, gcstring& AttributeStr) except +raise_py_error
    
            # Imposes an access mode to the natural access mode of the node
            void ImposeAccessMode(EAccessMode ImposedAccessMode) except +raise_py_error

            # Imposes a visibility  to the natural visibility of the node
            void ImposeVisibility(EVisibility ImposedVisibility) except +raise_py_error
    
            # Retrieves the a node which describes the same feature in a different way
            INode* GetAlias() except +raise_py_error
    
            # Retrieves the a node which describes the same feature so that it can be casted
            INode* GetCastAlias() except +raise_py_error
    
            # Gets a URL pointing to the documentation of that feature
            gcstring GetDocuURL() except +raise_py_error
    
            # True if the node should not be used any more
            bool IsDeprecated() except +raise_py_error
    
            # Get the type of the main interface of a node
            EInterfaceType GetPrincipalInterfaceType() except +raise_py_error
    
            # True if the node can be reached via category nodes from a category node named "Root"
            bool IsFeature() except +raise_py_error
