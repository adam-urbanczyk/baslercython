from exception.custom_exception cimport raise_py_error
from libcpp cimport bool
from genapi.civalue cimport IValue


cdef extern from "genapi/ICommand.h" namespace 'GENAPI_NAMESPACE':
    cdef cppclass ICommand(IValue):
        # //! Execute the command
        # /*!
        # \param Verify Enables AccessMode and Range verification (default = true)
        # */
        void Execute(bool Verify) except +raise_py_error
        void Execute() except +raise_py_error
        #  //! Query whether the command is executed
        # /*!
        # \param Verify Enables Range verification (default = false). The AccessMode is always checked
        # \return True if the Execute command has finished; false otherwise
        # */
        bool IsDone(bool Verify) except +raise_py_error
        bool IsDone() except +raise_py_error

