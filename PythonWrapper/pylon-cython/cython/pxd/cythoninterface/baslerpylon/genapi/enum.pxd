cdef extern from "genapi/Types.h" namespace 'GENAPI_NAMESPACE':
    cpdef enum ESign:
        Signed,         # Integer is signed
        Unsigned,       # Integer is unsigned
        _UndefinedSign  # Object is not yet initialized

    # # access mode of a node
    # # \ingroup GenApi_PublicUtilities
    cpdef enum EAccessMode:
        NI,        # Not implemented
        NA,        # Not available
        WO,        # Write Only
        RO,        # Read Only
        RW,        # Read and Write
        _UndefinedAccesMode,    # Object is not yet initialized
        _CycleDetectAccesMode   # used internally for AccessMode cycle detection

    # # recommended visibility of a node
    # # \ingroup GenApi_PublicUtilities
    cpdef enum EVisibility:
        Beginner ,              # Always visible
        Expert ,                # Visible for experts or Gurus
        Guru ,                  # Visible for Gurus
        Invisible ,             # Not Visible
        _UndefinedVisibility  # Object is not yet initialized


    # caching mode of a register
    # \ingroup GenApi_PublicUtilities
    cpdef enum ECachingMode:
        NoCache,             # Do not use cache
        WriteThrough,        # Write to cache and register
        WriteAround,         # Write to register, write to cache on read
        _UndefinedCachingMode # Not yet initialized


    # recommended representation of a node value
    # \ingroup GenApi_PublicUtilities:
    cpdef enum ERepresentation:
        Linear,                     # Slider with linear behavior
        Logarithmic,                # Slider with logarithmic behaviour
        Boolean,                    # Check box
        PureNumber,                 # Decimal number in an edit control
        HexNumber,                  # Hex number in an edit control
        IPV4Address,                # IP-Address
        MACAddress,                 # MAC-Address





    # Endianess of a value in a register
    # \ingroup GenApi_PublicUtilities
    cpdef enum EEndianess:
        BigEndian,        # Register is big endian
        LittleEndian,     # Register is little endian
        _UndefinedEndian  # Object is not yet initialized


    # Defines if a node name is standard or custom
    # \ingroup GenApi_PublicUtilities
    cpdef enum ENameSpace:
    
        Custom,             # name resides in custom namespace
        Standard,           # name resides in one of the standard namespaces
        _UndefinedNameSpace # Object is not yet initialized



    # Defines from which standard namespace a node name comes from
    # \ingroup GenApi_PublicUtilities
    cpdef enum EStandardNameSpace:
        None,            # name resides in custom namespace
        GEV,             # name resides in GigE Vision namespace
        IIDC,            # name resides in 1394 IIDC namespace
        CL,              # name resides in camera link namespace
        USB,             # name resides in USB namespace
        _UndefinedStandardNameSpace  # Object is not yet initialized



    # Defines the chices of a Yes/No alternaitve
    # \ingroup GenApi_PublicUtilities
    cpdef enum EYesNo:
        Yes ,                # yes
        No ,                 # no
        _UndefinedYesNo     # Object is not yet initialized


    # cpdef for fomula type
    # \ingroup GenApi_PublicImpl
    cpdef enum ESlope:
    
        Increasing,      # strictly monotonous increasing
        Decreasing,      # strictly monotonous decreasing
        Varying,         # slope changes, e.g. at run-time
        Automatic,       # slope is determined automatically by probing the function
        _UndefinedESlope # Object is not yet initialized


    # cpdef describing the different validity checks which can be performed on an XML file
    # The enum values for a bitfield of length uint32_t */
    # \ingroup GenApi_PublicImpl
    cpdef enum EXMLValidation:
        xvLoad    ,    # Creates a dummy node map
        xvCycles   ,   # checks for write and dependency cycles (implies xvLoad)
        xvSFNC    ,    # checks for conformance with the standard feature naming convention (SFNC)
        xvDefault ,  # checks performed if nothing else is said
        xvAll    , # all possible checks
        _UndefinedEXMLValidation  # Object is not yet initialized


    # cpdef for float notation
    # \ingroup GenApi_PublicImpl
    cpdef enum EDisplayNotation:
    
        fnAutomatic,                # the notation if either scientific or fixed depending on what is shorter
        fnFixed,                    # the notation is fixed, e.g. 123.4
        fnScientific,               # the notation is scientific, e.g. 1.234e2
        _UndefinedEDisplayNotation  # Object is not yet initialized

    # cpdef for interface type
    # \ingroup GenApi_PublicImpl
    cpdef enum EInterfaceType:
        intfIValue,       # IValue interface
        intfIBase,        # IBase interface
        intfIInteger,     # IInteger interface
        intfIBoolean,     # IBoolean interface
        intfICommand,     # ICommand interface
        intfIFloat,       # IFloat interface
        intfIString,      # IString interface
        intfIRegister,    # IRegister interface
        intfICategory,    # ICategory interface
        intfIEnumeration, # IEnumeration interface
        intfIEnumEntry,   # IEnumEntry interface
        intfIPort         # IPort interface


    # cpdef for link type
    # For details see GenICam wiki : GenApi/SoftwareArchitecture/NodeDependencies
    #ingroup GenApi_PublicImpl
    #
    cpdef enum ELinkType:
        ctParentNodes,          # All nodes for which this node is at least an invalidating child
        ctReadingChildren,      # All nodes which can be read from
        ctWritingChildren,      # All nodes which can write a value further down the node stack
        ctInvalidatingChildren, # All directly connected nodes which invalidate this node
        ctDependingNodes,       # All directly or indirectly connected nodes which are invalidated by this nodes (i.e. which are dependent on this node)
        ctTerminalNodes         # All indirectly connected terminal nodes


    # cpdef for increment mode
    # \ingroup GenApi_PublicImpl
    cpdef enum EIncMode:
        noIncrement,    # !> The feature has no increment
        fixedIncrement, # !> The feature has a fix increment
        listIncrement   # !> The feature has a list of valid value


    # cpdef for link type
    # \ingroup GenApi_PublicImpl
    cpdef enum EInputDirection:
        idFrom, # Indicates a swiss knife that it is used as worker for a converter computing FROM
        idTo,   # Indicates a swiss knife that it is used as worker for a converter computing TO
        idNone  # SwissKnife is not used within a converter


    # GenApi schema version
    cpdef enum EGenApiSchemaVersion: 
        v1_0, 
        v1_1, 
        _Undefined


cdef extern from "genapi/NodeCallBack.h" namespace 'GENAPI_NAMESPACE':
    # GenApi schema version
    cpdef enum ECallbackType:
        cbPostInsideLock,   # callback is fired on leaving the tree inside the lock-guarded area
        cbPostOutsideLock   # callback is fired on leaving the tree inside the lock-guarded area
