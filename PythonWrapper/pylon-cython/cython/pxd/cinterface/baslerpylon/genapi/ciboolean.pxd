from exception.custom_exception cimport raise_py_error
from libcpp cimport bool
from genapi.civalue cimport IValue

cdef extern from "genapi/IBoolean.h" namespace 'GENAPI_NAMESPACE':
    cdef cppclass IBoolean (IValue):
        #  # Set node value
        # /*!
        # \param Value The value to set
        # \param Verify Enables AccessMode and Range verification (default = true)
        # */
        void SetValue(bool Value, bool Verify) except +raise_py_error
        void SetValue(bool Value) except +raise_py_error

        # Get node value
        # /*!
        # \param Verify Enables Range verification (default = false). The AccessMode is always checked
        # \param IgnoreCache If true the value is read ignoring any caches (default = false)
        # \return The value read
        # */
        bool GetValue(bool Verify, bool IgnoreCache) except +raise_py_error
        bool GetValue(bool IgnoreCache) except +raise_py_error
        bool GetValue(bool Verify) except +raise_py_error
        bool GetValue() except +raise_py_error


