%change to directory with data
cd F:/LAZ
%set path to Point-cloud processing tool
addpath(genpath('C:\Users\bodob\Dropbox\Teaching\DDA_SS17\labs\lab3-ICP\pglira-Point_cloud_tools_for_Matlab-0cad900'))
%Mac OSX and Linux use:
%addpath(genpath('/home/bodo/Dropbox/Teaching/DDA_SS17/labs/lab3-ICP/pglira-Point_cloud_tools_for_Matlab-0cad900'))

%% First step: load airborne pointcloud (airborne lidar)
golm_airlidar = pointCloud('golm_airlidar_utm33u_wgs84_rgb_cl.laz');
%save to matlab Mat file with: 
%golm_airlidar.save('golm_airlidar_utm33u_wgs84_rgb_cl.mat')

%On Ubuntu and Mac OSX - if you haven't compiled the lasreader - you can
%either load in the Matlab .MAT file or convert your LAZ file to a xyz
%(text) file and then use the ASCII reader:
%convert from LAS/LAZ format to ASCII using lastools:
%las2las.exe -i golm_airlidar_utm33u_wgs84_rgb_cl.laz -oparse xyzRGB -otxt -o golm_airlidar_utm33u_wgs84_rgb_cl_xyzRGB.xyz

%golm_airlidar = pointCloud('golm_airlidar_utm33u_wgs84_rgb_cl_xyzrgb.xyz');
%Note that you will need to let pointCloud know if you want to import
%additional parameters/attributes such as colors or intensity.
%golm_airlidar = pointCloud('golm_airlidar_utm33u_wgs84_rgb_cl_xyzrgb.xyz', 'Attributes', {'I' 'r' 'g' 'b'});

% Point Clouds can be visualized with:
golm_airlidar.plot;
view(3); title('Z-colored plot of airborne lidar point cloud', 'Color', 'w');

% Instead of loading the entire pointcloud, there exist a clip confined to
% the university campus Golm:
golm_airlidar = pointCloud('golm_airlidar_utm33u_wgs84_rgb_cl_campus.laz');
golm_airlidar.save('golm_airlidar_utm33u_wgs84_rgb_cl_campus.mat')

%% Second step: Load in ebee point from March-25-2017
%can also be written to las file
ebee_25march = pointCloud('ebee_Golm_Color_25March2017_agisoft_25cm.laz');
ebee_25march.save('ebee_Golm_Color_25March2017_agisoft_25cm.mat')

% view both point clouds
golm_airlidar.plot('Color', 'y'); % yellow
ebee_25march.plot('Color', 'm'); % magenta
%You could add additional point clouds here

% Set three-dimensional view and add title
view(3); title('Airborne lidar (=yellow) and Ebee-25-March-2017 (=magenta)', 'Color', 'w');

%% Perform Iterative Closest Point alignment for Campus Golm dataset
%Clear out and make sure there is enough memory:
clear all
golm_icp = globalICP;

% Add point clouds to object from xyz or mat files.
%First point cloud is the fixed point cloud
golm_icp.addPC('golm_airlidar_utm33u_wgs84_rgb_cl_campus.mat');
golm_icp.addPC('ebee_Golm_Color_25March2017_agisoft_25cm.mat');

%Note that pointclouds are vertically (Z-axis) offset by ~5m!

% Both point clouds can be visualized:
%golm_icp.plot('Color', 'by PC');
%title('Golm - BEFORE ICP'); view(0,0); set(gcf, 'Name', 'BEFORE ICP');
%Click on the icon to show individual point clouds.
% Note that the point clouds are taken from different times and that land
% surface (i.e. buildings, roads), changed between the datasets

% Define options for runICP - see help globalICP.runICP
ICPOptions.UniformSamplingDistance  = 4;
ICPOptions.PlaneSearchRadius        = 5;
ICPOptions.MaxRoughness             = 0.1;
%ICPOptions.NoOfTransfParam          = 6;
ICPOptions.Plot                     = true;
ICPOptions.NormalSubsampling        = true;
ICPOptions.MaxLeverageSubsampling   = false;
ICPOptions.SubsamplingPercentPoi    = 75;

% Run ICP on two point clouds
golm_icp.runICP(ICPOptions);

%After alignment, extract rotation/transformation matrix
golm_icp.D.H{2}

