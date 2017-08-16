#include <pylon/PylonIncludes.h>
#include <iostream>


using namespace Pylon;
using namespace GenApi;

    class CCameraEventPrinter : public CCameraEventHandler
    {
    public:
        virtual void OnCameraEvent( CInstantCamera& camera, intptr_t userProvidedId, GenApi::INode* pNode)
        {
            std::cout << "OnCameraEvent event for device " << camera.GetDeviceInfo().GetModelName() << std::endl;
            std::cout << "User provided ID: " << userProvidedId << std::endl;
            std::cout << "Event data node name: " << pNode->GetName() << std::endl;
            GenApi::CValuePtr ptrValue( pNode );
            if ( ptrValue.IsValid() )
            {
                std::cout << "Event node data: " << ptrValue->ToString() << std::endl;
            }
            std::cout << std::endl;
        }
    };



    class CConfigurationEventPrinter : public CConfigurationEventHandler
    {
    public:
        void OnAttach( CInstantCamera& /*camera*/)
        {
            std::cout << "OnAttach event" << std::endl;
        }

        void OnAttached( CInstantCamera& camera)
        {
            std::cout << "OnAttached event for device " << camera.GetDeviceInfo().GetModelName() << std::endl;
        }

        void OnOpen( CInstantCamera& camera)
        {
            std::cout << "OnOpen event for device " << camera.GetDeviceInfo().GetModelName() << std::endl;
        }

        void OnOpened( CInstantCamera& camera)
        {
            std::cout << "OnOpened event for device " << camera.GetDeviceInfo().GetModelName() << std::endl;
        }

        void OnGrabStart( CInstantCamera& camera)
        {
            std::cout << "OnGrabStart event for device " << camera.GetDeviceInfo().GetModelName() << std::endl;
        }

        void OnGrabStarted( CInstantCamera& camera)
        {
            std::cout << "OnGrabStarted event for device " << camera.GetDeviceInfo().GetModelName() << std::endl;
        }

        void OnGrabStop( CInstantCamera& camera)
        {
            std::cout << "OnGrabStop event for device " << camera.GetDeviceInfo().GetModelName() << std::endl;
        }

        void OnGrabStopped( CInstantCamera& camera)
        {
            std::cout << "OnGrabStopped event for device " << camera.GetDeviceInfo().GetModelName() << std::endl;
        }

        void OnClose( CInstantCamera& camera)
        {
            std::cout << "OnClose event for device " << camera.GetDeviceInfo().GetModelName() << std::endl;
        }

        void OnClosed( CInstantCamera& camera)
        {
            std::cout << "OnClosed event for device " << camera.GetDeviceInfo().GetModelName() << std::endl;
        }

        void OnDestroy( CInstantCamera& camera)
        {
            std::cout << "OnDestroy event for device " << camera.GetDeviceInfo().GetModelName() << std::endl;
        }

        void OnDestroyed( CInstantCamera& /*camera*/)
        {
            std::cout << "OnDestroyed event" << std::endl;
        }

        void OnDetach( CInstantCamera& camera)
        {
            std::cout << "OnDetach event for device " << camera.GetDeviceInfo().GetModelName() << std::endl;
        }

        void OnDetached( CInstantCamera& camera)
        {
            std::cout << "OnDetached event for device " << camera.GetDeviceInfo().GetModelName() << std::endl;
        }

        void OnGrabError( CInstantCamera& camera, const String_t errorMessage)
        {
            std::cout << "OnGrabError event for device " << camera.GetDeviceInfo().GetModelName() << std::endl;
            std::cout << "Error Message: " << errorMessage  << std::endl;
        }

        void OnCameraDeviceRemoved( CInstantCamera& camera)
        {
            std::cout << "OnCameraDeviceRemoved event for device " << camera.GetDeviceInfo().GetModelName() << std::endl;
        }
    };





    class CImageEventPrinter : public CImageEventHandler
    {
    public:

        virtual void OnImagesSkipped( CInstantCamera& camera, size_t countOfSkippedImages)
        {
            std::cout << "OnImagesSkipped event for device " << camera.GetDeviceInfo().GetModelName() << std::endl;
            std::cout << countOfSkippedImages  << " images have been skipped." << std::endl;
            std::cout << std::endl;
        }


        virtual void OnImageGrabbed( CInstantCamera& camera, const CGrabResultPtr& ptrGrabResult)
        {
            std::cout << "OnImageGrabbed event for device " << camera.GetDeviceInfo().GetModelName() << std::endl;

            // Image grabbed successfully?
            if (ptrGrabResult->GrabSucceeded())
            {
                std::cout << "SizeX: " << ptrGrabResult->GetWidth() << std::endl;
                std::cout << "SizeY: " << ptrGrabResult->GetHeight() << std::endl;
                const uint8_t *pImageBuffer = (uint8_t *) ptrGrabResult->GetBuffer();
                std::cout << "Gray value of first pixel: " << (uint32_t) pImageBuffer[0] << std::endl;
                std::cout << std::endl;
            }
            else
            {
                std::cout << "Error: " << ptrGrabResult->GetErrorCode() << " " << ptrGrabResult->GetErrorDescription() << std::endl;
            }
        }
    };
