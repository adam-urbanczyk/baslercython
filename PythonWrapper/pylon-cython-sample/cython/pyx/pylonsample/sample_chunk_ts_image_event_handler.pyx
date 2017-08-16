from pylonsample.csample_chunk_ts_image_event_handler cimport CSampleChunkTSImageEventHandler
from pylon.usb.cbasler_usb_image_event_handler cimport CBaslerUsbImageEventHandler
from baslerpylon.pylon.usb.basler_usb_image_event_handler cimport BaslerUsbImageEventHandler

cdef class SampleChunkTSImageEventHandler(BaslerUsbImageEventHandler):

   def __cinit__(self):
        self.simage_event = new CSampleChunkTSImageEventHandler()

   cdef CBaslerUsbImageEventHandler* get_image_event_handler_object(self):
        return self.simage_event#new CSampleChunkTSImageEventHandler()