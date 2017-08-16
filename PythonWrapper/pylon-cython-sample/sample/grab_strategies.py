# /*
#     Note: Before getting started, Basler recommends reading the Programmer's Guide topic
#     in the pylon C++ API documentation that gets installed with pylon.
#     If you are upgrading to a higher major version of pylon, Basler also
#     strongly recommends reading the Migration topic in the pylon C++ API documentation.
#
#     This pythonsample shows the use of the Instant Camera grab strategies.
# */

import baslerpylon.pylon.tlfactory as tlfactory
from baslerpylon.pylon.usb.basler_usb_instant_camera import BaslerUsbInstantCamera
from baslerpylon.pylon.software_trigger_configuration import SoftwareTriggerConfiguration
import baslerpylon.pylon.camera_enum as enum
from baslerpylon.pylon.usb.basler_usb_grab_result import BaslerUsbGrabResult
from pylonsample.util.configuration_event_printer import ConfigurationEventPrinter
from pylonsample.util.image_event_printer import ImageEventPrinter
from baslerpylon.pylon.wait_object import PyWaitObject

factory_instant = tlfactory.TlFactory().get_instance()
cam = BaslerUsbInstantCamera.create_cam(factory_instant.create_first_device())
print("using device " + cam.device_info.model_name)

#Register the standard configuration event handler for enabling software triggering.
        # The software trigger configuration handler replaces the default configuration
        # as all currently registered configuration handlers are removed by setting the registration mode to RegistrationMode_ReplaceAll.
cam.register_configuration(SoftwareTriggerConfiguration(), enum.RegistrationMode_ReplaceAll, enum.Cleanup_Delete)

#For demonstration purposes only, add pythonsample configuration event handlers to print out information
        # about camera use and image grabbing.
cam.register_configuration(ConfigurationEventPrinter(), enum.RegistrationMode_Append, enum.Cleanup_Delete)


cam.register_image_event_handler(ImageEventPrinter(), enum.RegistrationMode_Append, enum.Cleanup_Delete)

#The MaxNumBuffer parameter can be used to control the count of buffers
        # allocated for grabbing. The default value of this parameter is 10.
cam.get_node_map()["MaxNumBuffer"] = 15

cam.open()
grabResult = BaslerUsbGrabResult()

#Can the camera device be queried whether it is ready to accept the next frame trigger?
if (cam.can_wait_for_frame_trigger_ready()):
    print("Grab using the GrabStrategy_OneByOne default strategy:")
    #The GrabStrategy_OneByOne strategy is used. The images are processed
            # in the order of their arrival.
    cam.start_grabbing(enum.GrabStrategy_OneByOne)

    #In the background, the grab engine thread retrieves the
            # image data and queues the buffers into the internal output queue.

            # Issue software triggers. For each call, wait up to 1000 ms until the camera is ready for triggering the next image.
    for i in range(3):
        if (cam.wait_for_frame_trigger_ready(2000, enum.TimeoutHandling_ThrowException)):
            cam.execute_software_trigger()

    #For demonstration purposes, wait for the last image to appear in the output queue.
    PyWaitObject.sleep(3 * 1000)

    #Check that grab results are waiting.
    if cam.get_grab_result_wait_object().wait( 0):
            print( "A grab result waits in the output queue." )

    # All triggered images are still waiting in the output queue
   # and are now retrieved.
   # The grabbing continues in the background, e.g. when using hardware trigger mode,
   # as long as the grab engine does not run out of buffers.
    nBuffersInQueue = 0;
    while cam.retrieve_result( 0, grabResult, enum.TimeoutHandling_Return):
        nBuffersInQueue += 1

    print("Retrieved " + str(nBuffersInQueue) + " grab results from output queue.")

    #Stop the grabbing.
    cam.stop_grabbing();


    print( "Grab using strategy GrabStrategy_LatestImageOnly:" )


       # The GrabStrategy_LatestImageOnly strategy is used. The images are processed
       # in the order of their arrival but only the last received image
       # is kept in the output queue.
       # This strategy can be useful when the acquired images are only displayed on the screen.
       # If the processor has been busy for a while and images could not be displayed automatically
       # the latest image is displayed when processing time is available again.
        # Only the last received image is waiting in the internal output queue
        # and is now retrieved.
        # The grabbing continues in the background, e.g. when using the hardware trigger mode.
    cam.start_grabbing(enum.GrabStrategy_LatestImageOnly)

    #Execute the software trigger, wait actively until the camera accepts the next frame trigger or until the timeout occurs.
    for i in range(3):
        if (cam.wait_for_frame_trigger_ready(2000, enum.TimeoutHandling_ThrowException)):
            cam.execute_software_trigger()
    #Wait for all images.
    PyWaitObject.sleep(3 * 1000)

    #Check whether the grab result is waiting.
    if cam.get_grab_result_wait_object().wait(0):
        print("A grab result waits in the output queue.")

    #Only the last received image is waiting in the internal output queue
            # and is now retrieved.
            # The grabbing continues in the background, e.g. when using the hardware trigger mode.
    nBuffersInQueue = 0;
    while cam.retrieve_result( 0, grabResult, enum.TimeoutHandling_Return):
        print("Skipped " + str(grabResult.number_of_skipped_images) + " images.")
        nBuffersInQueue += 1

    print("Retrieved " + str(nBuffersInQueue) + " grab results from output queue.")

    #Stop the grabbing.
    cam.stop_grabbing();

    print( "Grab using strategy GrabStrategy_LatestImages:" )

   # The GrabStrategy_LatestImages strategy is used. The images are processed
   # in the order of their arrival, but only a number of the images received last
   # are kept in the output queue.

   # The size of the output queue can be adjusted.
   # When using this strategy the OutputQueueSize parameter can be changed during grabbing.
    cam.get_node_map()["OutputQueueSize"] = 2;
    cam.start_grabbing(enum.GrabStrategy_LatestImages)
    #Execute the software trigger, wait actively until the camera accepts the next frame trigger or until the timeout occurs.
    for i in range(3):
        if (cam.wait_for_frame_trigger_ready(2000, enum.TimeoutHandling_ThrowException)):
            cam.execute_software_trigger()

    #Wait for all images.
    PyWaitObject.sleep(3 * 1000)

    #Check whether the grab results are waiting.
    if cam.get_grab_result_wait_object().wait(0):
        print("A grab result waits in the output queue.")

   # Only the images received last are waiting in the internal output queue
   # and are now retrieved.
   # The grabbing continues in the background, e.g. when using the hardware trigger mode.
    nBuffersInQueue = 0;
    while cam.retrieve_result( 0, grabResult, enum.TimeoutHandling_Return):
        print("Skipped " + str(grabResult.number_of_skipped_images) + " images.")
        nBuffersInQueue += 1

    print("Retrieved " + str(nBuffersInQueue) + " grab results from output queue.")
    print("Retrieved " + str(nBuffersInQueue) + " grab results from output queue.")


   # When setting the output queue size to 1 this strategy is equivalent to the GrabStrategy_LatestImageOnly grab strategy.
    cam.get_node_map()["OutputQueueSize"] = 1
   # When setting the output queue size to CInstantCamera::MaxNumBuffer this strategy is equivalent to GrabStrategy_OneByOne.
    cam.get_node_map()["OutputQueueSize"] = cam.get_node_map()["MaxNumBuffer"]
   # Stop the grabbing.
    cam.stop_grabbing()

#to release resource, this function must be called
factory_instant.terminate()