% You can use this rotation matrix to rotate the original, high-resolution
% dataset with CloudCompare, lastools, PCL, or other software. In Matlab,
% you can use pctransform:
%rotation_matrix = affine3d(golm_icp.D.H{2});
%pctransform(ptcloud, rotation_matrix);

%export adjusted (moved) pointcloud as text file (use ending .las/.laz for LAS file):
golm_icp.exportPC(2, 'ebee_Golm_Color_25March2017_agisoft_25cm_POSTICP.xyz',  'Attributes', {'r' 'g' 'b'});
%convert to LAZ format (in cmd tools with proper path)
%las2las.exe -i ebee_Golm_Color_25March2017_agisoft_25cm_POSTICP.xyz -iparse xyzRGB -olaz -o ebee_Golm_Color_25March2017_agisoft_25cm_POSTICP.laz

%export adjusted (moved) pointcloud as LAZ file:
golm_icp.exportPC(2, 'ebee_Golm_Color_25March2017_agisoft_25cm_POSTICP.laz');

%compare point clouds before/after ICP:
golm_airlidar = pointCloud('golm_airlidar_utm33u_wgs84_rgb_cl_campus.mat');
ebee_25march = pointCloud('ebee_Golm_Color_25March2017_agisoft_25cm.mat');
ebee_25march_posticp = pointCloud('ebee_Golm_Color_25March2017_agisoft_25cm_POSTICP.xzy',  'Attributes', {'r' 'g' 'b'});

golm_airlidar.plot('Color', 'y'); % yellow
ebee_25march.plot('Color', 'm'); % magenta
ebee_25march_posticp.plot('Color', 'w'); % white

%% Load Ebee from 25-May-2017 (ooc, Pix4D)
%convert from LAZ to Matlab:
ebee_25may_ooc_pix4d = pointCloud('ebee_Golm_Color_25May2017_pix4d_4matches_ooc_25cm.laz');
ebee_25may_ooc_pix4d.save('ebee_Golm_Color_25May2017_pix4d_4matches_ooc_25cm.mat')

%% Optional step: Align ebee point clouds from March-25 and May-25
clear all
golm_icp = globalICP;

%First point cloud is the fixed point cloud
golm_icp.addPC('ebee_Golm_Color_25March2017_agisoft_25cm_POSTICP.mat');
golm_icp.addPC('ebee_Golm_Color_25May2017_pix4d_4matches_ooc_25cm.mat');

ICPOptions.UniformSamplingDistance  = 4;
ICPOptions.PlaneSearchRadius        = 5;
ICPOptions.MaxRoughness             = 0.1;
%ICPOptions.NoOfTransfParam          = 6;
ICPOptions.Plot                     = true;
ICPOptions.NormalSubsampling        = false;
ICPOptions.MaxLeverageSubsampling   = true;
ICPOptions.SubsamplingPercentPoi    = 75;
% Run ICP on two point clouds
golm_icp.runICP(ICPOptions);

%After alignment, extract rotation/transformation matrix
golm_icp.D.H{2}
%   0.999999999728490   0.000001921440244   0.000023223417655 -12.815192161918374
%  -0.000001921405221   0.999999999997017  -0.000001508117163   0.000000821166007
%  -0.000023223420552   0.000001508072541   0.999999999729199   0.000787257485451
%                   0                   0                   0   1.000000000000000

%save
golm_icp.exportPC(2, 'ebee_Golm_Color_25May2017_pix4d_4matches_ooc_25cm_POSTICP_25March2017.laz');

%or:
golm_icp.exportPC(2, 'ebee_Golm_Color_25May2017_pix4d_4matches_ooc_25cm_POSTICP_25March2017.xyz', 'Attributes', {'r' 'g' 'b'});
%las2las.exe -i ebee_Golm_Color_25May2017_pix4d_4matches_ooc_25cm_POSTICP_25March2017.xyz -iparse xyzRGB -olaz -o ebee_Golm_Color_25May2017_pix4d_4matches_ooc_25cm_POSTICP_25March2017.laz

%and compare:
ebee_25march = pointCloud('ebee_Golm_Color_25March2017_agisoft_25cm_POSTICP.mat');
ebee_25may = pointCloud('ebee_Golm_Color_25May2017_pix4d_4matches_ooc_25cm.mat');
ebee_25may_posticp = pointCloud('ebee_Golm_Color_25May2017_pix4d_4matches_ooc_25cm_POSTICP_25March2017.xyz', 'Attributes', {'r' 'g' 'b'});

