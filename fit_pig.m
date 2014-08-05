clearvars; clc; close all;
addpath('Y:\ajain\deep_nets\matlab\export_fig');
files = dir('raw_scans/F000*.mat');
base_pigs = dir('base_pigs\*.obj');


for idx = 20:10:120
    load(['raw_scans/' files(idx).name]);
    scan_name = strsplit(files(idx).name, '.');
    scan_name = scan_name{1};
    output_dir = ['C:\Users\arjun\Desktop\pigshit\match_results\' scan_name];
    mkdir(output_dir);
    if length(pointCloudSeq) < 4
        disp('length(pointCloudSeq) < 4, continue ;');
        continue;
    end
    for i = 1:length(pointCloudSeq)
        for p = 1:length(base_pigs)
            pig = obj_read(['base_pigs\' base_pigs(p).name]);
            base_position = pig.Position;
            
            pc2 = pointCloudSeq{i};
            pc2 = pc2(:,1:3)';
            
            [base_position, pc2_icp, icp_error] = align_icp_multiple_rot(base_position, pc2);
            
            display('Displaying the results');
            figure;
            set(gcf, 'Position', [200 200 800 800]);
            % scatter3(pc2(1,:), pc2(2,:), pc2(3,:),'b.'); hold on;
            scatter3(base_position(1,:), base_position(2,:), base_position(3,:),'r.'); hold on;
            %trimesh(pig.Tri'+1, base_position(1,:), base_position(2,:), base_position(3,:));
            scatter3(pc2_icp(1,:), pc2_icp(2,:), pc2_icp(3,:),'k.');
            set(gcf,'renderer','opengl'); axis vis3d; axis equal;
            title(['Error reported by ICP: ', num2str(icp_error)]);
            
            export_fig([output_dir, '\base_', num2str(p), '_scan_', num2str(i),'.jpg'], gcf, '-a4', '-jpg');
            close(gcf);
        end
    end
end