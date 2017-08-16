# /*
#     Note: Before getting started, Basler recommends reading the Programmer's Guide topic
#     in the pylon C++ API documentation that gets installed with pylon.
#     If you are upgrading to a higher major version of pylon, Basler also
#     strongly recommends reading the Migration topic in the pylon C++ API documentation.
#
#     This pythonsample illustrates how to grab and process images using the CInstantCamera class.
#     The images are grabbed and processed asynchronously, i.e.,
#     while the application is processing a buffer, the acquisition of the next buffer is done
#     in parallel.
#
#     The CInstantCamera class uses a pool of buffers to retrieve image data
#     from the camera device. Once a buffer is filled and ready,
#     the buffer can be retrieved from the camera object for processing. The buffer
#     and additional image data are collected in a grab result. The grab result is
#     held by a smart pointer after retrieval. The buffer is automatically reused
#     when explicitly released or when the smart pointer object is destroyed.
# */

import baslerpylon.pylon.tlfactory as tlfactory
import baslerpylon.pylon.usb.basler_usb_instant_camera as BaslerUsbInstantCamera
from baslerpylon.pylon.usb.basler_usb_grab_result import BaslerUsbGrabResult
from PIL import Image
from baslerpylon.pylon.camera_enum import ImageFileFormat_Bmp
import sys, traceback

try:
	countOfImagesToGrab = 5
	factory_instant = tlfactory.TlFactory().get_instance()
	#Print the model name of the camera.
	cam = BaslerUsbInstantCamera.BaslerUsbInstantCamera.create_cam(factory_instant.create_first_device())
	print("Using device " + cam.device_info.model_name)

	# The parameter MaxNumBuffer can be used to control the count of buffers
	# allocated for grabbing. The default value of this parameter is 10.
	cam.get_node_map()["MaxNumBuffer"] = 5

	#Start the grabbing of c_countOfImagesToGrab images.
	# The camera device is parameterized with a default configuration which
	# sets up free-running continuous acquisition.

	cam.open()
	cam.start_grabbing(countOfImagesToGrab)

	grabResult = BaslerUsbGrabResult()

	#Camera.StopGrabbing() is called automatically by the RetrieveResult() method
	# when c_countOfImagesToGrab images have been retrieved.
	while cam.is_grabbing():
		cam.retrieve_result(500, grabResult)
		if grabResult.grab_succeeded():
			#grabResult.save_image(ImageFileFormat_Bmp, str(counter) + "your_file.bmp")
			print("SizeX: " + str(grabResult.width))
			print("SizeY: " + str(grabResult.height))
		else:
			print("Error: " + grabResult.error_code + " " +grabResult.error_description)
except:
	traceback.print_exc(file=sys.stdout)
	
#to release resource, this function must be called
factory_instant.terminate()

