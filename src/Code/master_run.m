%%
clear;
clc;

disp('Starting execution ...')

%%

run JOCRealPCOIL.m;

run JOCRealUCOIL.m;
%%

run JOCRobustChecking_cifar.m;

run JOCRobustChecking_minst.m;

%%
clc;
clear;
% scenario_list = {'allmode','onemode'};
% nd_list = {'ngreaterd','nlessd','nequald'};

K = 3;
for s = scenario_list
    scenario = s{1};
    for n = nd_list;
        nd = n{1};
        
        fprintf('runing plot for scenario: %s\n', [scenario '-' nd]);
        [E1,T] = ontheflySyn(scenario,nd,K);
        plotSynErrTime(scenario,nd,K);
        
    end
end
%%
