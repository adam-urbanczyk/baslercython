# /*
#     Note: Before getting started, Basler recommends reading the Programmer's Guide topic
#     in the pylon C++ API documentation that gets installed with pylon.
#     If you are upgrading to a higher major version of pylon, Basler also
#     strongly recommends reading the Migration topic in the pylon C++ API documentation.
#
#     This pythonsample shows how to grab images using the sequencer feature of a camera.
#     Three sequence sets are used for image acquisition. Each sequence set
#     uses a different image height.
# */

import baslerpylon.pylon.tlfactory as tlfactory
from baslerpylon.pylon.usb.basler_usb_instant_camera import BaslerUsbInstantCamera
from baslerpylon.pylon.software_trigger_configuration import SoftwareTriggerConfiguration
import baslerpylon.pylon.camera_enum as enum
from baslerpylon.pylon.usb.basler_usb_grab_result import BaslerUsbGrabResult

factory_instant = tlfactory.TlFactory().get_instance()
cam = BaslerUsbInstantCamera.create_cam(factory_instant.create_first_device())
print("using device " + cam.device_info.model_name)

#Register the standard configuration event handler for enabling software triggering.
        # The software trigger configuration handler replaces the default configuration
        # as all currently registered configuration handlers are removed by setting the registration mode to RegistrationMode_ReplaceAll.
cam.register_configuration(SoftwareTriggerConfiguration(), enum.RegistrationMode_ReplaceAll, enum.Cleanup_Delete)

#Open the camera.
cam.open()


if cam.get_node_map().is_available("SequencerMode"):
    #Disable the sequencer before changing parameters.
            # The parameters under control of the sequencer are locked
            # when the sequencer is enabled. For a list of parameters
            # controlled by the sequencer, see the camera User's Manual.
    cam.get_node_map()["SequencerMode"]  = "Off"
    cam.get_node_map()["SequencerConfigurationMode"]  = "On"

    #Maximize the image area of interest (Image AOI).
    if cam.get_node_map().is_writable("OffsetX"):
         node = cam.get_node_map().get_node("OffsetX")

         node.set_value(node.min)

    if cam.get_node_map().is_writable("OffsetY"):
         node = cam.get_node_map().get_node("OffsetY")
         node.set_value(node.min)

    node = cam.get_node_map().get_node("Width")
    node.set_value(node.max)

    node = cam.get_node_map().get_node("Height")
    node.set_value(node.max)

    #Set the pixel data format.
    cam.get_node_map()["PixelFormat"]  = "Mono8"


    #Set up sequence sets.

            # Configure how the sequence will advance.

            # The sequence sets relate to three steps (0..2).
            # In each step, the height of the Image AOI is doubled.
    node = cam.get_node_map().get_node("Height")
    increments = (node.max - node.min) / node.inc

    initialSet = cam.get_node_map().get_node("SequencerSetSelector").min
    incSet =cam.get_node_map().get_node("SequencerSetSelector").inc
    curSet = initialSet

    #Set the parameters for step 0; quarter height image.
    cam.get_node_map()["SequencerSetSelector"] = initialSet
    ## valid for all sets
                # reset on software signal 1;
    cam.get_node_map()["SequencerPathSelector"] = 0
    cam.get_node_map()["SequencerSetNext"] = initialSet
    cam.get_node_map()["SequencerTriggerSource"] = "SoftwareSignal1"

    #advance on Frame Start
    cam.get_node_map()["SequencerPathSelector"] = 1
    cam.get_node_map()["SequencerTriggerSource"] = "FrameStart"

    cam.get_node_map()["SequencerSetNext"] = curSet + incSet

    #quarter height
    cam.get_node_map()["Height"] = cam.get_node_map().get_node("Height").inc * (increments / 4)
    cam.get_node_map().get_node("SequencerSetSave").execute()

    # Set the parameters for step 1; half height image.
    curSet += incSet
    cam.get_node_map()["SequencerSetSelector"] = curSet

    #advance on Frame Start to next set
    cam.get_node_map()["SequencerSetNext"] = curSet + incSet

    #half height
    cam.get_node_map()["Height"] = cam.get_node_map().get_node("Height").inc * (increments / 2)
    cam.get_node_map().get_node("SequencerSetSave").execute()

    #Set the parameters for step 2; full height image.
    curSet += incSet
    cam.get_node_map()["SequencerSetSelector"] = curSet

    #advance on Frame End to initial set,
    cam.get_node_map()["SequencerSetNext"] = curSet + incSet #terminates sequence definition

    #full height
    cam.get_node_map()["Height"] = cam.get_node_map().get_node("Height").inc * (increments )
    cam.get_node_map().get_node("SequencerSetSave").execute()

    # Enable the sequencer feature.
    # From here on you cannot change the sequencer settings anymore.
    cam.get_node_map()["SequencerConfigurationMode"] = "Off"
    cam.get_node_map()["SequencerMode"] ="On"

    # Start the grabbing of images.
    grabResult = BaslerUsbGrabResult()
    counter = 0
    cam.start_grabbing(5)
    
    #Camera.StopGrabbing() is called automatically by the RetrieveResult() method
            # when c_countOfImagesToGrab images have been retrieved.
    while cam.is_grabbing():
        if (cam.wait_for_frame_trigger_ready(500, enum.TimeoutHandling_ThrowException)):
            cam.execute_software_trigger()
        cam.retrieve_result(500, grabResult)
        if grabResult.grab_succeeded():
            counter = counter + 1
            print("SizeX: " + str(grabResult.width))
            print("SizeY: " + str(grabResult.height))
            grabResult.save_image(enum.ImageFileFormat_Bmp, str(counter) + "your_file.bmp")

    #Disable the sequencer.
    cam.get_node_map()["SequencerMode"] ="Off"

#to release resource, this function must be called
factory_instant.terminate()