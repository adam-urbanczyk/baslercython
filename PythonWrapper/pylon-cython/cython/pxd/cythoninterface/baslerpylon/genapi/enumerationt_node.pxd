from exception.custom_exception cimport raise_py_error
from genapi.cienumerationt cimport IEnumerationT

cdef class EnumerationTNode (EnumerationNode):
	cdef:
         IEnumerationT* ienumerationt

    @staticmethod
    cdef create(IEnumerationT* ienumerationt)