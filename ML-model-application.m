% Structure 'WFModelN' exported from Classification Learner. 
% To make predictions on a new predictor column matrix, X: 
%   [yfit,scores] = WFModelN.predictFcn(X) 
% For more information, see How to predict using an exported model.

GS1 = 20; %Grid size
yfit_n = WFModelN.predictFcn(CSAll); %Model 1B perdictions


WFM_N=zeros(size(UTME2,1),size(UTME2,2),round(500/GS1));
flag=1;
for i = 1: size(UTME2,2) %x
for j = 1: size(UTME2,1) %y
for m = 1:round(500/GS1)
WFM_N(j,i,m) = yfit_n(flag,1);
flag=flag+1;
end
end
end

FLAG=1;
WFM_Out=zeros(size(CSB,1)*size(CSB,2)*size(CSB,3),4);
for i = 1: size(UTME2,2) %x
for j = 1: size(UTME2,1) %y
    for m = 1:round(500/GS1)
    WFM_Out(FLAG,1) = UTME2(j,i);
    WFM_Out(FLAG,2) = UTMN2(j,i);
    WFM_Out(FLAG,3) = ElevationM(j,i)-(m-1)*GS1;
    WFM_Out(FLAG,4) = WFM(j,i,m);
    FLAG=FLAG+1;
    end
end
end
baseFileName = sprintf("Overburden-Bedrock20.csv");
writematrix(WFM_Out,baseFileName)