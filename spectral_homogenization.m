clear
close all

%% RUN THIS SCRIPT ONLY ONCE!!! IT Works!!
% Otherwise you overwrite the files too much

%% specify which row is your RABA if you have no RABA set to 0
RABA = 9;

% Specify your directory twice
direct = 'F:/SP1_3-11/';
cd F:/SP1_3-11/;
Meta_locs = dir("SP1-*_2*-*/Products/Metadata/Spectral_Indices.csv");

%% Code

for i = 1:length(Meta_locs)
    paths(i) = string(Meta_locs(i).folder)+"\"+string(Meta_locs(i).name);
    [~,~, dat{i}] = xlsread(paths(i));
    dtimestr = replace(strsplit(datestr(datetime)),':','-')
    writecell(dat{i},string(Meta_locs(i).folder)+"\"+"Spectral_indices_backup_"+date+"_"+dtimestr(2)+".csv")
    sz = size(dat{i});
    for k = 2:sz(2)-1
        minimums(i,k-1) = dat{i}{12,k};
        maximums(i,k-1) = dat{i}{13,k};
    end     
    if RABA > 1; armi(i,:) = str2double(strsplit(dat{i}{12,RABA},'|')); arma(i,:) = str2double(strsplit(dat{i}{13,RABA},'|')); end
end

if RABA > 1; new_raba_min = min(armi,[],1); new_raba_max = max(arma,[],1); end
newmin = min(minimums,[],1);
newmax = max(maximums,[],1);
for i = 1:length(Meta_locs)
    if RABA > 1; dat{i}(12,RABA) = cellstr(join(string(new_raba_min),"|")); dat{i}(13,RABA) = cellstr(join(string(new_raba_max),"|")); end
    dat{i}(12,2:sz(2)-1) = num2cell(newmin);
    dat{i}(13,2:sz(2)-1) = num2cell(newmax);
    % Overwrite the Spectral indices file in all folders: CTRL+T to
    % uncomment
%     writecell(dat{i},string(Meta_locs(i).folder)+"\"+string(Meta_locs(i).name))
end

% Produce one homogenized file in the main folder
writecell(dat{i},direct+"Spectral_Indices_Homogenized.csv")






