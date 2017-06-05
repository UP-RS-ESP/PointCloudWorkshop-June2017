%% Clip an even surface from a point cloud using lasclip.exe and a polygon
%This requires polyfitn (https://www.mathworks.com/matlabcentral/fileexchange/34765-polyfitn)
% Load point cloud using Point Cloud Tools or lasdata
%you can load LAS data either with lasdata (https://www.mathworks.com/matlabcentral/fileexchange/48073-lasdata) or using the Point Cloud Tool (http://www.geo.tuwien.ac.at/downloads/pg/pctools/pctools.html)
% NOTE: You will have to generate a polygon clip and clip a small (~2x2 m area)
[ALS_clip1] = lasdata('golm_airlidar_utm33u_wgs84_rgb_clip1.las');

ALS_clip1.get_intensity();
ALS_clip1.get_classification();
plot3(ALS_clip1.x, ALS_clip1.y, ALS_clip1.z, '+'); grid

ALS_x = ALS_clip1.x;
ALS_y = ALS_clip1.y;
ALS_z = ALS_clip1.z; 

ALS_linfit3D = polyfitn([ALS_x, ALS_y], ALS_z,1);
%equation: f(x,y) = a*x + b*y + c
%Test for center of plane:
%Coefficients: [X Y Z]
ALS_x_mean = mean(ALS_x);
ALS_y_mean = mean(ALS_y);
%z = ALS_x_mean * 0.0086 + (-9.3957e-04 * ALS_y_mean) + 2.3754e+03;

[ALS_xx, ALS_yy]=meshgrid(min(ALS_x):0.1:max(ALS_x), min(ALS_y):0.1:max(ALS_y));
ALS_zz = polyvaln(ALS_linfit3D, [ALS_xx(:) ALS_yy(:)]);
ALS_zz = reshape(ALS_zz, size(ALS_xx));
figure(1), clf
L=plot3(ALS_x, ALS_y, ALS_z,'b+'); % Plot the original data points
hold on
grid on
surf(ALS_xx, ALS_yy, ALS_zz) % Plotting the surface

ALS_z_detrend = NaN(length(ALS_x), 1);
for i = 1:length(ALS_x)
    ALS_z_detrend(i) = ALS_z(i) - polyvaln(ALS_linfit3D, [ALS_x(i) ALS_y(i)]);
end


figure(2), clf
title('Distance from the fitted plane', 'Fontsize', 16)
plot(ALS_z_detrend), hold on, grid on, 
plot([0 350], [mean(ALS_z_detrend) mean(ALS_z_detrend)], 'k-', 'Linewidth', 2)
plot([0 350], [mean(ALS_z_detrend)-std(ALS_z_detrend) mean(ALS_z_detrend)-std(ALS_z_detrend)], 'k-', 'Linewidth', 1)
plot([0 350], [mean(ALS_z_detrend)+std(ALS_z_detrend) mean(ALS_z_detrend)+std(ALS_z_detrend)], 'k-', 'Linewidth', 1)
xlabel('number of datapoints', 'FontSize', 12)
ylabel('Distance from fitted plane (m)', 'Fontsize', 12)

%% Optional: Write files to text file (xyz) to load into point cloud viewer.
ALS_clip1_plane = ALS_clip1;
ALS_clip1_plane.x = reshape(ALS_xx, numel(ALS_xx), 1); 
ALS_clip1_plane.y = reshape(ALS_yy, numel(ALS_yy), 1); 
ALS_clip1_plane.z = reshape(ALS_zz, numel(ALS_zz), 1); 
ALS_clip1_plane_xyz = [ALS_clip1_plane.x, ALS_clip1_plane.y, ALS_clip1_plane.z];
dlmwrite('golm_airlidar_utm33u_wgs84_rgb_clip1_plane.xyz', ALS_clip1_plane_xyz, 'delimiter', '\t', 'precision','%10.3f');

%% Optional: Prepare structure to write as LAS file for displaying with lasview, displaz, or CloudCompare

ALS_clip1_plane.classification = zeros(numel(ALS_zz), 1, 'int8');
ALS_clip1_plane.filename = 'golm_airlidar_utm33u_wgs84_rgb_clip1_plane.las';
ALS_clip1_plane.selection = ones(numel(ALS_zz), 1, 'int8');
ALS_clip1_plane.header.number_of_point_records = numel(ALS_zz);
ALS_clip1_plane.header.max_x = max(ALS_clip1_plane.x);
ALS_clip1_plane.header.min_x = min(ALS_clip1_plane.x);
ALS_clip1_plane.header.max_y = max(ALS_clip1_plane.y);
ALS_clip1_plane.header.min_y = min(ALS_clip1_plane.y);
ALS_clip1_plane.header.max_z = max(ALS_clip1_plane.z);
ALS_clip1_plane.header.min_z = min(ALS_clip1_plane.z);
ALS_clip1_plane.header.system_identifier = 'Fitted linear plane by B. Bookhagen';

lasdata(ALS_clip1_plane
