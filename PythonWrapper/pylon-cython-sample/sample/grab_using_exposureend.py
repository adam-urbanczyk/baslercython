# /*
#     Note: Before getting started, Basler recommends reading the Programmer's Guide topic
#     in the pylon C++ API documentation that gets installed with pylon.
#     If you are upgrading to a higher major version of pylon, Basler also
#     strongly recommends reading the Migration topic in the pylon C++ API documentation.
#
#     This pythonsample shows how to use the Exposure End event to speed up the image acquisition.
#     For example, when a sensor exposure is finished, the camera can send an Exposure End event to the PC.
#     The PC can receive the event before the image data of the finished exposure has been completely transferred.
#     This can be used in order to avoid an unnecessary delay, for example when an imaged
#     object is moved further before the related image data transfer is complete.
# */

import baslerpylon.pylon.tlfactory as tlfactory
from baslerpylon.pylon.usb.basler_usb_instant_camera import BaslerUsbInstantCamera
import baslerpylon.pylon.camera_enum as enum
from baslerpylon.pylon.usb.basler_usb_grab_result import BaslerUsbGrabResult
from pylonsample.util.configuration_event_printer import ConfigurationEventPrinter
from pylonsample.sample_exposure_image_event_handler import SampleExposureImageEventHandler
from pylonsample.sample_exposure_camera_event_handler import SampleExposureCameraEventHandler , eMyFrameStartOvertrigger, eMyExposureEndEvent

factory_instant = tlfactory.TlFactory().get_instance()
cam = BaslerUsbInstantCamera.create_cam(factory_instant.create_first_device())
print("using device " + cam.device_info.model_name)


cameraEventHandler = SampleExposureCameraEventHandler()
cameraEventHandler2 = SampleExposureCameraEventHandler()
imageEventHandler = SampleExposureImageEventHandler()

#For demonstration purposes only, add pythonsample configuration event handlers to print out information
        # about camera use and image grabbing.


cam.register_configuration(ConfigurationEventPrinter(),enum.RegistrationMode_Append, enum.Cleanup_Delete)

#Register the event handler.
cam.register_camera_event_handler(cameraEventHandler, "EventExposureEndData", eMyExposureEndEvent, enum.RegistrationMode_Append, enum.Cleanup_Delete)
cam.register_camera_event_handler(cameraEventHandler2, "EventFrameStartOvertriggerData", eMyFrameStartOvertrigger, enum.RegistrationMode_Append, enum.Cleanup_Delete)


cam.register_image_event_handler(imageEventHandler,enum.RegistrationMode_Append, enum.Cleanup_Delete)

#Camera event processing must be activated first, the default is off.
cam.get_node_map()["GrabCameraEvents"] = True

#Open the camera for setting parameters.
cam.open()

#Check if the device supports events.
if cam.get_node_map().is_available("EventSelector"):

    #Enable the sending of Exposure End events.
        # Select the event to be received.
    cam.get_node_map()["EventSelector"] = "ExposureEnd"
    cam.get_node_map()["EventNotification"] = "On"

    #Enable the sending of Frame Start Overtrigger events.
    if cam.get_node_map().is_available("FrameStartOvertrigger"):
        cam.get_node_map()["EventSelector"] = "FrameStartOvertrigger"
        cam.get_node_map()["EventNotification"] = "On"

    #Start the grabbing of c_countOfImagesToGrab images.
        # The camera device is parameterized with a default configuration which
        # sets up free-running continuous acquisition.
    grabResult = BaslerUsbGrabResult()
    counter = 0
    cam.start_grabbing(5)

    #Camera.StopGrabbing() is called automatically by the RetrieveResult() method
        # when c_countOfImagesToGrab images have been retrieved.
    while cam.is_grabbing():
        #Retrieve grab results and notify the camera event and image event handlers.
	    cam.retrieve_result(500, grabResult)
        #Nothing to do here with the grab result, the grab results are handled by the registered event handlers.

    #Disable the sending of Exposure End events.
    cam.get_node_map()["EventSelector"] = "ExposureEnd"
    cam.get_node_map()["EventNotification"] = "Off"

    #Disable the sending of Frame Start Overtrigger events.
    if cam.get_node_map().is_available("FrameStartOvertrigger"):
        cam.get_node_map()["EventSelector"] = "FrameStartOvertrigger"
        cam.get_node_map()["EventNotification"] = "Off"

#Print the recorded log showing the timing of events and images.
cameraEventHandler.print_log()
imageEventHandler.print_log()
cameraEventHandler2.print_log()

#to release resource, this function must be called
factory_instant.terminate()