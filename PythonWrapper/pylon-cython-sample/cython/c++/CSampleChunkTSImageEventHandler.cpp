#include <string>
#include <pylon/PylonIncludes.h>
#include <pylon/usb/BaslerUsbInstantCamera.h>
#include <iostream>
#include <fstream>

using namespace Pylon;
using namespace GenApi;
using namespace std;
using namespace Basler_UsbCameraParams;

typedef Pylon::CBaslerUsbInstantCamera Camera_t;
typedef CBaslerUsbCameraEventHandler CameraEventHandler_t; // Or use Camera_t::CameraEventHandler_t
typedef Pylon::CBaslerUsbImageEventHandler ImageEventHandler_t;

														   // Example of a device specific handler for image events.
class CSampleChunkTSImageEventHandler : public ImageEventHandler_t
{
public:
	virtual void OnImageGrabbed(Camera_t& camera, const CBaslerUsbGrabResultPtr& ptrGrabResult)
	{
		// The chunk data is attached to the grab result and can be accessed anywhere.

        // Generic parameter access:
        // This shows the access via the chunk data node map. This method is available for all grab result types.
        GenApi::CIntegerPtr chunkTimestamp( ptrGrabResult->GetChunkDataNodeMap().GetNode( "ChunkTimestamp"));

        // Access the chunk data attached to the result.
        // Before accessing the chunk data, you should check to see
        // if the chunk is readable. When it is readable, the buffer
        // contains the requested chunk data.
        if ( IsReadable( chunkTimestamp))
            cout << "OnImageGrabbed: TimeStamp (Result) accessed via node map: " << chunkTimestamp->GetValue() << endl;

        // Native parameter access:
        // When using the device specific grab results the chunk data can be accessed
        // via the members of the grab result data.
        if ( IsReadable(ptrGrabResult->ChunkTimestamp))
            cout << "OnImageGrabbed: TimeStamp (Result) accessed via result member: " << ptrGrabResult->ChunkTimestamp.GetValue() << endl;
	}
};
