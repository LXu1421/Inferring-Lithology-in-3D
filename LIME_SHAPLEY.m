%%
%LIME for all
Lst = ["Total Magnetic Intensity"...
    "Magneitc - AS"...
    "Magneitc - HD"...
    "Total Count" ...
    "Gravity" ...
    "Gravity - AS" ...
    "Gravity - HD" ...
    "Gravity - 1VD" ...
    "Inferred Cover Thickness"...
    "ΔZ"];

X_lm = CAest(:,1:end-1);
myPredict = @(X_lm)getPerdiction(CAModel896,X_lm);
for i = 1: size(CAest,1)
queryPoint = X_lm(i,:);
rng('default') % For reproducibility
results = lime(myPredict, X_lm,'QueryPoint',queryPoint,...
    'NumImportantPredictors',10,...
    'SimpleModelType','linear','Type','classification');
f = plot(results);
ylabel('Reference Map');
baseFileName = sprintf('LIME_%d.png',i);
exportgraphics(f,baseFileName,'BackgroundColor','white');
end

Shst = ["psammitic"...
    "pelitic"];
VN = ["x1", "x2", "x3", "x4", "x5", "x6", "x7", "x8", "x9", "x10","x11",...
];
variables = CAest(:,1:end-1);
X_lm=variables;
response = CAest(:, end);
SHA_Table = zeros(size(X_lm,2), size(X_lm, 1));
txt = strings(1,size(X_lm, 1)+1);
for i = 1: size(CAest,1)
queryPoint = CAest(i,1:end-1);
rng('default') % For reproducibility
explainer = shapley(myPredict, CAest(:,1:end-1),QueryPoints=queryPoint,UseParallel=true);
f = plot(explainer);
b = findobj(f,'Type','bar');
SHA_imp = b.YData;
ax = gca;
VO = ax.YTickLabel;
% Find the indices of VO in VN
[~, indices] = ismember(VO, VN);
% Fill the SHA_Table with SHA_imp values based on indices
SHA_Table(:, i) = nan; % Initialize the column with NaNs
SHA_Table(indices(indices > 0), i) = SHA_imp(indices > 0);
txt(1,i+1) = [Shst(response(i,end)-4)];
% ylabel('Reference Map');
% title(['Shapley Explanation Query Point ',num2str(i)])
% txt = [Shst(CAest(i,end)-4)];
% subtitle(txt)
% baseFileName = sprintf('Shapley_%d.png',i);
% ax = gca;
% exportgraphics(ax,baseFileName,'BackgroundColor','white')
end

T= figure;
B = bar([nanmean(SHA_Table(:,[response(:,end)]'==5'),2),...
    nanmean(SHA_Table(:,response(:,end)'==6),2) ...
    ],'stacked');
xlabel('Variable Index');
ylabel('(Avg.) SHAPLEY');
title('SHAPLEY Importance');
lgd = legend(Shst(1:2));
lgd.Location = 'southwest';
grid minor;
grid on;
baseFileName = sprintf('SHAPLEY Importance_Old.png');
exportgraphics(T,baseFileName,'BackgroundColor','white','Resolution',300);