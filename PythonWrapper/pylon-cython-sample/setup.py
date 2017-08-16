from setuptools import setup, find_packages
from Cython.Distutils import build_ext, Extension

import subprocess
import os
import os.path
import sys
import numpy
import glob

config = dict()
#pylon_dir = "Z:\Documents\IDP\Basler\pylon 5"
#python_dir = "C:\Anaconda\include"
#pylon_cython_dir = "Z:\\Documents\\IDP\\IDP2016-Duong-ImageProcessingLibraries\\PythonWrapper\\pylon-cython"
pylon_dir = "E:\\Program_Files\\Basler_Pylon5"
python_dir = "C:\Anaconda\include"
pylon_cython_dir = "E:\\user\\yduong\\IDP\\IDP2016-Duong-ImageProcessingLibraries\\PythonWrapper\\pylon-cython"
if not os.path.isdir(pylon_dir):
	raise RuntimeError('Pylon directory not found')

if not os.path.isdir(os.path.join(pylon_dir, 'Development')):
	raise RuntimeError('You need to install Pylon with the development options')

arch = 'x64' if 'PROCESSOR_ARCHITEW6432' in os.environ or os.environ['PROCESSOR_ARCHITECTURE'].endswith('64') else 'Win32'


config['library_dirs'] = [os.path.join(pylon_dir, 'Runtime', arch),
								   os.path.join(pylon_dir, 'Development', 'lib', arch)]
config['libraries'] = list([_[:-4] for _ in os.listdir(os.path.join(pylon_dir, 'Development', 'lib', arch))
									 if _.endswith('.lib')])

config['include_dirs'] = [os.path.join(pylon_dir, 'Development', 'include'),os.path.join(pylon_cython_dir,"cython\\pxd\\cythoninterface"),
						  os.path.join(pylon_cython_dir,"cython\\pxd\\cinterface\\baslerpylon."),os.path.join(pylon_cython_dir,"cython\c++"), python_dir, "cython\pxd", "cython\c++"]
config['language'] = 'c++'
config['include_dirs'].append(numpy.get_include())

ext_modules = [Extension('pylonsample.sample_camera_event_handler', sources = ["cython/pyx/pylonsample/sample_camera_event_handler.pyx","cython/c++/CSampleCameraEventHandler.cpp"], **config),
              Extension('pylonsample.sample_chunk_ts_image_event_handler', sources = ["cython/pyx/pylonsample/sample_chunk_ts_image_event_handler.pyx","cython/c++/CSampleChunkTSImageEventHandler.cpp"], **config),
			   Extension('pylonsample.sample_image_event_handler',sources=["cython/pyx/pylonsample/sample_image_event_handler.pyx", "cython/c++/CSampleImageEventHandler.cpp"], **config),
			   Extension('pylonsample.util.configuration_event_printer',sources=["cython/pyx/pylonsample/util/configuration_event_printer.pyx","cython/c++/util/Util.cpp"], **config),
			   Extension('pylonsample.util.image_event_printer',sources=["cython/pyx/pylonsample/util/image_event_printer.pyx","cython/c++/util/Util.cpp"], **config),
			   Extension('pylonsample.util.camera_event_printer', sources=["cython/pyx/pylonsample/util/camera_event_printer.pyx", "cython/c++/util/Util.cpp"], **config),
			   Extension('pylonsample.sample_exposure_camera_event_handler',sources=["cython/pyx/pylonsample/sample_exposure_camera_event_handler.pyx","cython/c++/SampleExposureCameraEventHandler.cpp"], **config),
			   Extension('pylonsample.sample_exposure_image_event_handler', sources=["cython/pyx/pylonsample/sample_exposure_image_event_handler.pyx","cython/c++/SampleExposureImageEventHandler.cpp"], **config)
 ]



setup(name='pylonsample',cmdclass={'build_ext': build_ext},
      ext_modules=ext_modules,
	  packages=find_packages()
      )

	  
	  


