from pylon.usb.cbasler_usb_camera_event_handler cimport CBaslerUsbCameraEventHandler
from pylon.usb.cbasler_usb_image_event_handler cimport CBaslerUsbImageEventHandler
from baslerpylon.pylon.usb.basler_usb_camera_event_handler cimport BaslerUsbCameraEventHandler
from baslerpylon.pylon.usb.basler_usb_image_event_handler cimport BaslerUsbImageEventHandler





cdef class ExposureCameraEventHandler(BaslerUsbCameraEventHandler):
   cdef CBaslerUsbCameraEventHandler* get_camera_event_handler_object(self)

cdef extern from "SampleExposureImageEventHandler.cpp":
    cpdef enum MyEvents:
        eMyExposureEndEvent,      # Triggered by a camera event.
        eMyFrameStartOvertrigger, # Triggered by a camera event.
        eMyImageReceivedEvent,    # Triggered by the receipt of an image.
        eMyMoveEvent,             # Triggered when the imaged item or the sensor head can be moved.
        eMyNoEvent                # Used as default setting.

