%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   Exercise for the selection of candidates for the call     %%%
%%%      ‘VAC-2021-42 - PhD Position in CIMNE MARINE’           %%%
%%%                                                             %%%
%%%                   Mohammad Sadegh Eshaghi                   %%%
%%%                                                             %%%
%%%                   The code of Solving ODE                   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear;
close all;

%% Parameter Defenition

X0=[0;0];	% initial Value: X0=[x(0),x'(0)]
NF1=100;	% number of Data for amplitude (F) in the range of [0.1, 3)
NF2=50;		% number of Data for amplitude (F) in the range of [3, 10]
Nw1=400;	% number of Data for frequency (w) in the range of [0.1, 4)
Nw2=200;	% number of Data for frequency (w) in the range of [4, 10]
NF=NF1+NF2;	% total Number of Data for amplitude (F)
Nw=Nw1+Nw2;	% total Number of Data for frequency (w)

tmax=50;	% 
M=1;		% the Mass of the system
D=0.05;		% damping coefficient
F=[linspace(0.1,3,NF1) linspace(3,10,NF2)];	% considered value of amplitude in database
w=[linspace(0.1,4,Nw1) linspace(4,10,Nw1)];	% considered value of frequency in database

%% Allocating memory to store the database

empty_individual.M=[];
empty_individual.D=[];
empty_individual.F=[];
empty_individual.w=[];
empty_individual.x=[];
empty_individual.xp=[];
empty_individual.R=[];
empty_individual.Rmax=[];

condition=repmat(empty_individual,NF,Nw);
Database=zeros(NF*Nw,3);

%% Solving ODE for different F and w values

for i=1:NF
    for j=1:Nw

        i
        j
        F(i)
        w(j)
        
        condition(i,j).M=M;
        condition(i,j).D=D;
        condition(i,j).F=F(i);
        condition(i,j).w=w(j);

        % x1 = x
        % x2 = x'
        % X = (x , x') = (x1 , x2) 

        system=@(t,X)VAC(t,X,condition(i,j));
        [t, X]=ode45(system,[0 tmax] ,X0);

        x1=X(:,1);
        R=x1.*(1+0.1.*x1);
        Rmax=max(abs(R));
        
        condition(i,j).x=x1;
        condition(i,j).xp=X(:,2);
        condition(i,j).R=R;
        condition(i,j).Rmax=Rmax;
        
        Database(j+Nw*(i-1),1)=i;
        Database(j+Nw*(i-1),2)=j;
        Database(j+Nw*(i-1),3)=F(i);
        Database(j+Nw*(i-1),4)=w(j);
        Database(j+Nw*(i-1),5)=Rmax;
        
    end
end

%% Plotting result for a state
 
figure;
subplot(2,2,1);
plot(t,X(:,1));
xlabel('t');
ylabel('x_1(t)');

subplot(2,2,3);
plot(t,X(:,2));
xlabel('t');
ylabel('x(t)');

subplot(2,2,[2 4]);
plot(X(:,1),X(:,2));
xlabel('x(t)');
ylabel('dx(t)/dt');

