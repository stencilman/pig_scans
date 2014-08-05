function [base_position, pc2_icp, icp_error] = align_icp_multiple_rot(base_position, pc2)

% center the vertices at zero
base_position = base_position - repmat(mean(base_position, 2), 1, size(base_position,2));
% Now apply a global scale so that the coordinates are between 0 and 1
scale = max(base_position(:)) - min(base_position(:));
base_position = base_position / scale;

all_pc2_icp = {};
all_err = [];


idx = 1;
rot_x = 0;
rot_y = pi;
rot_z = 0;
for rot_x=0:pi/4:pi
    for rot_y=0:pi/4:pi
        for rot_z=0:pi/4:pi
            [pc2_this, err] = align_icp(base_position, pc2, scale, rot_x, rot_y, rot_z);
            all_pc2_icp{idx} = pc2_this;
            all_err = [all_err err];
            idx = idx + 1;
        end
    end
end
[icp_error, idx] = min(all_err);
pc2_icp = all_pc2_icp{idx};