ebee_25march.plot('Color', 'y'); % yellow
ebee_25may.plot('Color', 'm'); % magenta
ebee_25may_posticp.plot('Color', 'w'); % white

%% Third step: Load three point clouds and align
clear all
close all

golm_icp = globalICP;

% Add point clouds to object from xyz or mat files.
%First point cloud is the fixed point cloud
golm_icp.addPC('golm_airlidar_utm33u_wgs84_rgb_cl_campus.mat');
%Use pointcloud from previous ICP run:
golm_icp.addPC('ebee_Golm_Color_25March2017_agisoft_25cm_POSTICP.laz');
%or
%golm_icp.addPC('ebee_Golm_Color_25March2017_agisoft_25cm_POSTICP.xzy',  'Attributes', {'r' 'g' 'b'});
golm_icp.addPC('ebee_Golm_Color_25May2017_pix4d_4matches_ooc_25cm_POSTICP_25March2017.laz');
%golm_icp.addPC('ebee_Golm_Color_25May2017_pix4d_4matches_ooc_25cm_POSTICP_25March2017.xyz', 'Attributes', {'r' 'g' 'b'});

%Visually inspect the point clouds:
golm_icp.plot()

ICPOptions.UniformSamplingDistance  = 10;
ICPOptions.PlaneSearchRadius        = 4;
ICPOptions.MaxRoughness             = 0.1;
%ICPOptions.NoOfTransfParam          = 6;
ICPOptions.Plot                     = true;
ICPOptions.NormalSubsampling        = true;
ICPOptions.MaxLeverageSubsampling   = false;
ICPOptions.SubsamplingPercentPoi    = 75;
% Run ICP on three point clouds
golm_icp.runICP(ICPOptions);

%export adjusted (moved) pointcloud as text file (use ending .las/.laz for LAS file):
golm_icp.exportPC(2, 'ebee_Golm_Color_25March2017_agisoft_25cm_POSTICP2.xyz',  'Attributes', {'r' 'g' 'b'});
%convert to LAZ format (in cmd tools with proper path)
%las2las.exe -i ebee_Golm_Color_25March2017_agisoft_25cm_POSTICP2.xyz -iparse xyzRGB -olaz -o ebee_Golm_Color_25March2017_agisoft_25cm_POSTICP2.laz

%export adjusted (moved) pointcloud as LAZ file:
golm_icp.exportPC(2, 'ebee_Golm_Color_25March2017_agisoft_25cm_POSTICP2.laz');

golm_icp.exportPC(3, 'ebee_Golm_Color_25May2017_pix4d_4matches_ooc_25cm_POSTICP2.laz');
golm_icp.exportPC(3, 'ebee_Golm_Color_25May2017_pix4d_4matches_ooc_25cm_POSTICP2.xyz',  'Attributes', {'r' 'g' 'b'});
%las2las.exe -i ebee_Golm_Color_25May2017_pix4d_4matches_ooc_25cm_POSTICP2.xyz -iparse xyzRGB -olaz -o ebee_Golm_Color_25May2017_pix4d_4matches_ooc_25cm_POSTICP2.laz

%compare point clouds before/after ICP:
golm_airlidar = pointCloud('golm_airlidar_utm33u_wgs84_rgb_cl_campus.mat');
ebee_25march = pointCloud('ebee_Golm_Color_25March2017_agisoft_25cm.mat');
ebee_25march_posticp = pointCloud('ebee_Golm_Color_25March2017_agisoft_25cm_POSTICP.xyz', 'Attributes', {'r' 'g' 'b'});
ebee_25may_pix4d = pointCloud('ebee_Golm_Color_25May2017_pix4d_4matches_ooc_25cm.mat');
ebee_25may_pix4d = pointCloud('ebee_Golm_Color_25May2017_pix4d_4matches_ooc_25cm_POSTICP.xyz', 'Attributes', {'r' 'g' 'b'});

golm_airlidar.plot('Color', 'y'); % yellow
ebee_25march.plot('Color', 'm'); % magenta
ebee_25march_posticp.plot('Color', 'w'); % white
ebee_25may.plot('Color', 'g'); % magenta
ebee_25may_posticp.plot('Color', 'b'); % white

