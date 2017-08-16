cdef extern from "exception/CythonCustomErrorMessage.cpp":
  cdef void raise_py_error()