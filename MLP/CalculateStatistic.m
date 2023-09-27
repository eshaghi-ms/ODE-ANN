%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   Exercise for the selection of candidates for the call     %%%
%%%      ‘VAC-2021-42 - PhD Position in CIMNE MARINE’            %%%
%%%                                                             %%%
%%%                   Mohammad Sadegh Eshaghi                   %%%
%%%                                                             %%%
%%%       The function for calculateing Statistics index        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function Param = CalculateStatistic(targets,outputs)

e = targets-outputs;

Param.R2 = ( sum( (targets-mean(targets)) .* (outputs-mean(outputs)) ) / ...
    sqrt( sum( (targets-mean(targets)).^2 ) * sum( (outputs-mean(outputs)).^2 ) ) ).^2;

Param.MSE = mean(e.^2);
Param.RMSE = sqrt(Param.MSE);


Param.SI = Param.RMSE/mean(outputs);

Param.BIAS = sum( e ) /size(e,2);

end