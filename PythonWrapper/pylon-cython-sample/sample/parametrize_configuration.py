# /*
#     Note: Before getting started, Basler recommends reading the Programmer's Guide topic
#     in the pylon C++ API documentation that gets installed with pylon.
#     If you are upgrading to a higher major version of pylon, Basler also
#     strongly recommends reading the Migration topic in the pylon C++ API documentation.
#
#     The instant camera allows to install event handlers for configuration purposes
#     and for handling the grab results. This is very useful for handling standard
#     camera setups and image processing tasks.
#
#     This pythonsample shows how to use configuration event handlers by applying the standard
#     configurations and registering pythonsample configuration event handlers.
#
#     Configuration event handlers are derived from the CConfigurationEventHandler base class.
#     CConfigurationEventHandler provides virtual methods that can be overridden. If the
#     configuration event handler is registered these methods are called when the state of the
#     instant camera objects changes, e.g. when the camera object is opened or closed.
#
#     The standard configuration event handlers override the OnOpened method. The overridden method
#     parametrizes the camera.
#
#     Device specific camera classes, e.g. for GigE cameras, provide specialized
#     event handler base classes, e.g. CBaslerGigEConfigurationEventHandler.
# */

import baslerpylon.pylon.tlfactory as tlfactory
from baslerpylon.pylon.usb.basler_usb_instant_camera import BaslerUsbInstantCamera
from baslerpylon.pylon.software_trigger_configuration import SoftwareTriggerConfiguration
import baslerpylon.pylon.camera_enum as enum
from baslerpylon.pylon.usb.basler_usb_grab_result import BaslerUsbGrabResult
from pylonsample.util.configuration_event_printer import ConfigurationEventPrinter
from pylonsample.util.image_event_printer import ImageEventPrinter
from baslerpylon.pylon.wait_object import PyWaitObject
from baslerpylon.pylon.acquire_continuous_configuration import AcquireContinuousConfiguration
from baslerpylon.pylon.acquire_single_frame_configuration import AcquireSingleFrameConfiguration


factory_instant = tlfactory.TlFactory().get_instance()
cam = BaslerUsbInstantCamera.create_cam(factory_instant.create_first_device())
print("using device " + cam.device_info.model_name)



cam.register_image_event_handler(ImageEventPrinter(), enum.RegistrationMode_ReplaceAll, enum.Cleanup_Delete)
grabResult = BaslerUsbGrabResult()

print("Grab using continuous acquisition:")

#Register the standard configuration event handler for setting up the camera for continuous acquisition.
        # By setting the registration mode to RegistrationMode_ReplaceAll, the new configuration handler replaces the
        # default configuration handler that has been automatically registered when creating the
        # instant camera object.
        # The handler is automatically deleted when deregistered or when the registry is cleared if Cleanup_Delete is specified.
cam.register_configuration(AcquireContinuousConfiguration(), enum.RegistrationMode_ReplaceAll, enum.Cleanup_Delete)

#The camera's Open() method calls the configuration handler's OnOpened() method that
# applies the required parameter modifications.


#The registered configuration event handler has done its parametrization now.
# Additional parameters could be set here.

# Grab some images for demonstration.
cam.start_grabbing(5)

while cam.is_grabbing():
	cam.retrieve_result(500, grabResult, enum.TimeoutHandling_ThrowException)



print("Grab using software trigger mode:")


#Register the standard configuration event handler for setting up the camera for software
# triggering.
# The current configuration is replaced by the software trigger configuration by setting the
# registration mode to RegistrationMode_ReplaceAll.

cam.register_configuration(SoftwareTriggerConfiguration(), enum.RegistrationMode_ReplaceAll, enum.Cleanup_Delete)

#StartGrabbing() calls the camera's Open() automatically if the camera is not open yet.
# The Open method calls the configuration handler's OnOpened() method that
# sets the required parameters for enabling software triggering.

# Grab some images for demonstration.



cam.start_grabbing(5)

while cam.is_grabbing():
    if cam.wait_for_frame_trigger_ready(1000, enum.TimeoutHandling_ThrowException):
        cam.execute_software_trigger()
        cam.retrieve_result(500, grabResult)


#StopGrabbing() is called from RetrieveResult if the number of images
# to grab has been reached. Since the camera was opened by StartGrabbing()
# it is closed by StopGrabbing().

# The CSoftwareTriggerConfiguration, like all standard configurations, is provided as a header file.
# The source code can be copied and modified to meet application specific needs, e.g.
# the CSoftwareTriggerConfiguration class could easily be changed into a hardware trigger configuration.

	
print("Grab using single frame acquisition:")

#Register the standard configuration event handler for configuring single frame acquisition.
# The previous configuration is removed by setting the registration mode to RegistrationMode_ReplaceAll.
cam.register_configuration(AcquireSingleFrameConfiguration(), enum.RegistrationMode_ReplaceAll, enum.Cleanup_Delete)

cam.open()
cam.grab_one(5000,grabResult)


#To continuously grab single images it is much more efficient to open the camera before grabbing.
# Note: The software trigger mode (see above) should be used for grabbing single images if you want to maximize frame rate.
# Now, the camera parameters are applied in the OnOpened method of the configuration object.



# Additional parameters could be set here.
# Grab some images for demonstration.
cam.grab_one(5000,grabResult)
cam.grab_one(5000,grabResult)
cam.grab_one(5000,grabResult)


print("Grab using multiple configuration objects:")

#Register the standard event handler for configuring single frame acquisition.
# The current configuration is replaced by setting the registration mode to RegistrationMode_ReplaceAll.
cam.register_configuration(AcquireSingleFrameConfiguration(), enum.RegistrationMode_Append, enum.Cleanup_Delete)

# Register the handler object and define Cleanup_None so that it is not deleted by the camera object.
# It must be ensured, that the configuration handler "lives" at least until the handler is deregistered!
eventLog = ConfigurationEventPrinter()
cam.register_configuration(eventLog, enum.RegistrationMode_Append, enum.Cleanup_Delete)

#Grab an image for demonstration. Configuration events are printed.
print("Grab, configuration events are printed:" )
cam.grab_one(5000,grabResult)

#deregister the event handler.
cam.deregister_configuration(eventLog)

#Grab an image for demonstration. Configuration events are not printed.
print("Grab, configuration events are not printed:")
cam.grab_one(5000,grabResult)

#to release resource, this function must be called
factory_instant.terminate()