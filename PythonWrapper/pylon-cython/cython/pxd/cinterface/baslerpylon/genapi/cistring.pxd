from exception.custom_exception cimport raise_py_error

from libcpp cimport bool
from libc.stdint cimport int64_t, uint32_t
from base.cgcbase cimport gcstring
from genapi.civalue cimport IValue

cdef extern from "genapi/IString.h" namespace 'GENAPI_NAMESPACE':
    cdef cppclass IString (IValue):
        # # Set node value
        # /*!
        # \param Value The value to set
        # \param Verify Enables AccessMode and Range verification (default = true)
        # */
        void SetValue(const gcstring& Value, bool Verify)  except +raise_py_error
        void SetValue(const gcstring& Value)  except +raise_py_error


        # Get node value
        # /*!
        # \param Verify Enables Range verification (default = false). The AccessMode is always checked
        # \param IgnoreCache If true the value is read ignoring any caches (default = false)
        # \return The value read
        # */
        gcstring GetValue(bool Verify, bool IgnoreCache)  except +raise_py_error
        gcstring GetValue(bool IgnoreCache)  except +raise_py_error
        gcstring GetValue(bool Verify)  except +raise_py_error
        gcstring GetValue()  except +raise_py_error

        # Retrieves the maximum length of the string in bytes
        int64_t GetMaxLength()  except +raise_py_error
