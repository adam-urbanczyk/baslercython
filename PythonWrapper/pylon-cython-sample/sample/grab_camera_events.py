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
import baslerpylon.pylon.usb.basler_usb_grab_result as grabresult
from pylonsample.sample_camera_event_handler import SampleCameraEventHandler
import baslerpylon.pylon.camera_enum as enum
import baslerpylon.pylon.usb.basler_usb_instant_camera as usbcamera
from baslerpylon.pylon.software_trigger_configuration import SoftwareTriggerConfiguration
from pylonsample.util.image_event_printer import ImageEventPrinter
from pylonsample.util.camera_event_printer import CameraEventPrinter
from pylonsample.util.configuration_event_printer import ConfigurationEventPrinter
import sys, traceback

try:
	factory_instant = tlfactory.TlFactory().get_instance()
	device_infos = factory_instant.find_devices_info_list()

	cam = usbcamera.BaslerUsbInstantCamera.create_cam(factory_instant.create_first_device())

	#Register the standard configuration event handler for enabling software triggering.
	# The software trigger configuration handler replaces the default configuration
	# as all currently registered configuration handlers are removed by setting the registration mode to RegistrationMode_ReplaceAll.
	cam.register_configuration(SoftwareTriggerConfiguration(), enum.RegistrationMode_ReplaceAll, enum.Cleanup_Delete)

	#For demonstration purposes only, add pythonsample configuration event handlers to print out information
	# about camera use and image grabbing.
	cam.register_configuration(ConfigurationEventPrinter(), enum.RegistrationMode_Append, enum.Cleanup_Delete)

	#For demonstration purposes only, register another image event handler
	cam.register_image_event_handler(ImageEventPrinter(), enum.RegistrationMode_Append, enum.Cleanup_Delete)

	#Camera event processing must be activated first, the default is off.
	cam.get_node_map()["GrabCameraEvents"] = True;

	#Register an event handler for the Exposure End event. For each event type, there is a "data" node
			# representing the event. The actual data that is carried by the event is held by child nodes of the
			# data node. In the case of the Exposure End event, the child nodes are EventExposureEndFrameID and EventExposureEndTimestamp.
			# The CSampleCameraEventHandler demonstrates how to access the child nodes within
			# a callback that is fired for the parent data node.
			# The user-provided ID eMyExposureEndEvent can be used to distinguish between multiple events (not shown).

	# Create an example event handler. In the present case, we use one single camera handler for handling multiple camera events.
	# The handler prints a message for each received event.
	pHandler1 =  SampleCameraEventHandler()

	#Create another more generic event handler printing out information about the node for which an event callback
	# is fired.
	pHandler2 = CameraEventPrinter()
	pHandler3 = CameraEventPrinter()

	cam.register_camera_event_handler(pHandler1, "EventExposureEndData", 100, enum.RegistrationMode_Append, enum.Cleanup_Delete)

	#The handler is registered for both, the EventExposureEndFrameID and the EventExposureEndTimestamp
			# node. These nodes represent the data carried by the Exposure End event.
			# For each Exposure End event received, the handler will be called twice, once for the frame ID, and
			# once for the time stamp.
	cam.register_camera_event_handler(pHandler2, "EventExposureEndFrameID", 100, enum.RegistrationMode_Append, enum.Cleanup_Delete)
	cam.register_camera_event_handler(pHandler3, "EventExposureEndTimestamp", 100, enum.RegistrationMode_Append, enum.Cleanup_Delete)



	cam.open()

	if not cam.get_node_map().is_available("EventSelector"):
		raise Exception( "The device doesn't support events.")


	#Enable sending of Exposure End events.
	# Select the event to receive.
	cam.get_node_map()["EventSelector"] = "ExposureEnd"
	cam.get_node_map()["EventNotification"] = "On"


	#Start the grabbing of c_countOfImagesToGrab images.
	cam.start_grabbing(5)
	grabResult = grabresult.BaslerUsbGrabResult()
	counter = 0

	#Camera.StopGrabbing() is called automatically by the RetrieveResult() method
	# when c_countOfImagesToGrab images have been retrieved.
	while cam.is_grabbing():
		if (cam.wait_for_frame_trigger_ready(500, enum.TimeoutHandling_ThrowException)):
			cam.execute_software_trigger()
		cam.retrieve_result(500, grabResult)
		#if grabResult.grab_success():
		#img = grabResult.get_image()
		counter = counter + 1
		#grabResult.save_image(enum.ImageFileFormat_Bmp, "image#" + str(counter) + "your_file.bmp")


	cam.get_node_map()["EventSelector"] = "ExposureEnd"
	cam.get_node_map()["EventNotification"] = "Off"

except:
	traceback.print_exc(file=sys.stdout)

#to release resource, this function must be called
factory_instant.terminate()