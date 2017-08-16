# # Grab_CameraEvents.cpp
# /*
#     Note: Before getting started, Basler recommends reading the Programmer's Guide topic
#     in the pylon C++ API documentation that gets installed with pylon.
#     If you are upgrading to a higher major version of pylon, Basler also
#     strongly recommends reading the Migration topic in the pylon C++ API documentation.
#
#     Basler GigE Vision and IEEE 1394 cameras can send event messages. For example, when a sensor
#     exposure has finished, the camera can send an Exposure End event to the PC. The event
#     can be received by the PC before the image data for the finished exposure has been completely
#     transferred. This pythonsample illustrates how to be notified when camera event message data
#     is received.
#
#     The event messages are automatically retrieved and processed by the InstantCamera classes.
#     The information carried by event messages is exposed as parameter nodes in the camera node map
#     and can be accessed like "normal" camera parameters. These nodes are updated
#     when a camera event is received. You can register camera event handler objects that are
#     triggered when event data has been received.
#
#     These mechanisms are demonstrated for the Exposure End and the Event Overrun events.
#     The  Exposure End event carries the following information:
#     * ExposureEndEventFrameID: Indicates the number of the image frame that has been exposed.
#     * ExposureEndEventTimestamp: Indicates the moment when the event has been generated.
#     * ExposureEndEventStreamChannelIndex: Indicates the number of the image data stream used to
#     transfer the exposed frame.
#     The Event Overrun event is sent by the camera as a warning that events are being dropped. The
#     notification contains no specific information about how many or which events have been dropped.
#     Events may be dropped if events are generated at a very high frequency and if there isn't enough
#     bandwidth available to send the events.
#
#     It is shown in this pythonsample how to register event handlers indicating the arrival of events
#     sent by the camera. For demonstration purposes, several different handlers are registered
#     for the same event.
# */


import baslerpylon.pylon.tlfactory as tlfactory
from  baslerpylon.pylon.usb.basler_usb_grab_result import BaslerUsbGrabResult
from PIL import Image
import pylonsample.sample_chunk_ts_image_event_handler as samplechunktsimageeventhandler
import baslerpylon.pylon.camera_enum as enum
import baslerpylon.pylon.usb.basler_usb_instant_camera as usbcamera


factory_instant = tlfactory.TlFactory().get_instance()
device_infos = factory_instant.find_devices_info_list()
cam = usbcamera.BaslerUsbInstantCamera.create_cam(factory_instant.create_first_device())
#Print the model name of the camera.
print("using device " + cam.device_info.model_name)


#Register an image event handler that accesses the chunk data.
cam.register_image_event_handler(samplechunktsimageeventhandler.SampleChunkTSImageEventHandler(),enum.RegistrationMode_Append, enum.Cleanup_Delete)


cam.open()

#A GenICam node map is required for accessing chunk data. That's why a small node map is required for each grab result.
        # Creating a lot of node maps can be time consuming.
        # The node maps are usually created dynamically when StartGrabbing() is called.
        # To avoid a delay caused by node map creation in StartGrabbing() you have the option to create
        # a static pool of node maps once before grabbing.

if cam.get_node_map().is_available("ChunkModeActive"):
    cam.get_node_map()["ChunkModeActive"] = True
else:
    raise Exception("The camera doesn't support chunk features")

counter = 0

#Enable time stamp chunks.
cam.get_node_map()['ChunkSelector'] = "Timestamp"
cam.get_node_map()['ChunkEnable'] = True
cam.get_node_map()['ChunkSelector'] = "PayloadCRC16"
cam.get_node_map()['ChunkEnable'] = True

cam.start_grabbing(5)
grabResult = BaslerUsbGrabResult()

while cam.is_grabbing():
    cam.retrieve_result(500, grabResult)
    print("GrabSucceeded: " + str(grabResult.grab_succeeded()))
    print("SizeX: "  + str(grabResult.width))
    print("SizeY: "  + str(grabResult.height))
    ###need to implment mroe method here

cam.get_node_map()["ChunkModeActive"] = True


#to release resource, this function must be called
factory_instant.terminate()

