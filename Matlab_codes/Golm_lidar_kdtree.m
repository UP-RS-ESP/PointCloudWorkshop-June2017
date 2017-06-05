cd F:/LAZ
%set path to Point-cloud processing tool
addpath(genpath('C:\Users\bodob\Dropbox\Teaching\DDA_SS17\labs\lab3-ICP\pglira-Point_cloud_tools_for_Matlab-0cad900'))
%Mac OSX and Linux use:
%addpath(genpath('/home/bodo/Dropbox/Teaching/DDA_SS17/labs/lab3-ICP/pglira-Point_cloud_tools_for_Matlab-0cad900'))

%% Load ebee points and display
%you can load LAS data either with lasdata (https://www.mathworks.com/matlabcentral/fileexchange/48073-lasdata) or using the Point Cloud Tool (http://www.geo.tuwien.ac.at/downloads/pg/pctools/pctools.html)
%LAZ data can be read with the Point Cloud Tool 
golm_airlidar = pointCloud('golm_airlidar_utm33u_wgs84_rgb_cl_campus.laz');
golm_ebee_25March2017 = pointCloud('ebee_Golm_Color_25March2017_agisoft_25cm_POSTICP.laz');
%golm_ebee_25March2017.save('ebee_Golm_Color_25March2017_agisoft_25cm_POSTICP.mat')
golm_ebee_25May2017 = pointCloud('ebee_Golm_Color_25May2017_pix4d_4matches_ooc_25cm_POSTICP_25March2017.laz');
%golm_ebee_25May2017.save('ebee_Golm_Color_25May2017_pix4d_4matches_ooc_25cm_POSTICP_25March2017.mat')
golm_airlidar.plot()
golm_ebee_25March2017.plot()
golm_ebee_25May2017.plot()

% golm_airlidar.X contains coordinates
% You could also remove x and y offset to make array with similar
% significant numbers, because UTM coordinates have either 6 or 7 digits.

%If Matlab R2016b or newer, use blocktree to visualize graph
%golm_airlidar_3D_tree = bctree(golm_airlidar.X);

%% Initiate kd-tree structures
golm_ebee_25March2017_ns = createns(golm_ebee_25March2017.X);
golm_ebee_25May2017_ns = createns(golm_ebee_25May2017.X);

%search for one nearest neighbor, using airborne lidar data as seed data:
%Note that the extent of the data are very different:
%golm_ebee_25March2017.lim and golm_airlidar.lim
[ebee_25March2017_idx_nn, ebee_25March2017_dist_nn] = knnsearch(golm_ebee_25March2017_ns, golm_airlidar.X);
[ebee_25May2017_idx_nn, ebee_25May2017_dist_nn] = knnsearch(golm_ebee_25May2017_ns, golm_airlidar.X);
%remove all distances above 1m (likely mismatch because of different
%dataset extent):
ebee_25March2017_dist_nn_idx1m = find(ebee_25March2017_dist_nn > 1);
golm_airlidar_clip = golm_airlidar;
golm_airlidar_clip.X(ebee_25March2017_idx_nn(ebee_25March2017_dist_nn_idx1m),:) = [];
ebee_25March2017_idx_nn(ebee_25March2017_dist_nn_idx1m) = [];
ebee_25March2017_dist_nn(ebee_25March2017_dist_nn_idx1m) = [];


%% Plot results:
figure(1),
clf
%First, the distances of each point as histogram:
subplot(2,2,1,'align')
hist(ebee_25March2017_dist_nn, 50)
xlabel('Distance between lidar datasets for each point (m)', 'Fontsize', 12)
ylabel('occurrence (#)', 'Fontsize', 12)
grid
title('ebee-25-March-2017 Distance', 'Fontsize', 16)

%Second, the elevations for the nearest points:
subplot(2,2,2,'align')
plot(golm_airlidar_clip.X(:,3), golm_ebee_25March2017.X(ebee_25March2017_idx_nn,3), '+')
xlabel('Airborne lidar height (m)', 'Fontsize', 12)
ylabel('ebee height of nearest point (m)', 'Fontsize', 12)
grid
title('ebee-25-March-2017 Elevations', 'Fontsize', 16)

%Third, the range of elevations for the nearest points:
subplot(2,2,3,'align')
plot(golm_airlidar_clip.X(:,3), golm_airlidar_clip.X(:,3)-golm_ebee_25March2017.X(ebee_25March2017_idx_nn,3), 'o')
xlabel('Airborne lidar height (m)', 'Fontsize', 12)
ylabel('\Delta ebee height of nearest point (m)', 'Fontsize', 12)
grid
title('ebee-25-March-2017 Elevation difference', 'Fontsize', 16)

%Fourth, a histogram of the range of elevation differences for the nearest points:
subplot(2,2,4,'align')
hist(golm_airlidar_clip.X(:,3)-golm_ebee_25March2017.X(ebee_25March2017_idx_nn,3), 50)
xlabel('elevation difference (m)', 'Fontsize', 12)
ylabel('occurrence (#)', 'Fontsize', 12)
grid
title('ebee-25-March-2017 Elevation difference histogram', 'Fontsize', 16)

%% Calculating 3-m micro-relief based on airborne point cloud:
% You can apply the kd-tree algorithm to the same pointcloud to obtain statistical information about the point cloud.
%Generate microrelief from airborne point cloud:
golm_airlidar_ns = createns(golm_airlidar.X);

%Get subset of point, 1-m uniform sampling and export
golm_airlidar.select('UniformSampling', 1);
golm_airlidar.export('golm_airlidar_utm33u_wgs84_rgb_cl_campus_Uniform_1m.xyz')

%quick'n'dirty subset
golm_airlidar_1m = golm_airlidar;
idx=find(golm_airlidar_1m.act == 0);
golm_airlidar_1m.X(idx,:) = [];
golm_airlidar_1m.act(idx,:) = [];


%find all points within radius of 3m
[golm_airlidar_1m_idx, golm_airlidar_1m_dist] = rangesearch(golm_airlidar_ns,golm_airlidar_1m.X, 3);
%first column is always index to itself

golm_airlidar_relief_3m = NaN(length(golm_airlidar_1m_idx), 3);
%find range of elevation for each point (will take a few minutes, there are better ways to calculate this for loop):
for i = 1:length(golm_airlidar_1m_idx)
    golm_airlidar_relief_3m(i,:) = [golm_airlidar_1m.X(i,1) golm_airlidar_1m.X(i,2) max(golm_airlidar_ns.X(golm_airlidar_1m_idx{i},3)) - min(golm_airlidar_ns.X(golm_airlidar_1m_idx{i},3))];
end

%topographic variance:
golm_airlidar_variance_3m = NaN(length(golm_airlidar_1m_idx), 3);
%find range of elevation for each point (will take a few minutes, there are better ways to calculate this for loop):
for i = 1:length(golm_airlidar_1m_idx)
    golm_airlidar_variance_3m(i,:) = [golm_airlidar_1m.X(i,1) golm_airlidar_1m.X(i,2) var(golm_airlidar_ns.X(golm_airlidar_1m_idx{i},3))];
end

%% Repeat with ebee 25-March-2017 dataset: 3-m relief with pointclouds
golm_ebee_25March2017_ns = createns(golm_ebee_25March2017.X);

%Get subset of point, 1-m uniform sampling and export
golm_ebee_25March2017.select('UniformSampling', 1);

%quick'n'dirty subset
golm_ebee_25March2017_1m = golm_ebee_25March2017;
idx=find(golm_ebee_25March2017_1m.act == 0);
golm_ebee_25March2017_1m.X(idx,:) = [];
golm_ebee_25March2017_1m.act(idx,:) = [];

%find all points within radius of 3m
[golm_ebee_25March2017_1m_idx, golm_ebee_25March2017_1m_dist] = rangesearch(golm_ebee_25March2017_ns,golm_ebee_25March2017_1m.X, 3);
%first column is always index to itself

golm_ebee_25March2017_relief_3m = NaN(length(golm_ebee_25March2017_1m_idx), 1);
golm_ebee_25March2017_variance_3m = NaN(length(golm_ebee_25March2017_1m_idx), 1);
%find range of elevation for each point (will take a few minutes, there are better ways to calculate this for loop):
for i = 1:length(golm_ebee_25March2017_1m_idx)
    golm_ebee_25March2017_relief_3m(i) = max(golm_ebee_25March2017_ns.X(golm_ebee_25March2017_1m_idx{i},3)) - min(golm_ebee_25March2017_ns.X(golm_ebee_25March2017_1m_idx{i},3));
    golm_ebee_25March2017_variance_3m(i) = var(golm_ebee_25March2017_ns.X(golm_ebee_25March2017_1m_idx{i},3));
end

%write header to csv
filename_csv = 'golm_ebee_25March2017_1m_rel3m_var3m.csv';
fid = fopen(filename_csv, 'wt');
fprintf(fid, '%s, %s, %s, %s, %s', 'UTM_X','UTM_Y','UTM_Z', 'Rel3m', 'Var3m');  % header
fclose(fid);
dlmwrite(filename_csv, [golm_ebee_25March2017_1m.X(:,1) golm_ebee_25March2017_1m.X(:,2) golm_ebee_25March2017_1m.X(:,3) golm_ebee_25March2017_relief_3m golm_ebee_25March2017_variance_3m], 'precision', '%10.3f', 'delimiter', ',', '-append');

%find minimum and maximum coordinates for gdal_grid command line option (can also be used to automatically generate command):
format long
min_x = golm_ebee_25March2017_1m.lim.min(1)
max_x = golm_ebee_25March2017_1m.lim.max(1)
nr_of_x_pixels = max_x- min_x
min_y = golm_ebee_25March2017_1m.lim.min(2)
max_y = golm_ebee_25March2017_1m.lim.max(2)
nr_of_y_pixels = max_y- min_y

%generate a vrt file and save as: golm_ebee_25March2017_1m_rel3m_var3m.vrt
% <OGRVRTDataSource>
%   <OGRVRTLayer name="golm_ebee_25March2017_1m_rel3m_var3m">
%     <SrcDataSource>golm_ebee_25March2017_1m_rel3m_var3m.csv</SrcDataSource>
%     <SrcLayer>golm_ebee_25March2017_1m_rel3m_var3m</SrcLayer>
%     <GeometryType>wkbPoint</GeometryType>
%     <LayerSRS>epsg:32633</LayerSRS>
%     <GeometryField encoding="PointFromColumns" x="field_1" y="field_2"/>
%   </OGRVRTLayer>
% </OGRVRTDataSource>
%now interpolate from point file to grid (1-m spatial resolution)
%run in OSGeo4W Shell (will take ~2 minutes):
%gdal_grid -outsize 604 663 -txe 3.620095500000000e+05 3.626135500000000e+05 -tye 5.808162180000000e+06 5.808825500000000e+06 -ot Float32 -of GTIFF -co COMPRESS=LZW -l golm_ebee_25March2017_1m_rel3m_var3m -zfield field_4 -a_srs epsg:32633 -a nearest golm_ebee_25March2017_1m_rel3m_var3m.vrt golm_ebee_25March2017_1m_rel3m_utm33_wgs84.tif
%gdalinfo -hist -stats golm_ebee_25March2017_1m_rel3m_utm33_wgs84.tif
% tif should be clipped with a polygon
%view with QGIS or ArcMAP
%% Repeat with different radius!

%% Optional: Octrees ebee
%This requires: https://www.mathworks.com/matlabcentral/fileexchange/40732-octree-partitioning-3d-points-into-spatial-subvolumes
ebee_OT = OcTree(golm_ebee_25March2017.X,'binCapacity',20);        
figure(3), clf
boxH = ebee_OT.plot;
cols = lines(ebee_OT.BinCount);
doplot3 = @(p,varargin)plot3(p(:,1),p(:,2),p(:,3),varargin{:});
for i = 1:ebee_OT.BinCount
    set(boxH(i),'Color',cols(i,:),'LineWidth', 1+ebee_OT.BinDepths(i))
	doplot3(golm_ebee_25March2017.X(ebee_OT.PointBins==i,:),'.','Color',cols(i,:))
end
axis image, view(3)
grid on
title('Octree view of ebee 25-March-2017 pointcloud with n=20 bins', 'Fontsize', 16)
xlabel('UTM-X'), ylabel('UTM-Y'), zlabel('UTM-Z')

%% Optional: Octrees Airborne Lidar
airlidar_OT = OcTree(golm_airlidar.X,'binCapacity',20);        
figure(4), clf
boxH = airlidar_OT.plot;
cols = lines(airlidar_OT.BinCount);
doplot3 = @(p,varargin)plot3(p(:,1),p(:,2),p(:,3),varargin{:});
for i = 1:airlidar_OT.BinCount
    set(boxH(i),'Color',cols(i,:),'LineWidth', 1+airlidar_OT.BinDepths(i))
	doplot3(golm_airlidar.X(airlidar_OT.PointBins==i,:),'.','Color',cols(i,:))
end
axis image, view(3)
grid on
title('Octree view of airborne pointcloud with n=20 bins', 'Fontsize', 16)
xlabel('UTM-X'), ylabel('UTM-Y'), zlabel('UTM-Z')
