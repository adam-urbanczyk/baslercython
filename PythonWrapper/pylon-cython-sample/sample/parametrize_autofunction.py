
# ParametrizeCamera_AutoFunctions_Usb.cpp
# /*
#     Note: Before getting started, Basler recommends reading the Programmer's Guide topic
#     in the pylon C++ API documentation that gets installed with pylon.
#     If you are upgrading to a higher major version of pylon, Basler also
#     strongly recommends reading the Migration topic in the pylon C++ API documentation.
#
#     This pythonsample illustrates how to use the Auto Functions feature of Basler USB cameras.
#
#     Features, like 'Gain', are named according to the Standard Feature Naming Convention (SFNC).
#     The SFNC defines a common set of features, their behavior, and the related parameter names.
#     This ensures the interoperability of cameras from different camera vendors. Cameras compliant
#     with the USB 3 Vision standard are based on the SFNC version 2.0.
#     Basler GigE and Firewire cameras are based on previous SFNC versions.
#     Accordingly, the behavior of these cameras and some parameters names will be different.
#     That's why this pythonsample is different from the pythonsample for Firewire and GigE cameras in
#     ParametrizeCamera_AutoFunctions.cpp
# */

import baslerpylon.pylon.tlfactory as tlfactory
from baslerpylon.pylon.usb.basler_usb_instant_camera import BaslerUsbInstantCamera
import baslerpylon.pylon.camera_enum as enum
from baslerpylon.pylon.usb.basler_usb_grab_result import BaslerUsbGrabResult
from baslerpylon.pylon.wait_object import PyWaitObject
from baslerpylon.pylon.acquire_single_frame_configuration import AcquireSingleFrameConfiguration


def AutoGainOnce(cam):
	#Check whether the gain auto function is available
	if not cam.get_node_map().is_writable("GainAuto"):
		print( "The camera does not support Gain Auto.")
		return

	#Maximize the grabbed image area of interest (Image AOI).
	if cam.get_node_map().is_writable("OffsetX"):
		cam.get_node_map()["OffsetX"] = cam.get_node_map().get_node("OffsetX").min

	if cam.get_node_map().is_writable("OffsetY"):
		cam.get_node_map()["OffsetY"] = cam.get_node_map().get_node("OffsetY").min

	cam.get_node_map()["Width"] = cam.get_node_map().get_node("Width").max
	cam.get_node_map()["Height"] = cam.get_node_map().get_node("Height").max

	if cam.get_node_map().is_available("AutoFunctionROISelector"):
		# Set the Auto Function ROI for luminance statistics.
		#We want to use ROI1 for gathering the statistics
		cam.get_node_map()["AutoFunctionROISelector"] = "ROI1"
		cam.get_node_map()["AutoFunctionROIUseBrightness"] = True #ROI 1 is used for brightness control
		cam.get_node_map()["AutoFunctionROISelector"] = "ROI2"
		cam.get_node_map()["AutoFunctionROIUseBrightness"] = False #ROI 2 is not used for brightness control

		#Set the ROI (in this example the complete sensor is used)
		cam.get_node_map()["AutoFunctionROISelector"] = "ROI1" # configure ROI 1
		cam.get_node_map()["AutoFunctionROIOffsetX"] = 0
		cam.get_node_map()["AutoFunctionROIOffsetY"] = 0
		cam.get_node_map()["AutoFunctionROIWidth"] = cam.get_node_map().get_node("Width").max
		cam.get_node_map()["AutoFunctionROIHeight"] = cam.get_node_map().get_node("Height").max

	#Set the target value for luminance control.
    # A value of 0.3 means that the target brightness is 30 % of the maximum brightness of the raw pixel value read out from the sensor.
    # A value of 0.4 means 40 % and so forth.
	cam.get_node_map()["AutoTargetBrightness"] = 0.3

	#We are going to try GainAuto = Once.
	print( "Trying 'GainAuto = Once'.")
	print("Initial Gain = " + str(cam.get_node_map()["Gain"]))

	#Set the gain ranges for luminance control.
	cam.get_node_map()["AutoGainLowerLimit"] = cam.get_node_map().get_node("Gain").min
	cam.get_node_map()["AutoGainUpperLimit"] = cam.get_node_map().get_node("Gain").max
	
	cam.get_node_map()["GainAuto"] = "Once"

	#When the "once" mode of operation is selected,
    # the parameter values are automatically adjusted until the related image property
    # reaches the target value. After the automatic parameter value adjustment is complete, the auto
    # function will automatically be set to "off" and the new parameter value will be applied to the
    # subsequently grabbed images.

	n=0
	while cam.get_node_map()["GainAuto"] == "Off":
		grabResult = BaslerUsbGrabResult()
		cam.grab_one(5000, grabResult)
		PyWaitObject.sleep( 1000)
		n+=1
		if n>100:
			raise Exception( "The adjustment of auto gain did not finish.")

	print("GainAuto went back to 'Off' after ")
	print("Initial Gain = " + str(cam.get_node_map()["Gain"]))


