from exception.custom_exception cimport raise_py_error
from pylon.usb.cbasler_usb_grab_result_data cimport CBaslerUsbGrabResultData
from pylon.cimage cimport IImage
from libcpp cimport bool


cdef extern from "pylon/usb/BaslerUsbGrabResultPtr.h" namespace 'Pylon':
    cdef cppclass CBaslerUsbGrabResultPtr:
       # /*!
        # \brief Creates a smart pointer.
        # \post No grab result is referenced.
        # */
        CBaslerUsbGrabResultPtr() except +raise_py_error

        #         /*!
        # \brief Creates a copy of a smart pointer.
        #
        # \param[in] rhs Another smart pointer, source of the result data to reference.
        #
        # The data itself is not copied.
        #
        # \post
        # <ul>
        # <li>Another reference to the grab result of the source is held if it references a grab result.
        # <li>No grab result is referenced if the source does not reference a grab result.
        # </ul>
        #
        # \error
        #     Still valid after error.
        # */
        CBaslerUsbGrabResultPtr(CBaslerUsbGrabResultPtr& rhs)  except +raise_py_error

        # /*!
        # \brief Assignment of a smart pointer.
        #
        # \param[in] rhs Another smart pointer, source of the result data to reference.
        #
        # The data itself is not copied.
        #
        # \post
        # <ul>
        # <li>The currently referenced data is released.
        # <li>Another reference to the grab result of the source is held if it references a grab result.
        # <li>No grab result is referenced if the source does not reference a grab result.
        # </ul>
        #
        # \error
        #     Still valid after error.
        # */
        CBaslerUsbGrabResultPtr& Assign "operator =" ( const CBaslerUsbGrabResultPtr& rhs)

        # /*!
        # \brief Destroys the smart pointer.
        #
        # \post The currently referenced data is released.
        #
        # \error
        #     Does not throw C++ exceptions.
        # */
        #void Destructor "~CBaslerUsbGrabResultPtr"() except +raise_py_error

        #         /*!
        # \brief Allows accessing the referenced data.
        #
        # \return The pointer to the grab result data.
        #
        # \pre The pointer must reference a grab result.
        # IsValid() or the overloaded bool operator can be used to check whether data is referenced.
        #
        # \error
        #     Still valid after error. Throws an exception when no data is referenced.
        # */
        CBaslerUsbGrabResultData* GetGrabResultData "operator->"() except +raise_py_error

        # /*!
        # \brief Check whether data is referenced.
        #
        # \return True if data is referenced.
        #
        # \error
        #     Does not throw C++ exceptions.
        # */
        bool IsValid() except +raise_py_error

        # /*!
        # \brief The currently referenced data is released.
        #
        # \post The currently referenced data is released.
        #
        # \error
        #     Still valid after error.
        # */
        void Release() except +raise_py_error

        # /*!
        # \brief Indicates that the held grab result data and buffer is only referenced by this grab result.
        #
        # \return Returns true if the held grab result data and buffer is only referenced by this grab result. Returns false if the grab result is invalid.
        #
        # \error
        #     Does not throw C++ exceptions.
        # */
        bool IsUnique() except +raise_py_error

        # /*!
        # \brief Provides an IImage interface to the grab result.
        #
        # This cast operator allows passing the grab result to saving functions or image format converter.
        # The returned image is invalid if the grab was not successful, see CGrabResultData::GrabSucceeded().
        #
        # \attention The returned reference is only valid as long the grab result ptr is not destroyed.
        #
        # \error
        #     Still valid after error.
        # */
        IImage& GetIImage "IImage&"()

