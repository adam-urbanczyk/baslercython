from pylon.cimage cimport IImage
from baslerpylon.pylon.image cimport Image
from pylon.cimagepersistence cimport CImagePersistence
from baslerpylon.pylon.property_map cimport PropertyMap
from libcpp.string cimport string
from pylon.cpylon_include cimport *
from genapi.cinode_map cimport INodeMap
from baslerpylon.pylon.camera_enum cimport EImageFileFormat
from base.cgcbase cimport gcstring
from cython.operator cimport dereference as deref
from baslerpylon.pylon.property_map cimport vector

cdef class BaslerUsbGrabResult:
    #Provides an IImage interface to the grab result
	#def get_image(self):
    #    cdef IImage* img = &(<IImage&>self.cgrabresultptr)
    #    return Image.create(img)

    # \brief The currently referenced data is released.
    #
    # \post The currently referenced data is released.
    def release(self):
        self.cgrabresultptr.Release()

    # /*!
    # \brief Indicates that the held grab result data and buffer is only referenced by this grab result.
    #
    # \return Returns true if the held grab result data and buffer is only referenced by this grab result. Returns false if the grab result is invalid.
    #
    # \error
    #     Does not throw C++ exceptions.
    # */
    def is_unique(self):
        return self.cgrabresultptr.IsUnique()

    # # Checks if buffer has a CRC attached. This needs not be activated for the device. See the PayloadCRC16 chunk.
    # /* The chunk feature must be supported and activated, otherwise false is returned. */
    def has_crc(self):
        return self.cgrabresultptr.GetGrabResultData().HasCRC()

    # # Checks CRC sum of buffer, returns true if CRC sum is OK.
    # /*
    # \error
    #     Throws an exception if GetHasCRC() is false and chunks are activated.
    # */
    def check_crc(self):
        return self.cgrabresultptr.GetGrabResultData().CheckCRC()

    #def get_stride(self, size_t& strideBytes):
    #    return self.cgrabresultptr.GetGrabResultData().GetStride(strideBytes)

	#Save Image to File
    def save_image(self, EImageFileFormat imageFileFormat, basestring filename):
        cdef bytes btes_name = filename.encode()
        CImagePersistence.Save(imageFileFormat, gcstring(btes_name), (self.cgrabresultptr))

    # # Get the reference to the chunk data node map connected to the result.
    # # An empty node map is returned when the device does not support this feature or when chunks are disabled. */     	
    def get_chunk_data_node_map(self):
        cdef vector[INodeMap*] maps
        maps.push_back(<INodeMap*>&self.cgrabresultptr.GetGrabResultData().GetChunkDataNodeMap())
        return PropertyMap.create_maps(maps)

    # Returns true if an image has been grabbed successfully and false in the case of an error.		
    def grab_succeeded(self):
        return self.cgrabresultptr.GetGrabResultData().GrabSucceeded()

    # /*!
    # \brief Check whether data is referenced.
    #
    # \return True if data is referenced.
    #
    # \error
    #     Does not throw C++ exceptions.
    # */		
    property valid:
        def __get__(self):
            return self.is_valid()

    def is_valid(self):
            return self.cgrabresultptr.IsValid()

    # This method returns a description of the error if GrabSucceeded() returns false due to an error			
    property error_description:
        def __get__(self):
            return self.get_error_description()

    def get_error_description(self):
            return <string>self.cgrabresultptr.GetGrabResultData().GetErrorDescription()
	`
   # This method returns the error code if GrabSucceeded() returns false due to an error.   	
    property error_code:
        def __get__(self):
            return self.get_error_code()

    def get_error_code(self):
            return self.cgrabresultptr.GetGrabResultData().GetErrorCode()

    # Get the current payload type.			
    property payload_type:
        def __get__(self):
            return self.get_payload_type()

    def get_payload_type(self):
            return self.cgrabresultptr.GetGrabResultData().GetPayloadType()

    # Get the current pixel type.			
    property pixel_type:
        def __get__(self):
            return self.get_pixel_type()

    def get_pixel_type(self):
            return self.cgrabresultptr.GetGrabResultData().GetPixelType()

    # Get the current number of columns.			
    property width:
        def __get__(self):
            return self.get_width()

    def get_width(self):
            return self.cgrabresultptr.GetGrabResultData().GetWidth()

    # Get the current number of rows expressed as number of pixels.			
    property height:
        def __get__(self):
            return self.get_height()

    def get_height(self):
            return self.cgrabresultptr.GetGrabResultData().GetHeight()

    # Get the current starting column	
    property offset_x:
        def __get__(self):
            return self.get_offset_x()

    def get_offset_x(self):
            return self.cgrabresultptr.GetGrabResultData().GetOffsetX()

    # Get the current starting row.
    property offset_y:
        def __get__(self):
            return self.get_offset_y()

    def get_offset_y(self):
            return self.cgrabresultptr.GetGrabResultData().GetOffsetY()

    # Get the number of extra data at the end of each row in bytes.			
    property padding_x:
        def __get__(self):
            return self.get_padding_x()

    def get_padding_x(self):
            return self.cgrabresultptr.GetGrabResultData().GetPaddingX()

    # Get the number of extra data at the end of the image data in bytes.			
    property padding_y:
        def __get__(self):
            return self.get_padding_y()

    def get_padding_y(self):
            return self.cgrabresultptr.GetGrabResultData().GetPaddingY()
	
    # Get the current payload size in bytes.	
    property payload_size:
        def __get__(self):
            return self.get_payload_size()

    def get_payload_size(self):
            return self.cgrabresultptr.GetGrabResultData().GetPayloadSize()

    # Get the block ID of the grabbed frame (camera device specific).
    #
    # \par USB Camera Devices
    # The sequence number starts with 0 and uses the full 64 Bit range.
    #
    # \attention A block ID with the value UINT64_MAX indicates that the block ID is invalid and must not be used.
    # */			
    property block_id:
        def __get__(self):
             return self.get_block_id()

    def get_block_id(self):
             return self.cgrabresultptr.GetGrabResultData().GetBlockID()

    # # Get the camera specific tick count (camera device specific).
    # #
    # This describes when the image exposure was started.
    # Cameras that do not support this feature return zero. If supported, this
    # can be used to determine which image AOIs were acquired simultaneously.
    # */
    property timestamp:
        def __get__(self):
            return self.get_timestamp()
			
    def get_timestamp(self):
            return self.cgrabresultptr.GetGrabResultData().GetTimeStamp()

    # # Get the size of the image in byte.
    # /*
    #     Uses Pylon::ComputeBufferSize to compute the stride from the result data.
    #     PaddingY is not taken into account.
    #
    # \return The buffer size in byte.
    #
    # \pre The preconditions of Pylon::ComputeBufferSize must be met.
    #
    # \error
    #     Throws an exception if the buffer size cannot be computed from the result data.
    # */			
    property image_size:
        def __get__(self):
            return self.get_image_size()

    def get_image_size(self):
            return self.cgrabresultptr.GetGrabResultData().GetImageSize()

    # # Get the context value assigned to the camera object. The context is attached to the result when it is retrieved.			
    property camera_context:
        def __get__(self):
            return self.get_camera_context()

    def get_camera_context(self):
            return self.cgrabresultptr.GetGrabResultData().GetCameraContext()

    # Get the ID of the grabbed image.
    # Always returns a number larger than 0. The counting starts with 1 and is never reset during the lifetime of the Instant Camera object. */
        			
    property id:
        def __get__(self):
            return self.get_id()

    def get_id(self):
	        return self.cgrabresultptr.GetGrabResultData().GetID()

    # Get the number of the image. This number is incremented when an image is retrieved using CInstantCamera::RetrieveResult().
    # Always returns a number larger than 0. The counting starts with 1 and is reset with every call to CInstantCamera::StartGrabbing(). */   			
    property image_number:
        def __get__(self):
            return self.get_image_number()

    def get_image_number(self):
            return self.cgrabresultptr.GetGrabResultData().GetImageNumber()

    # # Get the number of skipped images before this image.
    # #
    # This value can be larger than 0 if EGrabStrategy_LatestImageOnly grab strategy or GrabStrategy_LatestImages grab strategy is used.
    # Always returns a number larger than or equal 0. This number does not include the number of images lost in case of a buffer underrun in the driver.
    # */			
    property number_of_skipped_images:
        def __get__(self):
            return self.get_number_of_skipped_images()

    def get_number_of_skipped_images(self):
            return self.cgrabresultptr.GetGrabResultData().GetNumberOfSkippedImages()

    # # Returns true if chunk data is available.
    # #
    # This is the case if the chunk mode is enabled for the camera device.
    # The parameter CInstantCamera::ChunkNodeMapsEnable of the used Instant Camera object is set to true (default setting).
    # Chunk data node maps are supported by the Transport Layer of the camera device.
    # */
    property chunk_data_available:
        def __get__(self):
            return self.is_chunk_data_available()
 
    def is_chunk_data_available(self):
            return self.cgrabresultptr.GetGrabResultData().IsChunkDataAvailable()
 
    # Get the context value assigned to the buffer. The context is set when CInstamtCamera is using a custom buffer factory.
    property buffer_context:
        def __get__(self):
            return self.get_buffer_context()

    def get_buffer_context(self):
            return self.cgrabresultptr.GetGrabResultData().GetBufferContext()
	
    # # Get the reference to the chunk data node map connected to the result.
    # # An empty node map is returned when the device does not support this feature or when chunks are disabled. */
    property chunk_data_node_map:
        def __get__(self):
            return self.get_chunk_data_node_map()

    def get_chunk_data_node_map(self):
            return PropertyMap.create((<INodeMap*>&self.cgrabresultptr.GetGrabResultData().GetChunkDataNodeMap()))

