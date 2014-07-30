clearvars; clc; close all;

pig = obj_read('PigData\results\id110\id_110_merged.obj');
pc2 = read_off('PigData\results\id110\part_1.off')';

% icp_data = struct;
% icp_data.num_iterations = 29;
% icp_data.pc1 = bunny_data.vert';
% icp_data.npc1 = bunny_data.norm';  % Optional parameter
% icp_data.pc2 = pc2';
% icp_data.npc2 = npc2';  % Optional parameter
% icp_data.m_pc2_initial = eye(4);
% icp_data.min_distance_sq = 1e-6;  % Optional parameter
% icp_data.max_distance_sq = 1e+3;  % Optional parameter
% icp_data.cos_normal_threshold = 0.9;  % Optional parameter
% icp_data.method = 1;  % Optional parameter
% 
% M_PC2_icp = icp(icp_data);
% 
% % Affine Transform position
% pc2_icp = (M_PC2_icp(1:3,1:3) * pc2' + repmat(M_PC2_icp(1:3,4), 1, size(bunny_data.vert,1)))';

figure;
set(gcf, 'Position', [200 200 1200 1200]);
scatter3(pc2(:,1), pc2(:,2), pc2(:,3),'b.'); hold on;
trimesh(pig.Tri'+1, pig.Position(1,:), pig.Position(2,:), pig.Position(3,:));
set(gcf,'renderer','opengl'); axis vis3d; axis equal;

% mean_err_before = mean(sum((pc2 - bunny_data.vert).^2, 2));
% mean_err_after = mean(sum((pc2_icp - bunny_data.vert).^2, 2));

% display(['Mean error before ICP: ', num2str(mean_err_before)]);
% display(['Mean error after ICP: ', num2str(mean_err_after)]);