from exception.custom_exception cimport raise_py_error
from libcpp cimport bool
from libc.stdint cimport int64_t
from libcpp.string cimport string
from cython.operator cimport dereference as deref, preincrement as inc
from baslerpylon.genapi.types cimport ERepresentation, EIncMode
from genapi.ciinteger cimport IInteger

cdef class IntegerNode:
    @staticmethod
    cdef create(IInteger* integer):
        obj = IntegerNode()
        obj.iinteger = integer
        return obj

    def get_value(self, bool verify = False, bool ignore_cache = False):
            return (self.iinteger).GetValue(verify, ignore_cache)
			
    def set_value(self, int64_t value, bool verify = True):
            (self.iinteger).SetValue(value, verify)

    def get_max(self):
            self.iinteger.GetMax()

    property min:    
        def __get__(self):
            return self.iinteger.GetMin()
 
    def get_min(self):
            return self.iinteger.GetMin()
			
    property max:    
        def __get__(self):
            return self.iinteger.GetMax()

    property inc:    
        def __get__(self):
            return self.iinteger.GetInc()
 
  
    def get_inc(self):
            return self.iinteger.GetInc()
			
    property unit:    
        def __get__(self):
            return (<string>(self.iinteger.GetUnit())).decode('ascii')
 
    def get_unit(self):
            return (<string>(self.iinteger.GetUnit())).decode('ascii')
			
    def impose_min(self,int64_t value):
        (self.iinteger).ImposeMin(value)
        
    def impose_max(self,int64_t value):
        (self.iinteger).ImposeMax(value)
		
    #def get_inc_mode(self):
    #    (self.iinteger).GetIncMode() 
    #    return ""            

    #property list_of_valid_valies:    
    #    def __get__(self, bool bounded = true):
    #        return (self.iinteger).GetListOfValidValues()    
    
    #property representation:    
    #    def __get__(self):
    #        return (self.iinteger).GetRepresentation()    

        
        


        
