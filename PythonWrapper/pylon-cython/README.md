## Reference
- This project is refered from the porject https://github.com/mabl/PyPylon
- The pypylon project extracts certain function from pylon in C++ to pylon in python
- This project aims to extract all (or mostly) pylon api in c++ to python


## Structure
--setup <br/>
--cython <br/>
&nbsp;&nbsp;--pxd <br/>
&nbsp;&nbsp;&nbsp;--cinterface //contain files that are like the headers for pylon c++ files<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--pylon<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--base<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--genapi<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;....<br/>
&nbsp;&nbsp;&nbsp;--cythoninterface //contain files that are like the headers for cython .pyx file<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--pylon<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;...<br/>
&nbsp;&nbsp;--pyx<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--pylon<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--....<br/>
  

## How to use
Requirement
- install Python, Cython, C++ compiler

Run
- from main folder: setup.py install
- call the api in python file 

