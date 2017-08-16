from pylon.usb.cbasler_usb_configuration_event_handler cimport CBaslerUsbConfigurationEventHandler

cdef class BaslerUsbConfigurationEventHandler:
    cdef:
        CBaslerUsbConfigurationEventHandler* configuration_object
    cdef CBaslerUsbConfigurationEventHandler* get_configuration_event_handler_object(self)