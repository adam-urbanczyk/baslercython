from exception.custom_exception cimport raise_py_error

from libcpp cimport bool
from libc.stdint cimport int64_t, uint32_t
from base.cgcbase cimport gcstring
from genapi.civalue cimport IValue
from baslerpylon.genapi.types cimport ERepresentation, EIncMode

cdef extern from "genapi/IInteger.h" namespace 'GENAPI_NAMESPACE':
    cdef cppclass IInteger (IValue):
        # # Set node value
        # /*!
        # \param Value The value to set
        # \param Verify Enables AccessMode and Range verification (default = true)
        # */
        void SetValue(int64_t Value, bool Verify) except +raise_py_error
        void SetValue(int64_t Value) except +raise_py_error
        # # Set node value
        # IInteger& operator=(int64_t Value) except +raise_py_error
        # 
        # # Get node value
        # /*!
        # \param Verify Enables Range verification (default = false). The AccessMode is always checked
        # \param IgnoreCache If true the value is read ignoring any caches (default = false)
        # \return The value read
        # */
        int64_t GetValue(bool Verify , bool IgnoreCache ) except +raise_py_error
        int64_t GetValue( bool IgnoreCache) except +raise_py_error
        int64_t GetValue(bool Verify) except +raise_py_error
        int64_t GetValue() except +raise_py_error


        # Get minimum value allowed
        int64_t GetMin() except +raise_py_error

        # Get maximum value allowed
        int64_t GetMax() except +raise_py_error

        # Get increment mode
        EIncMode GetIncMode() except +raise_py_error

        # Get increment
        int64_t GetInc() except +raise_py_error

        # Get list of valid value
        #int64_autovector_t GetListOfValidValues(bool bounded ) except +raise_py_error
        # Get list of valid value
        #int64_autovector_t GetListOfValidValues() except +raise_py_error

        # Get recommended representation
        ERepresentation GetRepresentation() except +raise_py_error

        # Get the physical unit name
        gcstring GetUnit() except +raise_py_error

        # Restrict minimum value
        void ImposeMin(int64_t Value) except +raise_py_error

        # Restrict maximum value
        void ImposeMax(int64_t Value) except +raise_py_error

