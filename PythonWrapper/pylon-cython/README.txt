=========Reference==========
This project is refered from the porject https://github.com/mabl/PyPylon
The pypylon project extracts certain function from pylon in C++ to pylon in python
This project aims to extract all (or mostly) pylon api in c++ to python

========Current Status======
extract main api: get camera, grab images
problems with calling the api in python

========TO DO=========
fix so that we can call the api in python
test if the python api can work
extract more api

========Structure========
--setup
--cython 
  --pxd 
       --cinterface //contain files that are like the headers for pylon c++ files
	   --pylon
           --base
	   --genapi
           ....
       --cythoninterface //contain files that are like the headers for cython .pyx file
	   --pylon
           ...
  --pyx
       --pylon
       --....
  

=======How to use========
----Requirement
- install Python, Cython, C++ compiler

----Run
- from main folder: setup.py install
- call the api in python file 