def AutoGainContinuous(cam):
	# Check whether the gain auto function is available
	if not cam.get_node_map().is_writable("GainAuto"):
		print("The camera does not support Gain Auto.")
		return

	# Maximize the grabbed image area of interest (Image AOI).
	if cam.get_node_map().is_writable("OffsetX"):
		cam.get_node_map()["OffsetX"] = cam.get_node_map().get_node("OffsetX").min

	if cam.get_node_map().is_writable("OffsetY"):
		cam.get_node_map()["OffsetY"] = cam.get_node_map().get_node("OffsetY").min

	cam.get_node_map()["Width"] = cam.get_node_map().get_node("Width").max
	cam.get_node_map()["Height"] = cam.get_node_map().get_node("Height").max

	if cam.get_node_map().is_available("AutoFunctionROISelector"):
		# Set the Auto Function ROI for luminance statistics.
		# We want to use ROI1 for gathering the statistics
		cam.get_node_map()["AutoFunctionROISelector"] = "ROI1"
		cam.get_node_map()["AutoFunctionROIUseBrightness"] = True  # ROI 1 is used for brightness control
		cam.get_node_map()["AutoFunctionROISelector"] = "ROI2"
		cam.get_node_map()["AutoFunctionROIUseBrightness"] = False  # ROI 2 is not used for brightness control

		# Set the ROI (in this example the complete sensor is used)
		cam.get_node_map()["AutoFunctionROISelector"] = "ROI1"  # configure ROI 1
		cam.get_node_map()["AutoFunctionROIOffsetX"] = 0
		cam.get_node_map()["AutoFunctionROIOffsetY"] = 0
		cam.get_node_map()["AutoFunctionROIWidth"] = cam.get_node_map().get_node("Width").max
		cam.get_node_map()["AutoFunctionROIHeight"] = cam.get_node_map().get_node("Height").max

	# Set the target value for luminance control.
	# A value of 0.3 means that the target brightness is 30 % of the maximum brightness of the raw pixel value read out from the sensor.
	# A value of 0.4 means 40 % and so forth.
	cam.get_node_map()["AutoTargetBrightness"] = 0.3

	# We are going to try GainAuto = Continuous.
	print("Trying 'GainAuto = Continuous'.")
	print("Initial Gain = " + str(cam.get_node_map()["Gain"]))


	cam.get_node_map()["GainAuto"] = "Continuous"

	#When "continuous" mode is selected, the parameter value is adjusted repeatedly while images are acquired.
    # Depending on the current frame rate, the automatic adjustments will usually be carried out for
    # every or every other image unless the cameras micro controller is kept busy by other tasks.
    # The repeated automatic adjustment will proceed until the "once" mode of operation is used or
    # until the auto function is set to "off", in which case the parameter value resulting from the latest
    # automatic adjustment will operate unless the value is manually adjusted.
	for i in range(20):
		grabResult = BaslerUsbGrabResult()
		cam.grab_one(5000, grabResult)
		PyWaitObject.sleep(1000)

	cam.get_node_map()["GainAuto"] = "Off"
	print("Final Gain = " + str(cam.get_node_map()["Gain"]))

