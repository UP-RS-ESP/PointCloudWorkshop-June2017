cd F:/LAZ
%set path to Point-cloud processing tool
addpath(genpath('C:\Users\bodob\Dropbox\Teaching\DDA_SS17\labs\lab3-ICP\pglira-Point_cloud_tools_for_Matlab-0cad900'))
%Mac OSX and Linux use:
%addpath(genpath('/home/bodo/Dropbox/Teaching/DDA_SS17/labs/lab3-ICP/pglira-Point_cloud_tools_for_Matlab-0cad900'))
%%
golm_H27_MuseX5_30m = pointCloud('Golm_250517_Haus27_29_H30m_Pix4D_densified_ptcloud_5cm.laz');
%Quick'n'dirty offset adjustment by adding 75m to Z component
golm_H27_MuseX5_30m.X(:,3) = golm_H27_MuseX5_30m.X(:,3) + 75;
golm_H27_MuseX5_30m.save('Golm_250517_Haus27_29_H30m_Pix4D_densified_ptcloud_5cm.mat')

golm_H27_MuseX5_50m = pointCloud('Golm_250517_Haus27_29_H50m_Pix4D_densified_ptcloud_5cm.laz');
golm_H27_MuseX5_50m.X(:,3) = golm_H27_MuseX5_50m.X(:,3) + 75;
golm_H27_MuseX5_50m.save('Golm_250517_Haus27_29_H50m_Pix4D_densified_ptcloud_5cm.mat')

golm_H27_MuseX5_70m = pointCloud('Golm_250517_Haus27_29_H70m_Pix4D_densified_ptcloud_5cm.laz');
golm_H27_MuseX5_70m.X(:,3) = golm_H27_MuseX5_70m.X(:,3) + 75;
golm_H27_MuseX5_70m.save('Golm_250517_Haus27_29_H70m_Pix4D_densified_ptcloud_5cm.mat')

golm_H27_MuseX5_90m = pointCloud('Golm_250517_Haus27_29_H90m_Pix4D_densified_ptcloud_5cm.laz');
golm_H27_MuseX5_90m.X(:,3) = golm_H27_MuseX5_90m.X(:,3) + 75;
golm_H27_MuseX5_90m.save('Golm_250517_Haus27_29_H90m_Pix4D_densified_ptcloud_5cm.mat')

%% Align two point clouds to ebee-May-25-2017
clear all
close all
golm_icp = globalICP;

% Add point clouds to object from xyz or mat files.
%First point cloud is the fixed point cloud
golm_icp.addPC('ebee_Golm_Color_25May2017_pix4d_4matches_ooc_25cm_POSTICP.mat');
golm_icp.addPC('Golm_250517_Haus27_29_H30m_Pix4D_densified_ptcloud_5cm.mat');
ICPOptions.UniformSamplingDistance  = 4;
ICPOptions.PlaneSearchRadius        = 5;
ICPOptions.MaxRoughness             = 0.1;
ICPOptions.NoOfTransfParam          = 6;
ICPOptions.Plot                     = true;
ICPOptions.NormalSubsampling        = true;
ICPOptions.MaxLeverageSubsampling   = false;
ICPOptions.SubsamplingPercentPoi    = 75;
% Run ICP
golm_icp.runICP(ICPOptions);

% write pointclouds to LAZ files:
golm_icp.exportPC(2, 'Golm_250517_Haus27_29_H30m_Pix4D_densified_ptcloud_5cm_ICP_ebee_25May2017.laz')

%% Align two point clouds to ebee-May-25-2017
clear all
close all
golm_icp = globalICP;

% Add point clouds to object from xyz or mat files.
%First point cloud is the fixed point cloud
golm_icp.addPC('ebee_Golm_Color_25May2017_pix4d_4matches_ooc_25cm_POSTICP.mat');
golm_icp.addPC('Golm_250517_Haus27_29_H50m_Pix4D_densified_ptcloud_5cm.mat');
ICPOptions.UniformSamplingDistance  = 4;
ICPOptions.PlaneSearchRadius        = 5;
ICPOptions.MaxRoughness             = 0.1;
ICPOptions.NoOfTransfParam          = 6;
ICPOptions.Plot                     = true;
ICPOptions.NormalSubsampling        = true;
ICPOptions.MaxLeverageSubsampling   = false;
ICPOptions.SubsamplingPercentPoi    = 75;
% Run ICP
golm_icp.runICP(ICPOptions);

% write pointclouds to LAZ files:
golm_icp.exportPC(2, 'Golm_250517_Haus27_29_H50m_Pix4D_densified_ptcloud_5cm_ICP_ebee_25May2017.laz')

%% Align point clouds to ebee-May-25-2017
% *** THIS MAY TAKE A LONG TIME! ***
clear all
close all
golm_icp = globalICP;

% Add point clouds to object from xyz or mat files.
%First point cloud is the fixed point cloud
golm_icp.addPC('ebee_Golm_Color_25May2017_pix4d_4matches_ooc_25cm_POSTICP.mat');
golm_icp.addPC('Golm_250517_Haus27_29_H30m_Pix4D_densified_ptcloud_5cm.mat');
golm_icp.addPC('Golm_250517_Haus27_29_H50m_Pix4D_densified_ptcloud_5cm.mat');
golm_icp.addPC('Golm_250517_Haus27_29_H70m_Pix4D_densified_ptcloud_5cm.mat');
golm_icp.addPC('Golm_250517_Haus27_29_H90m_Pix4D_densified_ptcloud_5cm.mat');
%golm_H27_icp.plot()

