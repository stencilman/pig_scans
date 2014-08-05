idx = 29;
files = dir('F000*.mat');
load(files(idx).name);

cols={'y','m','c','b','r','g','w'};


subsmp = 1;
dist = 2000;
display(length(pointCloudSeq));
%noscans = [noscans length(pointCloudSeq)];


for i=1:length(pointCloudSeq)
    part = pointCloudSeq{i};
    size(part)
    
    x=part(1:subsmp:end,1);
    y=part(1:subsmp:end,2);
    z=part(1:subsmp:end,3);
    
    write_off(['part_' num2str(i) '.off'],[x,y,z]);
    
end