def AutoExposureContinuous(cam):
	# Check whether the ExposureAuto function is available
	if not cam.get_node_map().is_writable("ExposureAuto"):
		print("The camera does not support ExposureAuto.")
		return

	# Maximize the grabbed image area of interest (Image AOI).
	if cam.get_node_map().is_writable("OffsetX"):
		cam.get_node_map()["OffsetX"] = cam.get_node_map().get_node("OffsetX").min

	if cam.get_node_map().is_writable("OffsetY"):
		cam.get_node_map()["OffsetY"] = cam.get_node_map().get_node("OffsetY").min

	cam.get_node_map()["Width"] = cam.get_node_map().get_node("Width").max
	cam.get_node_map()["Height"] = cam.get_node_map().get_node("Height").max

	if cam.get_node_map().is_available("AutoFunctionROISelector"):
		# Set the Auto Function ROI for luminance statistics.
		# We want to use ROI1 for gathering the statistics
		cam.get_node_map()["AutoFunctionROISelector"] = "ROI1"
		cam.get_node_map()["AutoFunctionROIUseBrightness"] = True  # ROI 1 is used for brightness control
		cam.get_node_map()["AutoFunctionROISelector"] = "ROI2"
		cam.get_node_map()["AutoFunctionROIUseBrightness"] = False  # ROI 2 is not used for brightness control

		# Set the ROI (in this example the complete sensor is used)
		cam.get_node_map()["AutoFunctionROISelector"] = "ROI1"  # configure ROI 1
		cam.get_node_map()["AutoFunctionROIOffsetX"] = 0
		cam.get_node_map()["AutoFunctionROIOffsetY"] = 0
		cam.get_node_map()["AutoFunctionROIWidth"] = cam.get_node_map().get_node("Width").max
		cam.get_node_map()["AutoFunctionROIHeight"] = cam.get_node_map().get_node("Height").max

	# Set the target value for luminance control.
	# A value of 0.3 means that the target brightness is 30 % of the maximum brightness of the raw pixel value read out from the sensor.
	# A value of 0.4 means 40 % and so forth.
	cam.get_node_map()["AutoTargetBrightness"] = 0.3

	# We are going to try GainAuto = Continuous.
	print("ExposureAuto 'GainAuto = Continuous'.")
	print("Initial exposure time = " + str(cam.get_node_map()["ExposureTime"]))


	cam.get_node_map()["ExposureAuto"] = "Continuous"

	#When "continuous" mode is selected, the parameter value is adjusted repeatedly while images are acquired.
    # Depending on the current frame rate, the automatic adjustments will usually be carried out for
    # every or every other image, unless the cameras microcontroller is kept busy by other tasks.
    # The repeated automatic adjustment will proceed until the "once" mode of operation is used or
    # until the auto function is set to "off", in which case the parameter value resulting from the latest
    # automatic adjustment will operate unless the value is manually adjusted.
    # For demonstration purposes, we will use only 20 images.
	for i in range(20):
		grabResult = BaslerUsbGrabResult()
		cam.grab_one(5000, grabResult)
		PyWaitObject.sleep(1000)

	cam.get_node_map()["ExposureAuto"] = "Off"
	print("Final exposure time  = " + str(cam.get_node_map()["ExposureTime"]))

