%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   Exercise for the selection of candidates for the call     %%%
%%%      ‘VAC-2021-42 - PhD Position in CIMNE MARINE’            %%%
%%%                                                             %%%
%%%                   Mohammad Sadegh Eshaghi                   %%%
%%%                                                             %%%
%%%           The function of the VAC-2021-42 Problem           %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function dX=VAC(t,x,params)

M=params.M;
D=params.D;
F=params.F;
w=params.w;

% dX = d(x , x') = (x', x'') = ...
%                 = (x2, (1/M)*(F*sin(w*t)-D*x2-(x1+0.1*x1^2))) = 

dX=[x(2); (1/M)*(F*sin(w*t)-D*x(2)-(x(1)+0.1*x(1)^2))];
end