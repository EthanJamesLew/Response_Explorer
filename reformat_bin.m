clc; clear;

FILENAME = 'H_new';
FILE_DIR = '\NEW';
MONTHS = 34*12;
SITES = 200;



files = dir(strcat(pwd, strcat(FILE_DIR, '\BINS\*.bin')));

file_ptr = 0
file_list = {};
for i = 1:numel(files)
  file_list{i} = files(i).name;
end
H = zeros(10, SITES);
H_all = (zeros(12, 10, SITES, 34*12));
    
for file_ptr = 1:1
    
    year = 1979 + floor(file_ptr/12);
    month = mod(file_ptr, 12) + 1;
    
    %fprintf('start new');
    file_list{(file_ptr-1)*12 + 1};

    for i =1:12
        strcat(strcat(FILE_DIR, '\BINS\'),file_list{(file_ptr-1)*12 + i})
        fid = fopen(strcat(strcat('.', FILE_DIR, '\BINS\'),file_list{(file_ptr-1)*12 + i}),'r'); %read big endian
        fprintf('%d\n', (file_ptr-1)*12 + i)
        header = fread(fid,1,'*int32', 'b');
        date = fread(fid,6,'*int32', 'b'); % May need adjusting
        %header = fread(fid,1,'*uint32', 'b');
        for k = 1: SITES

            h_dat = fread(fid,10 ,'double', 'b'); % May need adjusting
            H(:, k) = h_dat;
            ate = fread(fid,1,'double', 'b'); % May need adjusting
        end
        %header = fread(fid,1,'*uint32', 'b');
        header = fread(fid,3,'*int32', 'b');
        ate = fread(fid,4,'*uint32', 'b'); % May need adjusting
        h_iso_dat = fread(fid,[10, 21] ,'double', 'b'); % May need adjusting

        month1 = date(2);
        month2 = date(4);
        year1 = date(1);
        year2 = date(3);

        %H = reshape(h_dat(1:10*105), [10, 105]);
        H_iso = h_iso_dat;
        H_all(i, :, :, file_ptr)= H;
        H(1,1,1,:);

        fclose(fid);
    end

end

%filename = strcat(num2str(year), num2str(month))
filename = strcat(FILENAME, '.mat')
filename = strcat(strcat(FILE_DIR, '\MATS\'), filename)
filename = strcat(pwd, filename)
save(filename, 'H_all')


for j = 1:1
figure
hold on
months = (1:1:12);
for i=1: 10
        subplot(5, 2,i)
        plot(months,H_all(:, i, 7, 1)) 
end
hold off
end


