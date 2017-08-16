from exception.custom_exception cimport raise_py_error
from base.cgcbase cimport gcstring
from libcpp cimport bool
from genapi.cinode cimport INode

from genapi.cibase cimport IBase

cdef extern from "GenApi/IValue.h" namespace 'GENAPI_NAMESPACE':
    cdef cppclass IValue(IBase):
         # Get the INode interface of the node
        INode* GetNode() except +raise_py_error

        # Get content of the node as string
        # /*!
        # \param Verify Enables Range verification (default = false). The AccessMode is always checked
        # \param IgnoreCache If true the value is read ignoring any caches (default = false)
        # \return The value read
        # */
        gcstring ToString(bool Verify, bool IgnoreCache) except +raise_py_error
        gcstring ToString(bool Verify) except +raise_py_error
        gcstring ToString(bool IgnoreCache) except +raise_py_error
        gcstring ToString() except +raise_py_error
        # Set content of the node as string
        # /*!
        # \param ValueStr The value to set
        # \param Verify Enables AccessMode and Range verification (default = true)
        # */
        void FromString(const gcstring& ValueStr, bool Verify) except +raise_py_error
        void FromString(const gcstring& ValueStr) except +raise_py_error

        # Checks if the value comes from cache or is requested from another node
        bool IsValueCacheValid() except +raise_py_error

