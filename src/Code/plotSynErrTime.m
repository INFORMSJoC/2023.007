function plotSynErrTime(scenario, nd, K)
%%
% clc;
% clear;
% scenario = 'allmodel';
% scenario = 'onemodel';
% nd = 'ngreaterd';
% nd = 'nlessd';
filepath = '/Users/xiaohouping/Documents/MATLAB/dynamic_tucker_decomposition/accelerate_online_low_rank_tensor/on_the_fly/JOCR5/Results/Syn';
extention='.mat';
f = ['Error_' scenario '_' nd];
matname = fullfile(filepath, [f extention]);
load(matname);
f = ['Times_' scenario '_' nd];
matname = fullfile(filepath, [f extention]);
load(matname);

%%
ERROR = E1(:,2:13);
TIMES = T(:,2:13);
%%
figure1 = figure('InvertHardcopy','off','Color',[1 1 1]);
set (gcf,'Position',[400,100,1500,600])
set (gcf,'OuterPosition',[400,100,1550,650])
l=2.5;
m = 400;
for i = 1 : 10
    if i <= 5
    a = 0.05 + (i-1)*0.2; b= 0.6;
    else
    a = 0.05 + (i-6)*0.2; b = 0.2;
    end
    axes1 = axes('Parent',figure1,'Position',[a b 0.125 0.25]);
    hold(axes1,'on');
    hold all
    scatter(TIMES(i,2),ERROR(i,2),m+200,[0 0 1]   ,'filled'           ,'v','Parent',axes1,'LineWidth',l,'DisplayName','HOSVD')
    scatter(TIMES(i,3),ERROR(i,3),200,[1 0 0],'filled' ,'h','Parent',axes1,'LineWidth',5,'DisplayName','ALS')
    scatter(TIMES(i,4),ERROR(i,4),m+500,[0 0 0]              ,'<','Parent',axes1,'LineWidth',l,'DisplayName','TUCKALS3')
    scatter(TIMES(i,5),ERROR(i,5),m+100,[0 1 0]  ,'s','Parent',axes1,'LineWidth',l,'DisplayName','SVD1')
    scatter(TIMES(i,6),ERROR(i,6),m,[0.466 0.674 0.188],'filled'  ,'p','Parent',axes1,'LineWidth',l,'DisplayName','SVD2')
    scatter(TIMES(i,7),ERROR(i,7),m-200,[0 0.447 0.741],'filled'      ,'^','Parent',axes1,'LineWidth',l,'DisplayName','NNMF1')
    scatter(TIMES(i,8),ERROR(i,8),m,[0 0 0]   ,'d','Parent',axes1,'LineWidth',l,'DisplayName','NNMF2')
    scatter(TIMES(i,9),ERROR(i,9),m,[1 0 1]              ,'s','Parent',axes1,'LineWidth',l,'DisplayName','AutoEncoder1','LineWidth',2)
    scatter(TIMES(i,10),ERROR(i,10),m,[0.929 0.694 0.125],'+','Parent',axes1,'LineWidth',l,'DisplayName','AutoEncoder2')
    scatter(TIMES(i,11),ERROR(i,11),m,[1 0 1]              ,'d','Parent',axes1,'LineWidth',l,'DisplayName','SAE1','LineWidth',2)
    scatter(TIMES(i,12),ERROR(i,12),m,[0.929 0.694 0.125],'<','Parent',axes1,'LineWidth',l,'DisplayName','SAE2')
   
    scatter(TIMES(i,1), ERROR(i,1),m,[1 0 0]            ,'o','Parent',axes1,'LineWidth',l,'DisplayName','Ours(OTD)')
    
    % fix the xlim
    xt = TIMES(i,:);
    xt = xt(isfinite(xt) & xt>0);
    
    xmin = min(xt);
    xmax = max(xt);
    xlim(axes1, [xmin/2,xmax*1.1]);
    ylim(axes1, [-0.1,1]);
    
%     xlim([0.002,100])
%     ylim([-0.1,1])
    set(gca, 'XScale', 'log');
    xlabel('Running Time (s)','FontName','Times New Roman');
    title(['Time = ' num2str(i)],'FontName','Times New Roman');
    ylabel('Reconstruction Error','FontName','Times New Roman');
    box(axes1,'on');
    set(axes1,'FontSize',20);
end
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.1 0.02 0.8 0.07],...
    'Orientation','horizontal',...
    'FontSize',24,...
    'FontName','Times New Roman');


outdir = '/Users/xiaohouping/Documents/MATLAB/dynamic_tucker_decomposition/accelerate_online_low_rank_tensor/on_the_fly/JOCR5/Results/Figures';
fig = gcf;
ax = gca;
ax.LooseInset = ax.TightInset;

savefig(figure1,fullfile(outdir,[scenario '-' nd '-error-time-' int2str(K) '.fig']));
print(figure1,fullfile(outdir,[scenario '-' nd '-error-time-' int2str(K) '.eps']),'-depsc','-painters');
end