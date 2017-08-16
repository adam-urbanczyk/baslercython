from pylon.usb.cbasler_usb_camera_event_handler cimport CBaslerUsbCameraEventHandler

cdef class BaslerUsbCameraEventHandler:
    cdef:
        CBaslerUsbCameraEventHandler* camera_event_handler
    cdef CBaslerUsbCameraEventHandler* get_camera_event_handler_object(self)