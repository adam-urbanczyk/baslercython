from baslerpylonapp.basler_pylon_app import BaslerPylonApp

apps = BaslerPylonApp()
#apps.capture_image(1,"E:\User\yduong\images_python")
apps.reset_frame_auto("E:\User\yduong\images_reset",["E:\User\yduong\image_0","E:\User\yduong\image_1","E:\User\yduong\image_2","E:\User\yduong\image_3"])