def AutoExposureOnce(cam):
	# Check whether the ExposureAuto function is available
	if not cam.get_node_map().is_writable("ExposureAuto"):
		print("The camera does not support ExposureAuto.")
		return

	# Maximize the grabbed image area of interest (Image AOI).
	if cam.get_node_map().is_writable("OffsetX"):
		cam.get_node_map()["OffsetX"] = cam.get_node_map().get_node("OffsetX").min

	if cam.get_node_map().is_writable("OffsetY"):
		cam.get_node_map()["OffsetY"] = cam.get_node_map().get_node("OffsetY").min

	cam.get_node_map()["Width"] = cam.get_node_map().get_node("Width").max
	cam.get_node_map()["Height"] = cam.get_node_map().get_node("Height").max

	if cam.get_node_map().is_available("AutoFunctionROISelector"):
		# Set the Auto Function ROI for luminance statistics.
		# We want to use ROI1 for gathering the statistics
		cam.get_node_map()["AutoFunctionROISelector"] = "ROI1"
		cam.get_node_map()["AutoFunctionROIUseBrightness"] = True  # ROI 1 is used for brightness control
		cam.get_node_map()["AutoFunctionROISelector"] = "ROI2"
		cam.get_node_map()["AutoFunctionROIUseBrightness"] = False  # ROI 2 is not used for brightness control

		# Set the ROI (in this example the complete sensor is used)
		cam.get_node_map()["AutoFunctionROISelector"] = "ROI1"  # configure ROI 1
		cam.get_node_map()["AutoFunctionROIOffsetX"] = 0
		cam.get_node_map()["AutoFunctionROIOffsetY"] = 0
		cam.get_node_map()["AutoFunctionROIWidth"] = cam.get_node_map().get_node("Width").max
		cam.get_node_map()["AutoFunctionROIHeight"] = cam.get_node_map().get_node("Height").max

	# Set the target value for luminance control.
	# A value of 0.3 means that the target brightness is 30 % of the maximum brightness of the raw pixel value read out from the sensor.
	# A value of 0.4 means 40 % and so forth.
	cam.get_node_map()["AutoTargetBrightness"] = 0.3

	# We are going to try GainAuto = Continuous.
	print("Trying 'ExposureAuto = Once'.")
	print("Initial exposure time = " + str(cam.get_node_map()["ExposureTime"]))


	cam.get_node_map()["ExposureAuto"] = "Once"

	#When the "once" mode of operation is selected,
    # the parameter values are automatically adjusted until the related image property
    # reaches the target value. After the automatic parameter value adjustment is complete, the auto
    # function will automatically be set to "off", and the new parameter value will be applied to the
    # subsequently grabbed images.
	n=0
	while cam.get_node_map()["ExposureAuto"] == "Off":
		grabResult = BaslerUsbGrabResult()
		cam.grab_one(5000, grabResult)
		PyWaitObject.sleep(1000)
		n+=1
		if n>100:
			raise Exception( "The adjustment of auto exposure did not finish.")

	print("ExposureAuto went back to 'Off' after " + str(n) + " frames")
	print("Final exposure time  = " + str(cam.get_node_map()["ExposureTime"]))


def AutoWhiteBalance(cam):
	# Check whether the Balance White Auto feature is available.
	if not cam.get_node_map().is_writable("BalanceWhiteAuto"):
		print("The camera does not support Balance White Auto.")
		return

	# Maximize the grabbed image area of interest (Image AOI).
	if cam.get_node_map().is_writable("OffsetX"):
		cam.get_node_map()["OffsetX"] = cam.get_node_map().get_node("OffsetX").min

	if cam.get_node_map().is_writable("OffsetY"):
		cam.get_node_map()["OffsetY"] = cam.get_node_map().get_node("OffsetY").min

	cam.get_node_map()["Width"] = cam.get_node_map().get_node("Width").max
	cam.get_node_map()["Height"] = cam.get_node_map().get_node("Height").max

	if cam.get_node_map().is_available("AutoFunctionROISelector"):
		# Set the Auto Function ROI for luminance statistics.
		# We want to use ROI2 for gathering the statistics
		cam.get_node_map()["AutoFunctionROISelector"] = "ROI1"
		cam.get_node_map()["AutoFunctionROIUseBrightness"] = False  # ROI 1 is used for brightness control
		cam.get_node_map()["AutoFunctionROISelector"] = "ROI2"
		cam.get_node_map()["AutoFunctionROIUseBrightness"] = True  # ROI 2 is not used for brightness control

		# Set the Auto Function AOI for white balance statistics.
        # Currently, AutoFunctionROISelector_ROI2 is predefined to gather
        # white balance statistics.
		cam.get_node_map()["AutoFunctionROISelector"] = "ROI2"  # configure ROI 1
		cam.get_node_map()["AutoFunctionROIOffsetX"] = 0
		cam.get_node_map()["AutoFunctionROIOffsetY"] = 0
		cam.get_node_map()["AutoFunctionROIWidth"] = cam.get_node_map().get_node("Width").max
		cam.get_node_map()["AutoFunctionROIHeight"] = cam.get_node_map().get_node("Height").max

	print("Trying 'BalanceWhiteAuto = Once'.")
	print("Initial balance ratio: ")

	cam.get_node_map()["BalanceRatioSelector"] = "Red"
	print("R = " + str(cam.get_node_map()["BalanceRatio"]))
	cam.get_node_map()["BalanceRatioSelector"] = "Green"
	print("G = " + str(cam.get_node_map()["BalanceRatio"]))
	cam.get_node_map()["BalanceRatioSelector"] = "Blue"
	print("B = " + str(cam.get_node_map()["BalanceRatio"]))

	cam.get_node_map()["BalanceWhiteAuto"] = "Once"

	# When the "once" mode of operation is selected,
    # the parameter values are automatically adjusted until the related image property
    # reaches the target value. After the automatic parameter value adjustment is complete, the auto
    # function will automatically be set to "off" and the new parameter value will be applied to the
    # subsequently grabbed images.
	n=0
	while cam.get_node_map()["BalanceWhiteAuto"] == "Off":
		grabResult = BaslerUsbGrabResult()
		cam.grab_one(5000, grabResult)
		PyWaitObject.sleep(1000)
		n+=1
		if n>100:
			raise Exception( "The adjustment of auto white balance did not finish.")

	print("BalanceWhiteAuto went back to 'Off' after " + str(n) + " frames")
	print("Final balance ratio: ")
	cam.get_node_map()["BalanceRatioSelector"] = "Red"
	print("R = " + str(cam.get_node_map()["BalanceRatio"]))
	cam.get_node_map()["BalanceRatioSelector"] = "Green"
	print("G = " + str(cam.get_node_map()["BalanceRatio"]))
	cam.get_node_map()["BalanceRatioSelector"] = "Blue"
	print("B = " + str(cam.get_node_map()["BalanceRatio"]))

