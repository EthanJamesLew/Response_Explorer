clc; clear;

FILE_DIR = 'NEW/'
FILENAME = 'globalview_new.mat'
DAT_SIZE =  408
SITES = 200

fid = fopen(strcat(FILE_DIR, 'Concentration_data.txt'));
locs = cell(SITES, 1);
lons = zeros(SITES, 1);
lats = zeros(SITES, 1);
levs = zeros(SITES, 1);
cons = zeros(SITES, DAT_SIZE);
errs = zeros(SITES, DAT_SIZE);


i = 1;
j = 1;
k = 1;

while ~feof(fid)
    curr = fgets(fid);
    
    number = str2num(curr); 
    %number_array = strsplit(curr);
    %number_array(strcmp('',number_array)) = [];
    %number_array = cellfun(@str2num,number_array,'un',0);
    
    if isempty(number)
        locs{k} = curr(1:length(curr)-1);
        k = k + 1;
    elseif numel(number) == 3
        %lll = str2num(number_array);
        lats(j) = number(2); 
        lons(j) = number(1);
        levs(j) = number(3);
        j = j + 1;
    else
        %dat = str2num(number_array);
        cons(k, i) = number(3);
        errs(k, i) = number(4);
        i = i + 1;
    end
    
end
    
save(strcat(FILE_DIR, 'MATS/', FILENAME),'locs', 'lons', 'lats', 'levs', 'cons', 'errs')

fclose(fid);