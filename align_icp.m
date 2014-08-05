function [pc2_icp, icp_error] = align_icp(base_position, pc2, scale, rot_x, rot_y, rot_z)
% center the vertices at zero
pc2 = pc2 - repmat(mean(pc2, 2), 1, size(pc2,2));

% Now apply a global scale so that the coordinates are between 0 and 1
pc2 = pc2 / scale;

% Estimate the normals
% mesh = pointCloud2mesh(pc2);  % WAY TOO SLOW!
% TODO: ADD NORMALS!!!

% Start pc2 in a reasonable position
M_init = euler2RotMat(rot_x, rot_y, rot_z);
M_init = rightMultScale(M_init, 1.0, 1.0, 1.0);
M_init = leftMultTranslation(M_init, 0.2, 0, 0);
pc2 = (M_init(1:3,1:3) * pc2 + repmat(M_init(1:3,4), 1, size(pc2,2)));

icp_data = struct;
icp_data.num_iterations = 200;
icp_data.pc1 = base_position;
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
[M_PC2_icp, icp_error] = icp(icp_data);
% Affine Transform position
pc2_icp = (M_PC2_icp(1:3,1:3) * pc2 + repmat(M_PC2_icp(1:3,4), 1, size(pc2,2)));