factory_instant = tlfactory.TlFactory().get_instance()

# Create an instant camera object with the first found camera device matching the specified device class.
cam = BaslerUsbInstantCamera.create_cam(factory_instant.create_first_device())

#Print the name of the used camera
print("using device " + cam.device_info.model_name)

#Check to see if the camera supportsAutoFunction ROI parameters.
# Former firmware versions supporting the AutoFunctionAOI parameters are no longer supported by this pythonsample.

if not cam.get_node_map().is_available("AutoFunctionROISelector") and cam.get_node_map().is_available("AutoFunctionAOISelector"):
	print("This camera only supports the deprecated AutoFunctionAOIxxxx camera parameters." )
	print("If you want to configure the regions used by the auto functions on this camera, use")
	print("the AutoFunctionAOIxxxx parameters instead of the AutoFunctionROIxxxx parameters.")
	input("Press Enter to continue...")
	exit()

# Register the standard event handler for configuring single frame acquisition.
# This overrides the default configuration as all event handlers are removed by setting the registration mode to RegistrationMode_ReplaceAll.
# Please note that the camera device auto functions do not require grabbing by single frame acquisition.
# All available acquisition modes can be used.

#cam.register_configuration(AcquireSingleFrameConfiguration(), enum.RegistrationMode_Append, enum.Cleanup_Delete)


#Open the camera.
cam.open()


#Turn test image off.
if cam.get_node_map().is_available("TestImageSelector"):
	cam.get_node_map()["TestImageSelector"] = "Off"


if cam.get_node_map()["DeviceScanType"] == "Areascan":
	cam.get_node_map()["Gain"] = cam.get_node_map().get_node("Gain").max
	AutoGainOnce(cam)
	#input("Press Enter to continue...")
	#Carry out luminance control by using the "continuous" gain auto function.
    # For demonstration purposes only, set the gain to an initial value.
	#cam.get_node_map()["Gain"] = cam.get_node_map().get_node("Gain").max
	AutoGainContinuous(cam)
	#input("Press Enter to continue...")

	#For demonstration purposes only, set the exposure time to an initial value.
	cam.get_node_map()["ExposureTime"] = cam.get_node_map().get_node("ExposureTime").min

	#Carry out luminance control by using the "once" exposure auto function.
	AutoExposureOnce(cam)
	#input("Press Enter to continue...")

	#For demonstration purposes only, set the exposure time to an initial value.
	#cam.get_node_map()["ExposureTime"] = cam.get_node_map().get_node("ExposureTime").min

	#Carry out luminance control by using the "continuous" exposure auto function.
	AutoExposureContinuous(cam)

	#input("Press Enter to continue...")
	#for demonstration purposes only, set the initial balance ratio values:
	cam.get_node_map()["BalanceRatioSelector"] = "Red"
	cam.get_node_map()["BalanceRatio"] = 3.14
	cam.get_node_map()["BalanceRatioSelector"] = "Green"
	cam.get_node_map()["BalanceRatio"] = 0.5
	cam.get_node_map()["BalanceRatioSelector"] = "Blue"
	cam.get_node_map()["BalanceRatio"] =0.125

	#Carry out white balance using the balance white auto function.
	AutoWhiteBalance(cam)

cam.close()

#to release resource, this function must be called
factory_instant.terminate()
