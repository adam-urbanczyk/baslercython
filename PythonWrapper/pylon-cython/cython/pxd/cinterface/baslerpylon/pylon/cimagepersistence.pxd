from pylon.ctype_mappings cimport String_t
from pylon.cimage cimport IImage
from pylon.usb.cbasler_usb_grab_result_ptr cimport CBaslerUsbGrabResultPtr
from baslerpylon.pylon.camera_enum cimport EImageFileFormat, EImageOrientation, EPixelType
from exception.custom_exception cimport raise_py_error
#from pylon.creusableimage cimport IReusableImage
from libcpp cimport bool
from libc.stdint cimport uint32_t

cdef extern from "pylon/ImagePersistence.h" namespace 'Pylon':
    cdef  cppclass CImagePersistenceOptions:
        CImagePersistenceOptions() except +raise_py_error
        void SetQuality( int quality) except +raise_py_error
        int GetQuality() except +raise_py_error

    cdef cppclass CImagePersistence:
        # /*!
        # \brief Saves the image to disk. Converts the image to a format that can be if required.
        #
        # If required, the image is automatically converted to a new image and then saved. See
        # CanSaveWithoutConversion() for more information.
        # An image with a bit depth higher than 8 bit is stored with 16 bit bit depth
        # if supported by the image file format. In this case the pixel data is MSB aligned.
        #
        # If more control over the conversion is required then the CImageFormatConverter class
        # can be used to convert the input image before saving it.
        #
        # \param[in]   imageFileFormat The target file format for the image to save.
        # \param[in]   filename        Name and path of the image.
        # \param[in]   image           The image to save, e.g. a CPylonImage, CPylonBitmapImage, or Grab Result Smart Pointer object.
        # \param[in]   pOptions        Additional options.
        #
        # \pre
        #     The pixel type of the image to save must be a supported input format of the Pylon::CImageFormatConverter.
        #
        # \error
        #     Throws an exception if saving the image fails.
        # */
        @staticmethod
        void Save( EImageFileFormat imageFileFormat, String_t& filename,  CBaslerUsbGrabResultPtr resultPtr, CImagePersistenceOptions* pOptions)  except +raise_py_error
        @staticmethod
        void Save( EImageFileFormat imageFileFormat, String_t& filename,  CBaslerUsbGrabResultPtr resultPtr)  except +raise_py_error



        # /*!
        # \brief Can be used to check whether the given image can be saved without prior conversion.
        #
        # See the CImagePersistence::CanSaveWithoutConversion( EImageFileFormat, const IImage&) method documentation for a list of supported pixel formats.
        #
        # \param[in]   imageFileFormat The target file format for the image to save.
        # \param[in]   pixelType The pixel type of the image to save.
        # \param[in]   width     The number of pixels in a row of the image to save.
        # \param[in]   height    The number of rows of the image to save.
        # \param[in]   paddingX  The number of extra data bytes at the end of each row.
        # \param[in]   orientation The vertical orientation of the image in the image buffer.
        # \return Returns true if the image can be saved without prior conversion.
        #
        # \error
        #     Does not throw C++ exceptions.
        # */
        @staticmethod
        bool CanSaveWithoutConversion( EImageFileFormat imageFileFormat, EPixelType pixelType, uint32_t width, uint32_t height, size_t paddingX, EImageOrientation orientation) except +raise_py_error


        # /*!
        # \brief Can be used to check whether the image can be saved without prior conversion.
        #
        # Supported formats for TIFF:
        # <ul>
        # <li> PixelType_Mono8
        # <li> PixelType_Mono16
        # <li> PixelType_RGB8packed
        # <li> PixelType_RGB16packed
        # </ul>
        #
        # Supported formats for BMP, JPEG and PNG:
        # <ul>
        # <li> PixelType_Mono8
        # <li> PixelType_BGR8packed
        # <li> PixelType_BGRA8packed
        # </ul>
        #
        # \param[in]   imageFileFormat The target file format for the image to save.
        # \param[in]   image           The image to save, e.g. a CPylonImage, CPylonBitmapImage, or Grab Result Smart Pointer object.
        # \return Returns true if the image can be saved without prior conversion.
        #
        # \error
        #     Does not throw C++ exceptions.
        # */
        @staticmethod
        bool CanSaveWithoutConversion( EImageFileFormat imageFileFormat, CBaslerUsbGrabResultPtr resultPtr) except +raise_py_error


        # /*!
        # \brief Loads an image from disk.
        #
        # The orientation of loaded images is always ImageOrientation_TopDown.
        #
        # \param[in]   filename        Name and path of the image.
        # \param[in]   image           The target image object, e.g. a CPylonImage or CPylonBitmapImage object.
        #                              When passing a CPylonBitmapImage object the loaded format must be supported by the CPylonBitmapImage class.
        #
        # \error
        #     Throws an exception if the image cannot be loaded. The image buffer content is undefined when the loading of the image fails.
        # */

        #@staticmethod
        #void Load( const String_t& filename, IReusableImage& image) except +raise_py_error

        # /*!
        # \brief Loads an image from memory.
        #
        # The orientation of loaded images is always ImageOrientation_TopDown.
        # Currently BMP, JPEG & PNG images are supported.
        #
        # \param[in]   pBuffer         The pointer to the buffer of the source image.
        # \param[in]   bufferSizeBytes The size of the buffer of the source image.
        # \param[in]   image           The target image object, e.g. a CPylonImage or CPylonBitmapImage object.
        #                              When passing a CPylonBitmapImage object the loaded format must be supported by the CPylonBitmapImage class.
        #
        # \error
        #     Throws an exception if the image cannot be loaded. The image buffer content is undefined when the loading of the image fails.
        # */
        #@staticmethod
        #void LoadFromMemory( const void* pBuffer, size_t bufferSizeBytes, IReusableImage& image) except +raise_py_error

