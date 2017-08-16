from exception.custom_exception cimport raise_py_error
from pylon.cdevice_info cimport CDeviceInfo
from pylon.ccontainer cimport DeviceInfoList_t
from libcpp cimport bool
from pylon.cdevice cimport IPylonDevice
#from pylon.enum cimport EDeviceAccessiblityInfo
from pylon.ctype_mappings cimport String_t

cdef extern from "pylon/DeviceFactory.h" namespace 'Pylon':
    # /*!
    # \interface IDeviceFactory
    # \brief Interface to be implemented by device factories used to create devices.
    #
    # Each transport layer object is a device factory. These device factories must implement
    # the IDeviceFactory interface.
    #
    # \ingroup Pylon_TransportLayer
    # */
    cdef cppclass IDeviceFactory:
        # /// Retrieves a list of available devices.
        # /**
        # The list contains Pylon::CDeviceInfo objects used for the device creation.
        #
        # By default, the list passed in will be cleared before the device discovery is started.
        #
        # \param list List to be filled with device info objects.
        # \param addToList If true, the found devices will be added to the list instead of deleting the list.
        # \return Number of devices found.
        # */
        int EnumerateDevices( DeviceInfoList_t& list, bool addToList = false ) except +raise_py_error

        # /// Retrieves a list of available devices filtered by given properties, usable for looking for specific devices.
        # /**
        # The list contains Pylon::CDeviceInfo objects used for the device creation.
        # By default, the list passed in will be cleared before the device discovery is started.
        # The filter list can contain a list of device info objects containing properties a device must have, e.g.
        # the user-provided name or the serial number. A device is returned, if it matches the properties of any of the
        # device info objects in the filter list.
        # When the device class property is set in the filter device info objects, the search is
        # limited to the required transport layers.
        #
        # \param list List to be filled with device info objects.
        # \param filter A list of device info objects with user-provided properties that a device can match.
        # \param addToList If true, found devices will be added to the list instead of deleting the list.
        # \return Number of devices found.
        # */
        int EnumerateDevices( DeviceInfoList_t& list, const DeviceInfoList_t& filter, bool addToList = false ) except +raise_py_error

        # /// Creates a camera object from a device info object.
        # /**
        #     This method accepts either a device info object from a device enumeration or a user-provided device info object.
        #     User-provided device info objects can be preset with properties required for a device, e.g.
        #     the user-provided name or the serial number. The implementation tries to find a matching camera by using device
        #     enumeration.
        #     When the device class property is set, the search is limited to the required transport layer.
        #
        #     If the device creation fails, a GenApi::GenericException will be thrown.
        #     \param di Device info object containing all information needed to identify exactly one device.
        # */
        IPylonDevice* CreateDevice( const CDeviceInfo& di ) except +raise_py_error

        # /// If multiple devices match the provided properties, the first device found is created.
        # /// The order in which the devices are found can vary from call to call.
        IPylonDevice* CreateFirstDevice( const CDeviceInfo& di = CDeviceInfo())except +raise_py_error
        #
        # /// Creates a camera object from a device info object, injecting additional GenICam XML definition strings.
        # /// Currently only one injected xml string is supported.
        #IPylonDevice* CreateDevice( const CDeviceInfo& di, const StringList_t& InjectedXmlStrings ) = 0;
        #
        # /// Creates the first found camera device matching the provided properties, injecting additional GenICam XML definition strings.
        # /// Currently only one injected xml string is supported.
        # IPylonDevice* CreateFirstDevice( const CDeviceInfo& di, const StringList_t& InjectedXmlStrings ) = 0;



        # /// Destroys a device.
        # /** \note: Never try to delete a pointer to a camera device by calling free or delete.
        #     Always use the DestroyDevice method.
        # */
        void DestroyDevice( IPylonDevice* ) except +raise_py_error

        # /*!
        # \brief This method can be used to check if a camera device can be created and opened.
        #
        # This method accepts either a device info object from a device enumeration or a user-provided device info object.
        # User-provided device info objects can be preset with properties required for a device, e.g.
        # the user-provided name or the serial number. The implementation tries to find a matching camera by using device
        # enumeration.
        # When the device class property is set, the search is limited to the required transport layer.
        #
        # \param[in]  deviceInfo         Properties of the camera device.
        # \param[in]  mode               Used for defining how a device is accessed.
        #                                The use of the mode information is transport layer-specific.
        #                                For IIDC 1394 devices the mode information is ignored.
        #                                For GigE devices the \c Exclusive and \c Control flags are used for defining how a device is accessed.
        # \param[in]  pAccessibilityInfo Optionally provides more information about why a device is not accessible.
        # \return True if device can be opened with provided access mode.
        #
        # \pre The \c deviceInfo object properties specify exactly one device.
        #      This is the case when the device info object has been obtained using device enumeration.
        #
        # \error
        #      Throws a C++ exception, if the preconditions are not met.
        # */
       # bool IsDeviceAccessible( const CDeviceInfo& deviceInfo, AccessModeSet mode , EDeviceAccessiblityInfo* pAccessibilityInfo ) except +raise_py_error
        #bool IsDeviceAccessible( const CDeviceInfo& deviceInfo, EDeviceAccessiblityInfo* pAccessibilityInfo) except +raise_py_error
        #bool IsDeviceAccessible( const CDeviceInfo& deviceInfo, AccessModeSet mode) except +raise_py_error
        bool IsDeviceAccessible( const CDeviceInfo& deviceInfo) except +raise_py_error

