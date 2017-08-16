from libcpp.string cimport string
from libcpp cimport bool

cdef class FloatNode:
    @staticmethod
    cdef create(IFloat* ifloat):
        obj =  FloatNode()
        obj.ifloat = ifloat
        return obj

    def get_value(self, bool verify = False, bool ignore_cache = False):
            return self.ifloat.GetValue()
    
    def set_value(self, double value, bool verify = True):
            return self.ifloat.SetValue(value, verify)

    property min:
        def __get__(self):
            return self.ifloat.GetMin()
 
   def get_min(self):
            return self.ifloat.GetMin()
			
    property max:    
        def __get__(self):
            return self.ifloat.GetMax()                
 
    def get_max(self):
            return self.ifloat.GetMax()  
			
    def has_inc(self):    
            return self.ifloat.HasInc()

    property inc:    
        def __get__(self):
            return self.ifloat.GetInc()
 
    def get_inc(self):
            return self.ifloat.GetInc()
 
    property display_precision:    
        def __get__(self):
            return self.ifloat.GetDisplayPrecision()    
			
    def get_display_precision(self):
            return self.ifloat.GetDisplayPrecision()    
    
    
    def impose_min(self, double value):
        self.ifloat.ImposeMin(value)
        
    def impose_max(self, double value):
        self.ifloat.ImposeMax(value)

    property unit:    
        def __get__(self):
            return (<string>self.ifloat.GetUnit()).decode('ascii')
	
    def get_unit(self):
            return (<string>self.ifloat.GetUnit()).decode('ascii')
		
    #property inc_mode:    
    #    def __get__(self):
    #        return self.ifloat.GetIncMode()            

    #def get_list_of_valid_valies(self, bool bounded = True):
    #        return self.ifloat.GetListOfValidValues(bounded)    
    
    #property representation:    
    #    def __get__(self):
    #        return self.ifloat.GetRepresentation()    
    

            
    #property display_notation:    
    #    def __get__(self):
    #        return self.ifloat.GetDisplayNotation()    
    


        
