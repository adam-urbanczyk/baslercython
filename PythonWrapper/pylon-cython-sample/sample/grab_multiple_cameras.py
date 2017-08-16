import baslerpylon.pylon.tlfactory as tlfactory
import baslerpylon.pylon.usb.basler_usb_instant_camera as BaslerUsbInstantCamera
import time
import pylonsample.sample_chunk_ts_image_event_handler as eventhander
import baslerpylon.pylon.camera_enum as enum

factory_instant = tlfactory.TlFactory().get_instance()
device_infos = factory_instant.find_devices_info_list()

num_device = min(10,len(device_infos))
cam_array = []
for i in range(num_device):
    cam_array.append(BaslerUsbInstantCamera.BaslerUsbInstantCamera.create_cam(factory_instant.create_device(device_infos[i])))


for i in range(num_device):
    cam_array[i].open()
    cam_array[i].get_node_map()["ChunkModeActive"] = True;
    cam_array[i].get_node_map()["ChunkSelector"] = "Timestamp";
    cam_array[i].get_node_map()["ChunkEnable"] = True;

cam_array[i].save_camera_timestamp(cam_array, "E:\User\yduong\images_python_mpc")
cam_array[0].lock_capture_image_thread()

for i in range(num_device):
    cam_array[i].capture_images(1, "E:\User\yduong\images_python_mpc")

time.sleep(1)
cam_array[0].un_lock_capture_image_thread()
for i in range(num_device):
    while (cam_array[i].is_thread_running()):
        time.sleep(1)