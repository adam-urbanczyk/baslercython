from cython.operator cimport dereference as deref
cimport numpy as np
import numpy as np

cdef class Image:    
    

    @staticmethod
    cdef create(IImage* iimage):
        obj = Image()
        obj.iimage = iimage
        return obj

    property width:
        def __get__(self):
            return deref(self.iimage).GetWidth()
            
    property height:
        def __get__(self):
            return deref(self.iimage).GetHeight()

    property image_size:
        def __get__(self):
            return deref(self.iimage).GetImageSize()

    property valid:
        def __get__(self):
            return deref(self.iimage).IsValid()
            
    property unique:
        def __get__(self):
            return deref(self.iimage).IsUnique()

    property orientation:
        def __get__(self):
            return deref(self.iimage).GetOrientation()

    property padding_x:
        def __get__(self):
            return deref(self.iimage).GetPaddingX()

    property pixel_type:
        def __get__(self):
            return deref(self.iimage).GetPixelType()

    def get_stride(self,size_t strideBytes):
        return self.iimage.GetStride(strideBytes)

    def destroy(self):
        self.iimage.Destructor()

    def get_buffer(self, camera):
        cdef str bits_per_pixel_prop = str(camera.properties['PixelSize'])
        try:
            return np.frombuffer((<char*>self.iimage.GetBuffer())[:self.iimage.GetImageSize()], dtype='uint'+bits_per_pixel_prop[3:])
        except Exception, e:
            raise e

