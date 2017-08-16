cdef extern from "genapi/Types.h" namespace 'GENAPI_NAMESPACE':            
    cpdef enum EIncMode:
        noIncrement,        
        fixedIncrement,
        listIncrement

    cpdef enum EDisplayNotation:
        fnAutomatic,                # the notation if either scientific or fixed depending on what is shorter
        fnFixed,                    # the notation is fixed, e.g. 123.4
        fnScientific,               # the notation is scientific, e.g. 1.234e2
        _UndefinedEDisplayNotation
        

    cpdef enum ERepresentation:        
        Linear,                     # Slider with linear behavior
        Logarithmic,                # Slider with logarithmic behaviour
        Boolean,                    # Check box
        PureNumber,                 # Decimal number in an edit control
        HexNumber,                  # Hex number in an edit control
        IPV4Address,                # IP-Address
        MACAddress,                 # MAC-Address
        _UndefinedRepresentation