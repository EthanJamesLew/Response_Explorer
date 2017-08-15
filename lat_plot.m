NAME = 'SCS'

load(strcat(pwd, '\OLD\MATS\H_old.mat'));
load(strcat(pwd, '\OLD\MATS\globalview_old.mat'));
%index = find(strcmp(locs, NAME));

%locs = locs(index(1):index(numel(index)));
%lats = lats(index(1):index(numel(index)));
%lons = lons(index(1):index(numel(index)));
%levs = levs(index(1):index(numel(index)));

index = (1:numel(locs))
[lats,indices] = sort(lats,'ascend');

reps = zeros(12, numel(lats));

%figure
cats = {'Gas+Oil', 'Coal', 'Livestock', 'Waste', 'BB C3', 'Rice', 'WL(30-0N)', 'BB C4', 'WL(90-30N)', 'WL(0-90S)'};
ma = 0;
for j = 1:10
    for i=1:numel(index)
            reps(:, i) = H_all(:, j, index(indices(i)), 1);
            tmp = max(reps(:, i));
            if tmp > ma
                ma = tmp;
            end
    end
end
    
for j = 1:10
    
    

    subaxis(2, 5, j, 'sh', 0.06, 'sv', 0.012, 'padding', 0.01, 'margin', 0.07);
    axis off
    
    

    for i=1:numel(index)
        reps(:, i) = H_all(:, j, index(indices(i)), 1);
        tmp = max(reps(:, i));
        if tmp > ma
            ma = tmp;
        end
        lats(index(i)-min(index)+1);
    end

       max(lats);
    las =  2*(lats-90/2);
    [Y, X] = meshgrid(1:1:12, las);


    size([X, Y]);
    Zs = transpose(reps);
    size(Zs);

    surf(X,Y,Zs, 'edgecolor','none');
    rotate3d();
    set(gca,'Ydir','reverse');

    %title(strcat(NAME, ' CH$_4$ Response'), 'Interpreter', 'latex')
    ylabel('Months', 'Interpreter', 'latex')
    xlabel({'Latitude ', cats{j}}, 'Interpreter', 'latex')
    zlabel('CH$_4$Concentration (ppb)', 'Interpreter', 'latex')

    
    ylim([1, 12])
    xlim([min(las), max(las)])
    zlim([0, .5])
    
end

fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 8.5 11];