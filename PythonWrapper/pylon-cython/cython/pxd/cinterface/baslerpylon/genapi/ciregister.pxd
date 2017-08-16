from exception.custom_exception cimport raise_py_error
from libcpp cimport bool
from libc.stdint cimport int64_t, uint8_t
from base.cgcbase cimport gcstring
from genapi.cienumentry cimport IEnumEntry
from genapi.cienumeration cimport IEnumeration
from genapi.civalue cimport IValue

cdef extern from "genapi/IRegister.h" namespace 'GENAPI_NAMESPACE':
    cdef cppclass IRegister (IValue):
        # Set the register's contents
        # /*!
        # \param pBuffer The buffer containing the data to set
        # \param Length The number of bytes in pBuffer
        # \param Verify Enables AccessMode and Range verification (default = true)
        # */
        void Set(const uint8_t *pBuffer, int64_t Length, bool Verify) except +raise_py_error
        void Set(const uint8_t *pBuffer, int64_t Length) except +raise_py_error
        # Fills a buffer with the register's contents
        # /*!
        # \param pBuffer The buffer receiving the data to read
        # \param Length The number of bytes to retrieve
        # \param Verify Enables Range verification (default = false). The AccessMode is always checked
        # \param IgnoreCache If true the value is read ignoring any caches (default = false)
        # */
        void Get(uint8_t *pBuffer, int64_t Length, bool Verify, bool IgnoreCache) except +raise_py_error
        void Get(uint8_t *pBuffer, int64_t Length, bool IgnoreCache) except +raise_py_error
        void Get(uint8_t *pBuffer, int64_t Length, bool Verify) except +raise_py_error
        void Get(uint8_t *pBuffer, int64_t Length) except +raise_py_error
        # Retrieves the Length of the register [Bytes]
        int64_t GetLength() except +
        # Retrieves the Address of the register
        int64_t GetAddress() except +

