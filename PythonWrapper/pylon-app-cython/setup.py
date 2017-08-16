from setuptools import setup, find_packages
from Cython.Distutils import build_ext, Extension

import subprocess
import os
import os.path
import sys
import numpy
import glob

config = dict()
pylon_dir = "E:\\Program_Files\\Basler_Pylon5"
extra_include_dir = "E:\\User\\yduong\\IDP\\IDP2016-Duong-ImageProcessingLibraries\\include"
extra_lib_dir = "E:\\User\\yduong\\IDP\\IDP2016-Duong-ImageProcessingLibraries\\lib"
c_code_dir = "E:\\User\\yduong\\IDP\\IDP2016-Duong-ImageProcessingLibraries\\PylonApplications"

if not os.path.isdir(pylon_dir):
	raise RuntimeError('Pylon directory not found')

if not os.path.isdir(os.path.join(pylon_dir, 'Development')):
	raise RuntimeError('You need to install Pylon with the development options')

arch = 'x64' if 'PROCESSOR_ARCHITEW6432' in os.environ or os.environ['PROCESSOR_ARCHITECTURE'].endswith('64') else 'Win32'



config['library_dirs'] = [os.path.join(pylon_dir, 'Runtime', arch),
								   os.path.join(pylon_dir, 'Development', 'lib', arch),os.path.join(extra_lib_dir, 'boost'),extra_lib_dir]
								   
config['libraries'] = list([_[:-4] for _ in os.listdir(os.path.join(pylon_dir, 'Development', 'lib', arch))
									 if _.endswith('.lib')])
									 
config['libraries'].append("dbghelp")
#for _ in os.listdir(os.path.join(extra_lib_dir, 'opencv')):
#	if _.endswith('.dll'):
#		config['libraries'].append(_[:-4])

print(config['libraries'])
config['include_dirs'] = [os.path.join(pylon_dir, 'Development', 'include'),c_code_dir,os.path.join(c_code_dir,"PylonImageApp","source"),os.path.join(c_code_dir,"PylonImageApp", 'header'), 
extra_include_dir,os.path.join(extra_include_dir, 'boost_1_63_0'),"cython"]
config['language'] = 'c++'
config['extra_compile_args'] = ['/EHsc']        ##important for boost
config['include_dirs'].append(numpy.get_include())

ext_modules = [Extension('baslerpylonapp.basler_pylon_app', ["cython/baslerpylonapp/basler_pylon_app.pyx"], **config)]
		#	    Extension('pylon.utility', ["cython/pyx/utility/pylonutility.pyx"], **config)]
	 	#		Extension('pylon.app.camerautility', ["cython/pyx/app/camerautility.pyx"], **config)]



setup(name='baslerpylonapp',cmdclass={'build_ext': build_ext},
      ext_modules=ext_modules,
	  packages=find_packages()
      )

	  
	  


