import baslerpylon.pylon.tlfactory as tlfactory
from baslerpylon.pylon.usb.basler_usb_instant_camera import BaslerUsbInstantCamera
from baslerpylon.pylon.software_trigger_configuration import SoftwareTriggerConfiguration
import baslerpylon.pylon.camera_enum as enum
from baslerpylon.pylon.usb.basler_usb_grab_result import BaslerUsbGrabResult
from pylonsample.util.configuration_event_printer import ConfigurationEventPrinter
from pylonsample.util.image_event_printer import  ImageEventPrinter
from baslerpylon.pylon.wait_object import PyWaitObject
from baslerpylon.pylon.acquire_continuous_configuration import AcquireContinuousConfiguration
from baslerpylon.pylon.acquire_single_frame_configuration import AcquireSingleFrameConfiguration

def adjust( val,  minimum,  maximum,  inc):
	#Check the input parameters.
	if inc <= 0:
		raise Exception("Unexpected increment " + str(inc))
	if minimum > maximum:
		raise Exception("minimum bigger than maximum. ")

	#Check the lower bound.
	if val<minimum:
		return minimum

	#Check the upper bound.
	if val > maximum:
		return maximum

	#Check the increment.
	if inc == 1:
		#Special case: all values are valid.
		return val;
	else:
		#The value must be min + (n * inc).
		#Due to the integer division, the value will be rounded down.
		return minimum + ( ((val - minimum) / inc) * inc )

factory_instant = tlfactory.TlFactory().get_instance()

# Create an instant camera object with the first found camera device matching the specified device class.
cam = BaslerUsbInstantCamera.create_cam(factory_instant.create_first_device())

#Open the camera for accessing the parameters.
cam.open()

#Get camera device information.
print( "Camera Device Information")
print("=========================")
print("Vendor " + cam.get_node_map()["DeviceVendorName"])
print("Vendor " + cam.get_node_map()["DeviceModelName"])
print("Vendor " + cam.get_node_map()["DeviceFirmwareVersion"])

#Camera settings.
print( "Camera Device Settings")
print("=========================")

#Set the AOI:
#On some cameras the Offsets are read-only,
#so we check whether we can write a value. Otherwise, we would get an exception.
#GenApi has some convenience predicates to check this easily.

if cam.get_node_map().is_writable("OffsetX"):
	cam.get_node_map()["OffsetX"] = cam.get_node_map().get_node("OffsetX").min

if cam.get_node_map().is_writable("OffsetY"):
	cam.get_node_map()["OffsetY"] = cam.get_node_map().get_node("OffsetY").min

#Some properties have restrictions. Use GetInc/GetMin/GetMax to make sure you set a valid value.
newWidth = 202
newWidth = adjust(newWidth, cam.get_node_map().get_node("Width").min, cam.get_node_map().get_node("Width").max, cam.get_node_map().get_node("Width").inc)

newHeight = 101
newHeight = adjust(newHeight, cam.get_node_map().get_node("Height").min,cam.get_node_map().get_node("Height").max,cam.get_node_map().get_node("Height").inc)

cam.get_node_map()["Width"] = newWidth
cam.get_node_map()["Height"] = newHeight

print("OffsetX: " + str(cam.get_node_map()["OffsetX"]))
print("OffsetY: " + str(cam.get_node_map()["OffsetY"]))
print("Width: " + str(cam.get_node_map()["Width"]))
print("Height: " + str(cam.get_node_map()["Height"]))




#Remember the current pixel format.
oldPixelFormat = (cam.get_node_map()["PixelFormat"])
print("Old PixelFormat  : " + cam.get_node_map()["PixelFormat"])

if cam.get_node_map().get_node("PixelFormat").get_entry("Mono8"):
	cam.get_node_map()["PixelFormat"] = "Mono8"
	print("New PixelFormat  : " + cam.get_node_map()["PixelFormat"])

if cam.get_node_map().is_writable("GainAuto"):
	cam.get_node_map()["GainAuto"] = "Off"


newGain =  (cam.get_node_map().get_node("Gain").min + (cam.get_node_map().get_node("Gain").max - cam.get_node_map().get_node("Gain").min) / 2)
cam.get_node_map()["Gain"] = newGain
print("Gain 50% "  + str(cam.get_node_map().get_node("Gain").get_value())  + " .min: " + str(cam.get_node_map().get_node("Gain").min) + " max: " + str(cam.get_node_map().get_node("Gain").max))

#restore the old pixel format
cam.get_node_map()["PixelFormat"] = oldPixelFormat

#Close the camera
cam.close()

#to release resource, this function must be called
factory_instant.terminate()