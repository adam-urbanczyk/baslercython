from exception.custom_exception cimport raise_py_error
from baslerpylon.pylon.camera_enum cimport EDeviceAccessMode

cdef extern from "pylon/DeviceAccessMode.h" namespace 'Pylon':

    ctypedef EDeviceAccessMode AccessMode;

    cdef cppclass AccessModeSet:

        AccessModeSet() except +raise_py_error
        #Converts an access mode into a set.
        AccessModeSet(EDeviceAccessMode) except +raise_py_error

        # // -------------------------------------------------------------------------
        # // Access mode operators
        # // -------------------------------------------------------------------------
        #
        # /*!
        #    \brief Creates a set containing lhs and rhs operands
        #    \param lhs left operand
        #    \param rhs right operand
        #    \return returns an AccessModeSet containing both operands
        #    \ingroup Pylon_TransportLayer
        # */
        AccessModeSet  plus "operator+"(EDeviceAccessMode lhs, EDeviceAccessMode rhs) except +raise_py_error

        # /*!
        #    \brief Creates a set containing lhs and rhs operands.
        #    \param lhs left operand
        #    \param rhs right operand
        #    \ingroup Pylon_TransportLayer
        # */
        AccessModeSet concate "operator|"(EDeviceAccessMode lhs, EDeviceAccessMode rhs) except +raise_py_error

        # /*!
        #     \brief Adds the operand rhs to the set lhs
        #     \param lhs a set of bits.
        #     \param rhs the additional bit
        #     \ingroup Pylon_TransportLayer
        # */
        AccessModeSet plus "operator+"(const AccessModeSet& lhs, EDeviceAccessMode rhs) except +raise_py_error

        # /*!
        #     \brief Adds the operand rhs to the set lhs
        #     \param lhs a set of bits.
        #     \param rhs the additional bit
        #     \ingroup Pylon_TransportLayer
        # */
        AccessModeSet concate "operator|"(const AccessModeSet& lhs, EDeviceAccessMode rhs) except +raise_py_error

