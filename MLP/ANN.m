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

%% Remving the data related to unstable states

Data(Data(:,5)>50,:)=[];

%% Training Neural Network

inputs = Data(:,3:4)';
targets = Data(:,5)';

% Create a Fitting Network

%hiddenLayerSize = 20;          % one-hidden-layer ANNs (2-20-1-MLP)
%hiddenLayerSize = [5 15];      % two-hidden-layer ANNs (2-5-15-1-MLP)
hiddenLayerSize = [15 5];       % two-hidden-layer ANNs (2-15-5-1-MLP)

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
net.trainParam.show=1;
net.trainParam.epochs=1000;
net.trainParam.goal=1e-8;
net.trainParam.max_fail=20;

% Train the Network
[net,tr] = train(net,inputs,targets);

% Test the Network
outputs = net(inputs);
errors = gsubtract(targets,outputs);
performance = perform(net,targets,outputs);

% Recalculate Training, Validation and Test Performance
trainInd=tr.trainInd;
trainInputs = inputs(:,trainInd);
trainTargets = targets(:,trainInd);
trainOutputs = outputs(:,trainInd);
trainErrors = trainTargets-trainOutputs;
trainPerformance = perform(net,trainTargets,trainOutputs);

valInd=tr.valInd;
valInputs = inputs(:,valInd);
valTargets = targets(:,valInd);
valOutputs = outputs(:,valInd);
valErrors = valTargets-valOutputs;
valPerformance = perform(net,valTargets,valOutputs);

testInd=tr.testInd;
testInputs = inputs(:,testInd);
testTargets = targets(:,testInd);
testOutputs = outputs(:,testInd);
testError = testTargets-testOutputs;
testPerformance = perform(net,testTargets,testOutputs);

%% Results for Target
PlotResults(targets(1,:),outputs(1,:),'All Data (1)');
PlotResults(trainTargets(1,:),trainOutputs(1,:),'Train Data (1)');
PlotResults(valTargets(1,:),valOutputs(1,:),'Validation Data (1)');
PlotResults(testTargets(1,:),testOutputs(1,:),'Test Data (1)');

%% Calculating Statistic Index

Param = CalculateStatistic(targets,outputs)

