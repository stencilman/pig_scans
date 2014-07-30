clearvars; clc; close all;

display('Loading the models from file');
pig = obj_read('PigData\results\id110\id_110_merged.obj');
pc2 = read_off('PigData\results\id029\part_1.off');
pc3 = read_off('PigData\results\id110\part_1.off');

% center the vertices at zero
pig.Position = pig.Position - repmat(mean(pig.Position, 2), 1, size(pig.Position,2));
pc2 = pc2 - repmat(mean(pc2, 2), 1, size(pc2,2));
pc3 = pc3 - repmat(mean(pc3, 2), 1, size(pc3,2));

% Now apply a global scale so that the coordinates are between 0 and 1
scale = max(pig.Position(:)) - min(pig.Position(:));
pig.Position = pig.Position / scale;
pc2 = pc2 / scale;
pc3 = pc3 / scale;

% Estimate the normals
% mesh = pointCloud2mesh(pc2);  % WAY TOO SLOW!
% TODO: ADD NORMALS!!!

% Start pc2 in a reasonable position
M_init = euler2RotMat(0, pi/4, 0);
M_init = rightMultScale(M_init, 1.0, 1.0, 1.0);
M_init = leftMultTranslation(M_init, 0.2, 0, 0);
pc2 = (M_init(1:3,1:3) * pc2 + repmat(M_init(1:3,4), 1, size(pc2,2)));
pc3 = (M_init(1:3,1:3) * pc3 + repmat(M_init(1:3,4), 1, size(pc3,2)));

icp_data = struct;
icp_data.num_iterations = 200;
icp_data.pc1 = pig.Position;
% icp_data.npc1 = pig.Normal;  % Optional parameter
icp_data.pc2 = pc2;
% icp_data.npc2 = npc2;  % Optional parameter
icp_data.m_pc2_initial = eye(4);
icp_data.min_distance_sq = 1e-6;  % Optional parameter
icp_data.max_distance_sq = 1e+1;  % Optional parameter
icp_data.cos_normal_threshold = 0.9;  % Optional parameter
icp_data.method = 1;  % Optional parameter
icp_data.match_scale = 0;  % Optional parameter
 
display('Running ICP');
M_PC2_icp = icp(icp_data);

% Affine Transform position
pc2_icp = (M_PC2_icp(1:3,1:3) * pc2 + repmat(M_PC2_icp(1:3,4), 1, size(pc2,2)));

display('Displaying the results');
figure;
set(gcf, 'Position', [200 200 1200 1200]);
scatter3(pc2(1,:), pc2(2,:), pc2(3,:),'b.'); hold on;
scatter3(pig.Position(1,:), pig.Position(2,:), pig.Position(3,:),3,'r.','LineWidth',0.5);
% trimesh(pig.Tri'+1, pig.Position(1,:), pig.Position(2,:), pig.Position(3,:));
scatter3(pc2_icp(1,:), pc2_icp(2,:), pc2_icp(3,:),'k.');
% scatter3(pc3(1,:), pc3(2,:), pc3(3,:),'g.')
set(gcf,'renderer','opengl'); axis vis3d; axis equal;
