# Matlab Codes and Examples for Point-cloud processing

Point clouds in Matlab can be processed in various ways. We will use the Point cloud tools for Matlab: [pctools](http://www.geo.tuwien.ac.at/downloads/pg/pctools/pctools.html). The code is available on github [point_cloud_tools](https://github.com/pglira/Point_cloud_tools_for_Matlab) and you will need to  install this software. The Point cloud tools come with pre-compiled binaries for 64-bit Windows systems to load LAS/LAZ files. On Mac OSX or Linux, you will need to compile the required packages.

The point cloud tools are a useful alternative to the Computer Vision Toolbox from Matlab that is available commercially.

+ File [pointcloud_plane_fitting.m](pointcloud_plane_fitting.m) contains an example of how to fit a plane to a clipped, even point-cloud surface. You will need to provide a las/laz/xyz file, clipped with lasclip and a polygon. This requires [polyfitn](https://www.mathworks.com/matlabcentral/fileexchange/34765-polyfitn) from Mathworks File Exchange. Point clouds can be either loaded with [lasdata](https://www.mathworks.com/matlabcentral/fileexchange/48073-lasdata) (only LAS, no LAZ files) or with the Point Cloud Tools.
+ File [Golm_campus_Lidar_SfM_ICP.m](Golm_campus_Lidar_SfM_ICP.m) contains an example of how to align airborne lidar and SfM point clouds using ICP.
+ File [DJI_ZenMuseX5_Haus27_29_ICP.m](DJI_ZenMuseX5_Haus27_29_ICP.m) is an example file that shows the alignment of 6 point clouds (one reference point cloud: ebee-May-25-2017 with 5 point clouds derived with the DJI ZenMuse X5 at various heights)
+ File [Golm_pointcloud_kdtree.m](Golm_pointcloud_kdtree.m) is an example that shows how to use kdtree on point clouds. This script contains a micro-relief (or topographic variance) calculation for the airborne lidar and ebee datasets. The point-cloud based topographic relief or variance is interpolated to an equally-spaced grid with [gdal_grid](http://www.gdal.org/gdal_grid.html).
