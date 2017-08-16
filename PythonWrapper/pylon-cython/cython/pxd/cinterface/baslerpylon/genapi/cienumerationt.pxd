from exception.custom_exception cimport raise_py_error
from libcpp cimport bool
from libc.stdint cimport int64_t
from base.cgcbase cimport gcstring
from genapi.cienumentry cimport IEnumEntry
from genapi.cienumeration cimport IEnumeration

cdef extern from "genapi/IEnumerationT.h" namespace 'GENAPI_NAMESPACE':
    cdef cppclass IEnumerationT [EnumT] (IEnumeration):
        # Set node value
        # /*!
        # \param Value The value to set
        # \param Verify Enables AccessMode and Range verification (default = true)
        # */
        void SetValue(EnumT Value, bool Verify) except +raise_py_error
        void SetValue(EnumT Value) except +raise_py_error
        # Get node value
        # /*!
        # \param Verify Enables Range verification (default = false). The AccessMode is always checked
        # \param IgnoreCache If true the value is read ignoring any caches (default = false)
        # \return The value read
        # */
        EnumT GetValue(bool Verify, bool IgnoreCache) except +raise_py_error
        EnumT GetValue(bool Verify) except +raise_py_error
        EnumT GetValue() except +raise_py_error
        EnumT GetValue() except +raise_py_error
        # Set node value
        # /*! Note : the operator= is not inherited thus the operator= versions
        # from IEnumeration must be implemented again */
        IEnumeration& SetValue "operator="(const gcstring& ValueStr) except +raise_py_error
        # returns the EnumEntry object belonging to the Value
        IEnumEntry *GetEntry(EnumT Value) except +raise_py_error
        # Get the current entry
        IEnumEntry *GetCurrentEntry(bool Verify, bool IgnoreCache) except +raise_py_error
        IEnumEntry *GetCurrentEntry(bool IgnoreCache) except +raise_py_error
        IEnumEntry *GetCurrentEntry(bool Verify) except +raise_py_error
        IEnumEntry *GetCurrentEntry() except +raise_py_error
     