ICPOptions.UniformSamplingDistance  = 6;
ICPOptions.PlaneSearchRadius        = 5;
ICPOptions.MaxRoughness             = 0.1;
ICPOptions.NoOfTransfParam          = 6;
ICPOptions.Plot                     = true;
ICPOptions.NormalSubsampling        = true;
ICPOptions.MaxLeverageSubsampling   = false;
ICPOptions.SubsamplingPercentPoi    = 75;
% Run ICP
golm_icp.runICP(ICPOptions);

% write pointclouds to LAZ files:
golm_icp.exportPC(2, 'Golm_250517_Haus27_29_H30m_Pix4D_densified_ptcloud_5cm_ICP_ebee_25May2017.laz')
golm_icp.exportPC(3, 'Golm_250517_Haus27_29_H50m_Pix4D_densified_ptcloud_5cm_ICP_ebee_25May2017.laz')
golm_icp.exportPC(4, 'Golm_250517_Haus27_29_H70m_Pix4D_densified_ptcloud_5cm_ICP_ebee_25May2017.laz')
golm_icp.exportPC(5, 'Golm_250517_Haus27_29_H90m_Pix4D_densified_ptcloud_5cm_ICP_ebee_25May2017.laz')

%On Mac OSX or Linux systems:
golm_icp.exportPC(2, 'Golm_250517_Haus27_29_H30m_Pix4D_densified_ptcloud_5cm_ICP_ebee_25May2017.xyz',  'Attributes', {'r' 'g' 'b'});
golm_icp.exportPC(3, 'Golm_250517_Haus27_29_H50m_Pix4D_densified_ptcloud_5cm_ICP_ebee_25May2017.xyz',  'Attributes', {'r' 'g' 'b'});
golm_icp.exportPC(4, 'Golm_250517_Haus27_29_H70m_Pix4D_densified_ptcloud_5cm_ICP_ebee_25May2017.xyz',  'Attributes', {'r' 'g' 'b'});
golm_icp.exportPC(5, 'Golm_250517_Haus27_29_H90m_Pix4D_densified_ptcloud_5cm_ICP_ebee_25May2017.xyz',  'Attributes', {'r' 'g' 'b'});
%convert to LAZ format (in cmd tools with proper path)
%las2las.exe -i Golm_250517_Haus27_29_H30m_Pix4D_densified_ptcloud_5cm_ICP_ebee_25May2017.xyz -iparse xyzRGB -olaz -o Golm_250517_Haus27_29_H30m_Pix4D_densified_ptcloud_5cm_ICP_ebee_25May2017.laz
%las2las.exe -i Golm_250517_Haus27_29_H50m_Pix4D_densified_ptcloud_5cm_ICP_ebee_25May2017.xyz -iparse xyzRGB -olaz -o Golm_250517_Haus27_29_H50m_Pix4D_densified_ptcloud_5cm_ICP_ebee_25May2017.laz
%las2las.exe -i Golm_250517_Haus27_29_H70m_Pix4D_densified_ptcloud_5cm_ICP_ebee_25May2017.xyz -iparse xyzRGB -olaz -o Golm_250517_Haus27_29_H70m_Pix4D_densified_ptcloud_5cm_ICP_ebee_25May2017.laz
%las2las.exe -i Golm_250517_Haus27_29_H90m_Pix4D_densified_ptcloud_5cm_ICP_ebee_25May2017.xyz -iparse xyzRGB -olaz -o Golm_250517_Haus27_29_H90m_Pix4D_densified_ptcloud_5cm_ICP_ebee_25May2017.laz

%and compare:
Golm_ebee_May25 = pointCloud('ebee_Golm_Color_25May2017_pix4d_4matches_ooc_25cm_POSTICP.mat');
Golm_DJI_H30m = pointCloud('Golm_250517_Haus27_29_H30m_Pix4D_densified_ptcloud_5cm_ICP_ebee_25May2017.xyz',  'Attributes', {'r' 'g' 'b'});
Golm_DJI_H50m = pointCloud('Golm_250517_Haus27_29_H50m_Pix4D_densified_ptcloud_5cm_ICP_ebee_25May2017.xyz',  'Attributes', {'r' 'g' 'b'});
Golm_DJI_H70m = pointCloud('Golm_250517_Haus27_29_H70m_Pix4D_densified_ptcloud_5cm_ICP_ebee_25May2017.xyz',  'Attributes', {'r' 'g' 'b'});
Golm_DJI_H90m = pointCloud('Golm_250517_Haus27_29_H90m_Pix4D_densified_ptcloud_5cm_ICP_ebee_25May2017.xyz',  'Attributes', {'r' 'g' 'b'});
Golm_ebee_May25.plot()
Golm_DJI_H30m.plot()
Golm_DJI_H50m.plot()
Golm_DJI_H70m.plot()
Golm_DJI_H90m.plot()

