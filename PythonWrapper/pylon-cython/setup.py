from setuptools import setup, find_packages
from Cython.Distutils import build_ext, Extension

import os.path
import numpy

config = dict()
pylon_dir = "E:\\Program_Files\\Basler_Pylon5"
extra_include_dir = "E:\\User\\yduong\\IDP\\IDP2016-Duong-ImageProcessingLibraries\\include"
extra_lib_dir = "E:\\User\\yduong\\IDP\\IDP2016-Duong-ImageProcessingLibraries\\lib"
c_code_dir = "E:\\User\\yduong\\IDP\\IDP2016-Duong-ImageProcessingLibraries\\PylonApplications\\PylonImageApp"

if not os.path.isdir(pylon_dir):
    raise RuntimeError('Pylon directory not found')

if not os.path.isdir(os.path.join(pylon_dir, 'Development')):
    raise RuntimeError('You need to install Pylon with the development options')

arch = 'x64' if 'PROCESSOR_ARCHITEW6432' in os.environ or os.environ['PROCESSOR_ARCHITECTURE'].endswith(
    '64') else 'Win32'

config['library_dirs'] = [os.path.join(pylon_dir, 'Runtime', arch),
                          os.path.join(pylon_dir, 'Development', 'lib', arch),os.path.join(extra_lib_dir, 'boost'),extra_lib_dir
                          ]
config['libraries'] = list([_[:-4] for _ in os.listdir(os.path.join(pylon_dir, 'Development', 'lib', arch))
                            if _.endswith('.lib')])

config['libraries'].append("dbghelp")

print(config['libraries'])
# config['libraries'].append("C:\\Users\\duong\\Documents\\include\\lib\\libboost_thread-vc140-mt-1_62")
config['include_dirs'] = [os.path.join(pylon_dir, 'Development', 'include'), "cython\\pxd\\cythoninterface","cython\\pxd\\cythoninterface",
                          "cython\\pxd\\cinterface\\baslerpylon","cython\\pxd\\cinterface",os.path.join(c_code_dir, 'source') ,os.path.join(c_code_dir, 'header'),
						   extra_include_dir,os.path.join(extra_include_dir, 'boost_1_63_0')]
config['language'] = 'c++'
config['extra_compile_args'] = ['/EHsc']  ##important for boost
config['include_dirs'].append(numpy.get_include())

ext_modules = [
    Extension('baslerpylon.pylon.usb.basler_usb_device_info', ["cython/pyx/baslerpylon/pylon/usb/basler_usb_device_info.pyx"], **config),
    Extension('baslerpylon.pylon.container', ["cython/pyx/baslerpylon/pylon/container.pyx"], **config),
    Extension('baslerpylon.genapi.node', ["cython/pyx/baslerpylon/genapi/node.pyx"], **config),
    Extension('baslerpylon.genapi.boolean_node', ["cython/pyx/baslerpylon/genapi/boolean_node.pyx"], **config),
    Extension('baslerpylon.genapi.integer_node', ["cython/pyx/baslerpylon/genapi/integer_node.pyx"], **config),
    Extension('baslerpylon.genapi.string_node', ["cython/pyx/baslerpylon/genapi/string_node.pyx"], **config),
    Extension('baslerpylon.genapi.register_node', ["cython/pyx/baslerpylon/genapi/register_node.pyx"], **config),
    Extension('baslerpylon.genapi.float_node', ["cython/pyx/baslerpylon/genapi/float_node.pyx"], **config),
    Extension('baslerpylon.genapi.command_node', ["cython/pyx/baslerpylon/genapi/command_node.pyx"], **config),
    Extension('baslerpylon.genapi.enumentry_node', ["cython/pyx/baslerpylon/genapi/enumentry_node.pyx"], **config),
    Extension('baslerpylon.genapi.enumeration_node', ["cython/pyx/baslerpylon/genapi/enumeration_node.pyx"], **config),
    Extension('baslerpylon.genapi.enumentry_node', ["cython/pyx/baslerpylon/genapi/enumentry_node.pyx"], **config),
    Extension('baslerpylon.genapi.value_node', ["cython/pyx/baslerpylon/genapi/value_node.pyx"], **config),
    Extension('baslerpylon.pylon.property_map', ["cython/pyx/baslerpylon/pylon/property_map.pyx"], **config),
    Extension('baslerpylon.pylon.image', ["cython/pyx/baslerpylon/pylon/image.pyx"], **config),
    Extension('baslerpylon.pylon.device', ["cython/pyx/baslerpylon/pylon/device.pyx"], **config),
    Extension('baslerpylon.pylon.wait_object', ["cython/pyx/baslerpylon/pylon/wait_object.pyx"], **config),
    Extension('baslerpylon.pylon.configuration_event_handler', ["cython/pyx/baslerpylon/pylon/configuration_event_handler.pyx"], **config),
    Extension('baslerpylon.pylon.acquire_continuous_configuration', ["cython/pyx/baslerpylon/pylon/acquire_continuous_configuration.pyx"],
              **config),
    Extension('baslerpylon.pylon.acquire_single_frame_configuration', ["cython/pyx/baslerpylon/pylon/acquire_single_frame_configuration.pyx"],
              **config),
    Extension('baslerpylon.pylon.software_trigger_configuration', ["cython/pyx/baslerpylon/pylon/software_trigger_configuration.pyx"],
              **config),
    Extension('baslerpylon.pylon.image_event_handler', ["cython/pyx/baslerpylon/pylon/image_event_handler.pyx"], **config),
    Extension('baslerpylon.pylon.camera_event_handler', ["cython/pyx/baslerpylon/pylon/camera_event_handler.pyx"], **config),
    Extension('baslerpylon.pylon.usb.basler_usb_grab_result', ["cython/pyx/baslerpylon/pylon/usb/basler_usb_grab_result.pyx"], **config),
    Extension('baslerpylon.pylon.tlfactory', ["cython/pyx/baslerpylon/pylon/tlfactory.pyx"], **config),
    Extension('baslerpylon.pylon.camera_enum', ["cython/pyx/baslerpylon/pylon/camera_enum.pyx"], **config),
    Extension('baslerpylon.pylon.usb.basler_usb_instant_camera', ["cython/pyx/baslerpylon/pylon/usb/basler_usb_instant_camera.pyx"], **config),
    Extension('baslerpylon.pylon.usb.basler_usb_image_event_handler', ["cython/pyx/baslerpylon/pylon/usb/basler_usb_image_event_handler.pyx"],
              **config),
    #Extension('pylon.usb.basler_usb_instant_camera_array', ["cython/pyx/pylon/usb/basler_usb_instant_camera_array.pyx"], **config),
    Extension('baslerpylon.pylon.usb.basler_usb_configuration_event_handler',["cython/pyx/baslerpylon/pylon/usb/basler_usb_configuration_event_handler.pyx"], **config),
    Extension('baslerpylon.pylon.usb.basler_usb_camera_event_handler', ["cython/pyx/baslerpylon/pylon/usb/basler_usb_camera_event_handler.pyx"],
              **config)]
#	    Extension('pylon.utility', ["cython/pyx/utility/pylonutility.pyx"], **config)]
#		Extension('pylon.app.camerautility', ["cython/pyx/app/camerautility.pyx"], **config)]




setup(name='baslerpylon',
      cmdclass={'build_ext': build_ext},
      ext_modules=ext_modules,
      packages=find_packages()
      )




