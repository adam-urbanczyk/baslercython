from pylon.usb.cbasler_usb_configuration_event_handler cimport CBaslerUsbConfigurationEventHandler

cdef class BaslerUsbConfigurationEventHandler:

    def __cinit__(self):
        self.configuration_object = new CBaslerUsbConfigurationEventHandler()

    cdef CBaslerUsbConfigurationEventHandler* get_configuration_event_handler_object(self):
        return self.configuration_object