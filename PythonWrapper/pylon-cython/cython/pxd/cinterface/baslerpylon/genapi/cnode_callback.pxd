from exception.custom_exception cimport raise_py_error
from genapi.cinode cimport INode
from baslerpylon.genapi.enum cimport ECallbackType

cdef extern from "GenApi/NodeCallBack.h" namespace 'GENAPI_NAMESPACE':
    cdef cppclass CNodeCallback:
        CNodeCallback(INode *pNode, ECallbackType CallbackType )

        void delete "~CNodeCallback"() except +raise_py_error


        #fires the callback if the type is right
        void operator()( ECallbackType CallbackType ) except +raise_py_error

        #destroys the object
        void Destroy() except +raise_py_error

        #returns the node the callback is registered to
        INode* GetNode()