# Orthophotos, Lidar and SfM datasets for Campus Golm
## 1. Lidar datasets
### *Reference dataset*: Airborne lidar data (summer 2010)
These points have been colored with a 20-cm digital orthophoto from the same time. Point classification was performed using standard parameters from lasground and lasclassify
+ Point-classified LAZ file of Golm airborne lidar tile (includes Campus Golm and surrounding area) [golm_airlidar_utm33u_wgs84_rgb_cl.laz](https://www.dropbox.com/s/hiy02tx4qpq40jv/golm_airlidar_utm33u_wgs84_rgb_cl.laz?dl=0)

+ Bare-earth DEM (Digital Terrain Model) with 1-m spatial resolution [GeoTIFF](https://www.dropbox.com/s/kweuhu9cldc2bao/golm_airlidar_utm33u_wgs84_cl2.tif?dl=0)
and the corresponding hillshade [GeoTIFF](https://www.dropbox.com/s/qyfj3tcw3rv3whn/golm_airlidar_utm33u_wgs84_cl2_HS.tif?dl=0)

+ Digital Orthophotos (20-cm, DOP20RGB) for Campus Golm (same area as airborne lidar data): [Golm_DOP_20cm_utm33_wgs84_tif.zip](https://www.dropbox.com/s/xofz56eqh4vrv65/Golm_DOP_20cm_utm33_wgs84_tif.zip?dl=0)

### Terrestrial Lidar Scanner data (February and March 2017)
In March 2017, about 170 individual terrestrial lidar scans (TLS) were merged to generate a nearly complete TLS coverage of Campus Golm. The data are very detailed for the ground and sidewalls of building, but do not contain roofs (with the exception of building 27). The data are rudimentary aligned to the airborne lidar datasets.

+ TLS scan from March 2017, 5-cm thinned version: [TLS_Golm_March2017_5cm.laz](https://www.dropbox.com/s/fuwhnz5a66a31i5/TLS_Golm_March2017_5cm.laz?dl=0). This was generated with: ```lasthin.exe -i TLS_Golm_March2017.laz -olaz -o TLS_Golm_March2017_5cm.laz -central -step 0.05```
+TLS scan from March 2017, 10-cm thinned version: [TLS_Golm_March2017_10cm.laz](https://www.dropbox.com/s/6wd1a9o0k3j8m48/TLS_Golm_March2017_10cm.laz?dl=0). This was generated with: ```lasthin.exe -i TLS_Golm_March2017.laz -olaz -o TLS_Golm_March2017_5cm.laz -central -step 0.5```

## 2. SfM datasets
### 1. ebee (March 25, 2017)
ebee flight with PowerShot 110S. SfM processing was performed with Agisoft Photoscan and Pix4D. Pointclouds derived from OpenDroneMapper were not of high quality.
+ Pointcloud derived from Agisoft Photoscan using the JPG raw images, point cloud rescaled to 0.01 m (1cm precision), and thinned to 5 cm: [ebee_Golm_Color_25March2017_agisoft_5cm.laz](https://www.dropbox.com/s/arm8g781gdqsy2a/ebee_Golm_Color_25March2017_agisoft_5cm.laz?dl=0).


ebee_Golm_Color_25March2017.laz
ebee_Golm_Color_25March2017_raw_aligned_to_airborne.laz

+ Pointcloud derived from Agisoft Photoscan using the JPG raw images, point cloud rescaled to 0.01 m (1cm precision), and thinned to 5 cm: [ebee_Golm_Color_25March2017_agisoft_5cm.laz]( ). Generated with ```lasthin.exe -i ebee_Golm_Color_25March2017_agisoft.laz -olaz -o ebee_Golm_Color_25March2017_agisoft_5cm.laz -central -step 0.05```
+ Orthophoto (resampled to 5cm) generated with Photoscan Agisoft (5cm spatial resolution): [2017_03_25_ebee_campus_UTM33N_WGS84_5cm.tif](https://www.dropbox.com/s/6g96awjwwbf1ab7/2017_03_25_ebee_campus_UTM33N_WGS84_5cm.tif?dl=0)


### 2. ebee (May 25, 2017)
ebee flight with PowerShot 110S. SfM processing was performed with Agisoft Photoscan and Pix4D. Pointclouds derived from OpenDroneMapper were not of high quality.
+ Pointcloud derived from Agisoft Photoscan using the JPG raw images, point cloud rescaled to 0.01 m (1cm precision), and thinned to 5 cm: [ebee_Golm_Color_25May2017_agisoft_raw_5cm.laz](https://www.dropbox.com/s/c14o6micli2hygk/ebee_Golm_Color_25May2017_agisoft_raw_5cm.laz?dl=0). Generated with ```lasthin.exe -i ebee_Golm_Color_25May2017_agisoft_raw.laz -olaz -o ebee_Golm_Color_25May2017_agisoft_raw_5cm.laz -central -step 0.05```
+ Pointcloud derived from Agisoft Photoscan using out-of-camera (ooc) images, point cloud rescaled to 0.01 m (1cm precision), and thinned to 5 cm: [ebee_Golm_Color_25May2017_agisoft_ooc_5cm.laz](https://www.dropbox.com/s/ac8cziwavd81l3k/ebee_Golm_Color_25May2017_agisoft_ooc_5cm.laz?dl=0). Generated with ```lasthin.exe -i ebee_Golm_Color_25May2017_agisoft_ooc.laz -olaz -o ebee_Golm_Color_25May2017_agisoft_ooc_5cm.laz -central -step 0.05```
+ Pointcloud derived from Pix4D (minimum 4 image matches) using out-of-camera (ooc) images, point cloud rescaled to 0.01 m (1cm precision), and thinned to 5 cm: [ebee_Golm_Color_25May2017_pix4d_4matches_ooc_5cm.laz](https://www.dropbox.com/s/wqbpazlwfuo70y3/ebee_Golm_Color_25May2017_pix4d_4matches_ooc_5cm.laz?dl=0). Generated with ```lasthin.exe -i ebee_Golm_Color_25May2017_pix4d_4matches_ooc.laz -olaz -o ebee_Golm_Color_25May2017_pix4d_4matches_ooc_5cm.laz -central -step 0.05```
+ Orthophoto (resampled to 5cm) generated with Photoscan Agisoft (5cm spatial resolution): [ebee_Golm_Color_25May2017_agisoft_orthophoto_5cm.tif](https://www.dropbox.com/s/rat920pde63x214/ebee_Golm_Color_25May2017_agisoft_orthophoto_5cm.tif?dl=0)


### 3. DJI-ZenMuse X5 (Inspire 2) - flight May 25, 2017
+ Pointcloud derived from DJI ZenMuse X5 (Inspire 2) with _flight elevation 30m_, Pix4D pointcloud, 4 minimum image matches, densified point cloud, rescaled to 1cm. *These data are only rudimentary aligned to the airborne dataset and will need to be manually aligned to the airborne datasets before ICP registration* [Golm_250517_Haus27_29_H30m_Pix4D_densified_ptcloud.laz](https://www.dropbox.com/s/v6cehyvr3wg6he2/Golm_250517_Haus27_29_H30m_Pix4D_densified_ptcloud.laz?dl=0).
+ Pointcloud derived from DJI ZenMuse X5 (Inspire 2) with _flight elevation 50m_, Pix4D pointcloud, 4 minimum image matches, densified point cloud, rescaled to 1cm. *These data are only rudimentary aligned to the airborne dataset and will need to be manually aligned to the airborne datasets before ICP registration* [Golm_250517_Haus27_29_H50m_Pix4D_densified_ptcloud.laz](https://www.dropbox.com/s/1xl1bb05zccjksv/Golm_250517_Haus27_29_H50m_Pix4D_densified_ptcloud.laz?dl=0).
+ Pointcloud derived from DJI ZenMuse X5 (Inspire 2) with _flight elevation 70m_, Pix4D pointcloud, 4 minimum image matches, densified point cloud, rescaled to 1cm. *These data are only rudimentary aligned to the airborne dataset and will need to be manually aligned to the airborne datasets before ICP registration* [Golm_250517_Haus27_29_H70m_Pix4D_densified_ptcloud.laz](https://www.dropbox.com/s/3mf0pq01riw5lji/Golm_250517_Haus27_29_H70m_Pix4D_densified_ptcloud.laz?dl=0).
+ Pointcloud derived from DJI ZenMuse X5 (Inspire 2) with _flight elevation 90m_, Pix4D pointcloud, 4 minimum image matches, densified point cloud, rescaled to 1cm. *These data are only rudimentary aligned to the airborne dataset and will need to be manually aligned to the airborne datasets before ICP registration* [Golm_250517_Haus27_29_H90m_Pix4D_densified_ptcloud.laz](https://www.dropbox.com/s/5zvyvlwu37dpez8/Golm_250517_Haus27_29_H90m_Pix4D_densified_ptcloud.laz?dl=0).
+ Pointcloud derived from DJI ZenMuse X5 (Inspire 2) by merging images with _flight elevations of 30, 50, 70, and 90m_ with a total of 1327 images, Pix4D pointcloud, 4 minimum image matches, densified point cloud, rescaled to 1cm. *These data are only rudimentary aligned to the airborne dataset and will need to be manually aligned to the airborne datasets before ICP registration* [Golm_250517_Haus27_29_H30_50_70_90m_Pix4D_densified_ptcloud.laz]().

---
+ Pointcloud derived from DJI ZenMuse X5 (Inspire 2) with _flight elevation 70m_, OpenDrone Mapper (ODM) pointcloud, 4 minimum image matches (optimized parameters 3,  cf. settings_optimzed3.yaml), rescaled to 1cm. *These data are only rudimentary aligned to the airborne dataset and will need to be manually aligned to the airborne datasets before ICP registration* [ODM_Haus27_29_H70m_model_optimized3param.laz](https://www.dropbox.com/s/uyl9tnq6uidz8k9/ODM_Haus27_29_H70m_model_optimized3param.laz?dl=0).
+ Pointcloud derived from DJI ZenMuse X5 (Inspire 2) by merging images with _flight elevations of 30, 50, 70, and 90m_ with a total of 1327 images, OpenDrone Mapper (ODM) pointcloud, 4 minimum image matches (optimized parameters 5,  cf. settings_optimzed5.yaml), 4 minimum image matches, rescaled to 1cm. *These data are notaligned to the airborne dataset and will need to be manually aligned to the airborne datasets before ICP registration* [Golm_250517_Haus27_29_H30_50_70_90m_Pix4D_densified_ptcloud.laz]().
