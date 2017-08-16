from exception.custom_exception cimport raise_py_error
from libcpp cimport bool
from libc.stdint cimport int64_t, uint32_t
from base.cgcbase cimport gcstring
from genapi.civalue cimport IValue
from baslerpylon.genapi.types cimport EIncMode, EDisplayNotation, ERepresentation

cdef extern from "genapi/IFloat.h" namespace 'GENAPI_NAMESPACE':
    cdef cppclass IFloat (IValue):
        # Set node value
        # /*!
        # \param Value The value to set
        # \param Verify Enables AccessMode and Range verification (default = true)
        # */
        void SetValue(double Value, bool Verify) except +raise_py_error
        void SetValue(double Value) except +raise_py_error
        # Get node value
        # /*!
        # \param Verify Enables Range verification (default = false). The AccessMode is always checked
        # \param IgnoreCache If true the value is read ignoring any caches (default = false)
        # \return The value read
        # */
        double GetValue(bool Verify, bool IgnoreCache) except +raise_py_error
        double GetValue(bool IgnoreCache) except +raise_py_error
        double GetValue(bool Verify) except +raise_py_error
        double GetValue() except +raise_py_error
        # Get minimum value allowed
        double GetMin() except +raise_py_error
        # Get maximum value allowed
        double GetMax() except +raise_py_error
        # True if the float has a constant increment
        bool HasInc() except +raise_py_error
        # Get increment mode
        EIncMode GetIncMode() except +raise_py_error
        # Get the constant increment if there is any
        double GetInc() except +raise_py_error
        #double_autovector_t GetListOfValidValues( bool bounded) except +
        #double_autovector_t GetListOfValidValues() except +
        # Get recommended representation
        ERepresentation GetRepresentation() except +raise_py_error
        # Get the physical unit name
        gcstring GetUnit() except +raise_py_error
        # Get the way the float should be converted to a string
        EDisplayNotation GetDisplayNotation() except +raise_py_error
        # Get the precision to be used when converting the float to a string
        int64_t GetDisplayPrecision() except +raise_py_error
        # Restrict minimum value
        void ImposeMin(double Value) except +raise_py_error
        # Restrict maximum value
        void ImposeMax(double Value) except +raise_py_error


