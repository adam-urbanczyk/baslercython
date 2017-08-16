from exception.custom_exception cimport raise_py_error


cdef extern from "<vector>" namespace "std":
    cdef cppclass vector[T]:
        cppclass iterator:
            T operator*()
            iterator operator++()
            bint operator==(iterator)
            bint operator!=(iterator)
        vector()
        void push_back(T&)
        T& operator[](int)
        T& at(int)
        iterator begin()
        iterator end()
		
cdef extern from "Base/GCBase.h":
    cdef cppclass gcstring:
        gcstring(char*) except +raise_py_error

    cdef cppclass gcstring_vector:
        pass

