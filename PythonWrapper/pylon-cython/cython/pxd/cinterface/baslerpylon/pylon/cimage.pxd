from exception.custom_exception cimport raise_py_error
from libcpp cimport bool
from libc.stdint cimport uint32_t
from baslerpylon.pylon.camera_enum cimport EImageOrientation
from baslerpylon.pylon.camera_enum cimport EPixelType


cdef extern from "pylon/Image.h" namespace 'Pylon':
    cdef cppclass IImage:
        #  /// Ensure proper destruction by using a virtual destructor.
        # // Do not add implemenation here in class as older compilers doesn't accept in-class definitions (see definition below)
        void Destructor "~IImage"() except +raise_py_error

        # //
        # /*!
        # \brief Can be used to check whether an image is valid.
        #
        # \return Returns false if the image is invalid.
        #
        # \error
        #     Does not throw C++ exceptions.
        # */
        bool IsValid() except +raise_py_error

        # /*!
        # \brief Get the current pixel type.
        #
        # \return Returns the pixel type or PixelType_Undefined if the image is invalid.
        #
        # \error
        #     Does not throw C++ exceptions.
        # */
        EPixelType GetPixelType() except +raise_py_error


        # /*!
        # \brief Get the current number of columns in pixels.
        #
        # \return Returns the current number of columns in pixels or 0 if the image is invalid.
        #
        # \error
        #     Does not throw C++ exceptions.
        # */
        uint32_t GetWidth() except +raise_py_error

        # /*!
        # \brief Get the current number of rows.
        #
        # \return Returns the current number of rows or 0 if the image is invalid.
        #
        # \error
        #     Does not throw C++ exceptions.
        # */
        uint32_t GetHeight() except +raise_py_error

        #
        # /*!
        # \brief Get the number of extra data bytes at the end of each row.
        #
        # \return Returns the number of extra data bytes at the end of each row or 0 if the image is invalid.
        #
        # \error
        #     Does not throw C++ exceptions.
        # */
        size_t GetPaddingX() except +raise_py_error

        # /*!
        # \brief Get the vertical orientation of the image in memory.
        #
        # \return Returns the orientation of the image or ImageOrientation_TopDown if the image is invalid.
        #
        # \error
        #     Does not throw C++ exceptions.
        # */
        EImageOrientation GetOrientation() except +raise_py_error

        # /*!
        # \brief Indicates that the referenced buffer is only referenced by this image.
        #
        # \return Returns true if the referenced buffer is only referenced by this image. Returns false if the image is invalid.
        #
        # \error
        #     Does not throw C++ exceptions.
        # */
        bool IsUnique() except +raise_py_error

       # /*!
       #  \brief Get the pointer to the buffer.
       #
       #  \return Returns the pointer to the used buffer or NULL if the image is invalid.
       #
       #  \error
       #      Does not throw C++ exceptions.
       #  */
        void* GetBuffer() except +raise_py_error

        # /*!
        # \brief Get the size of the image in bytes.
        #
        # \return Returns the size of the image in bytes or 0 if the image is invalid.
        #
        # \error
        #     Does not throw C++ exceptions.
        # */
        size_t GetImageSize() except +raise_py_error

        # /*!
        # \brief Get the stride in bytes.
        #
        # The stride in bytes can not be computed for packed image format when the stride is not byte aligned. See also Pylon::IsPacked().
        # The stride in bytes can not be computed if the image is invalid.
        #
        # \param[out] strideBytes  The stride in byte if it can be computed.
        # \return Returns true if the stride can be computed.
        #
        # \error
        #     Does not throw C++ exceptions.
        # */
        bool GetStride( size_t& strideBytes) except +raise_py_error




