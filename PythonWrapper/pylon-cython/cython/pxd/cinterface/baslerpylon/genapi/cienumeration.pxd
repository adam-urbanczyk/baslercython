from exception.custom_exception cimport raise_py_error
from libcpp cimport bool
from libc.stdint cimport int64_t
from base.cgcbase cimport gcstring
from genapi.civalue cimport IValue
from genapi.cinode cimport NodeList_t
from genapi.cienumeration cimport IEnumeration
from genapi.cienumentry cimport IEnumEntry
from pylon.ctype_mappings cimport String_t, StringList_t


cdef extern from "genapi/IEnumeration.h" namespace 'GENAPI_NAMESPACE':
    cdef cppclass IEnumeration (IValue):
        # Get list of symbolic Values
        void GetSymbolics(StringList_t & Symbolics) except +raise_py_error
        # Get list of entry nodes
        void GetEntries(NodeList_t & Entries) except +raise_py_error

        # Set string node value
        IEnumeration& SetValue "operator="(gcstring& ValueStr) except +raise_py_error
        # Set integer node value
        # /*!
        # \param Value The value to set
        # \param Verify Enables AccessMode and Range verification (default = true)
        # */
        void SetIntValue(int64_t Value, bool Verify) except +raise_py_error
        void SetIntValue(int64_t Value) except +raise_py_error
        # Get string node value
        gcstring GetString "operator*"() except +raise_py_error
        # Get integer node value
        # /*!
        # \param Verify Enables Range verification (default = false). The AccessMode is always checked
        # \param IgnoreCache If true the value is read ignoring any caches (default = false)
        # \return The value read
        # */
        int64_t GetIntValue(bool Verify, bool IgnoreCache) except +raise_py_error
        int64_t GetIntValue(bool IgnoreCache) except +raise_py_error
        int64_t GetIntValue(bool Verify) except +raise_py_error
        int64_t GetIntValue() except +raise_py_error

        # Get an entry node by name
        IEnumEntry *GetEntryByName(gcstring& Symbolic) except +raise_py_error
        # Get an entry node by its IntValue
        IEnumEntry *GetEntry(int64_t IntValue) except +raise_py_error
        IEnumEntry *GetCurrentEntry(bool Verify, bool IgnoreCache) except +raise_py_error
        IEnumEntry *GetCurrentEntry(bool Verify) except +raise_py_error
        IEnumEntry *GetCurrentEntry(bool IgnoreCache) except +raise_py_error

        # Get the current entry
        IEnumEntry *GetCurrentEntry() except +raise_py_error


