from libcpp cimport bool
from exception.custom_exception cimport raise_py_error
from genapi.civalue cimport IValue
from genapi.ciboolean cimport IBoolean
from genapi.cifloat cimport IFloat
from genapi.ciinteger cimport IInteger
from genapi.cinode_map cimport INodeMap
from genapi.cinode cimport INode
from genapi.ciregister cimport IRegister
from genapi.cicategory cimport ICategory
from genapi.cicommand cimport ICommand
from genapi.cistring cimport IString
from genapi.cienumeration cimport IEnumeration
from genapi.cienumerationt cimport IEnumerationT

cdef extern from "pylon/PylonIncludes.h" namespace 'Pylon':
    # Top level init functions
    void PylonInitialize()  except +raise_py_error
    void PylonTerminate() except +raise_py_error
	

cdef extern from *:
    IValue* dynamic_cast_ivalue_ptr "dynamic_cast<GenApi::IValue*>" (INode*) except +raise_py_error
    IBoolean* dynamic_cast_iboolean_ptr "dynamic_cast<GenApi::IBoolean*>" (INode*) except +raise_py_error
    IInteger* dynamic_cast_iinteger_ptr "dynamic_cast<GenApi::IInteger*>" (INode*) except +raise_py_error
    IFloat* dynamic_cast_ifloat_ptr "dynamic_cast<GenApi::IFloat*>" (INode*) except +raise_py_error
    INodeMap* dynamic_cast_inodemap_ptr "dynamic_cast<GenApi::INodeMap*>" (INode*) except +raise_py_error
    INodeMap* dynamic_cast_inodemap_ptr "dynamic_cast<GenApi::INodeMap*>" (INode*) except +raise_py_error
    ICategory* dynamic_cast_icategory_ptr "dynamic_cast<GenApi::ICategory*>" (INode*) except +raise_py_error
    IRegister* dynamic_cast_iregister_ptr "dynamic_cast<GenApi::IRegister*>" (INode*) except +raise_py_error
    ICommand* dynamic_cast_icommand_ptr "dynamic_cast<GenApi::ICommand*>" (INode*) except +raise_py_error
    IString* dynamic_cast_istring_ptr "dynamic_cast<GenApi::IString*>" (INode*) except +raise_py_error
    IEnumeration* dynamic_cast_ienumeration_ptr "dynamic_cast<GenApi::IEnumeration*>" (INode*) except +raise_py_error
    IEnumerationT* dynamic_cast_ienumerationt_ptr "dynamic_cast<GenApi::IEnumerationT*>" (INode*) except +raise_py_error
    IEnumerationT* dynamic_cast_ienumerationt_ptr "dynamic_cast<GenApi::IEnumerationT*>" (INode*) except +raise_py_error

    bool node_is_readable "GenApi::IsReadable" (INode*) except +raise_py_error
    bool node_is_writable "GenApi::IsWritable" (INode*) except +raise_py_error
    bool node_is_implemented "GenApi::IsImplemented" (INode*) except +raise_py_error
    bool node_is_available "GenApi::IsAvailable" (INode*) except +raise_py_error
	

	

	
