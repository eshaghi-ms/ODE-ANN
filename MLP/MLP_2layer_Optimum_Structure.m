%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   Exercise for the selection of candidates for the call     %%%
%%%      ‘VAC-2021-42 - PhD Position in CIMNE MARINE’            %%%
%%%                                                             %%%
%%%                   Mohammad Sadegh Eshaghi                   %%%
%%%                                                             %%%
%%%  The code to identify the optimal architecture of the MLP   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear;
close all;

%% Loading Database

load('DataBase.mat') % The database is achieved from the code for solving ODE
Data = Database;

%% Random Selection of 5% of data

Data_5percent=Data(randi([1,size(Data,1)],1,size(Data,1)*0.05),:);

%% Parameter Defenition

inputs = Data_5percent(:,3:4)';
targets = Data_5percent(:,5)';

N=60;       % Total number of neurons is varied from 1 to 60
K=10;       % ten repetitions to also assure robustness against stochastic effects

%% Allocating memory to store the RMSE

ALLMSE = zeros(N,1);
ALLRMSE = zeros(N,1);

MSE_K(K)=0;
RMSE_K(K)=0;

%% Training MLP for different number of neurons

for i = 1:N
    for j = 1:N-i
        for k=1:K
            
        k
        % Create a Fitting Network
        hiddenLayerSize = [i, j]
        TF={'tansig','purelin'};
        net = newff(inputs,targets,hiddenLayerSize,TF);

        % Choose Input and Output Pre/Post-Processing Functions
        % For a list of all processing functions type: help nnprocess
        net.inputs{1}.processFcns = {'removeconstantrows','mapminmax'};
        net.outputs{2}.processFcns = {'removeconstantrows','mapminmax'};


        % Setup Division of Data for Training, Validation, Testing
        % For a list of all data division functions type: help nndivide
        net.divideFcn = 'dividerand';  % Divide data randomly
        net.divideMode = 'sample';  % Divide up every sample
        net.divideParam.trainRatio = 70/100;
        net.divideParam.valRatio = 15/100;
        net.divideParam.testRatio = 15/100;

        % For help on training function 'trainlm' type: help trainlm
        % For a list of all training functions type: help nntrain
        net.trainFcn = 'trainlm';  % Levenberg-Marquardt

        % Choose a Performance Function
        % For a list of all performance functions type: help nnperformance
        net.performFcn = 'mse';  % Mean squared error

        % Choose Plot Functions
        % For a list of all plot functions type: help nnplot
        net.plotFcns = {'plotperform','ploterrhist','plotregression','plotfit'};

        net.trainParam.showWindow=true;
        net.trainParam.showCommandLine=false;
        net.performParam.normalization='standard';
        net.trainParam.showWindow=0;
        net.trainParam.epochs=500;
        net.trainParam.goal=1e-8;
        net.trainParam.max_fail=20;

        % Train the Network
        [net,tr] = train(net,inputs,targets);

        % Test the Network
        outputs = net(inputs);
        errors = gsubtract(targets,outputs);
       
        performance = perform(net,targets,outputs);
        RMSE=sqrt(performance);

        MSE_K(k) = performance;
        RMSE_K(k) = RMSE;
        
        end
        
        ALLMSE(i+j,j) = mean(MSE_K);
        ALLRMSE(i+j,j) = mean(RMSE_K);
        
    end
end

