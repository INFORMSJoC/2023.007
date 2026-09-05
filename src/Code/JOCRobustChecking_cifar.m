%%
clear;
clc;
%
% load('/Users/xiaohouping/Documents/MATLAB/dynamic_tucker_decomposition/accelerate_online_low_rank_tensor/on_the_fly/JOCRobustness/minst.mat')

% load('/Users/xiaohouping/Documents/MATLAB/dynamic_tucker_decomposition/accelerate_online_low_rank_tensor/on_the_fly/JOCRobustness/minst2.mat')

% load('/Users/xiaohouping/Documents/MATLAB/dynamic_tucker_decomposition/accelerate_online_low_rank_tensor/on_the_fly/JOCRobustness/minst_128.mat')

% load('/Users/xiaohouping/Documents/MATLAB/dynamic_tucker_decomposition/accelerate_online_low_rank_tensor/on_the_fly/JOCRobustness/minst_200.mat')

% load('/Users/xiaohouping/Documents/MATLAB/dynamic_tucker_decomposition/accelerate_online_low_rank_tensor/on_the_fly/JOCRobustness/cifar_100_3.mat')

load('/Users/xiaohouping/Documents/MATLAB/dynamic_tucker_decomposition/accelerate_online_low_rank_tensor/on_the_fly/JOCRobustness/cifar_200_1.mat')

% load('/Users/xiaohouping/Documents/MATLAB/dynamic_tucker_decomposition/accelerate_online_low_rank_tensor/on_the_fly/JOCRobustness/cifar_128_1.mat')

%%
w1 = 128;
h1 = 128;

w1 = 200;
h1 = 200;

I = [10 100 128 128];
% I = [10 500 28 28];
I = [10 100 w1 h1];
XOTD	=tenzeros(I);
XTB     =tenzeros(I);
XALS	=tenzeros(I);
XTA     =tenzeros(I);
Xsvd1   =tenzeros(I);
Xsvd2   =tenzeros(I);
Xnnmf1  =tenzeros(I);
Xnnmf2  =tenzeros(I);
Xae1    =tenzeros(I);
Xae2    =tenzeros(I);
Xaes1    =tenzeros(I);
Xaes2    =tenzeros(I);
TIMES = cell(10,1);
ERROR = cell(10,1);
ERROR1 = cell(10,1);
for j = 1:1
j
XX = X(j,:,:,:);
%%
EE = [];
TT = [];
N = size(XX);
in = index(3); % indicated one which mode data is increasing (2 yes; 1 no)
s = size( in );
for K = 5 % estimated tensor rank
in(:,2)=1;
in(:,3)=1;
d_0=[50,w1,h1];
step = [10,0,0];
d_ini=d_0;

E = [];
E1= [];
T = [];
% HOSVD on the first time stamp
X_1 = XX(1:d_0(1),1:d_0(2),1:d_0(3));
N1 = size( X_1 );

R=ones(1,4)*K;
%R(2) = R(2)+K;
U_ini = cell( numel(N1),1 );
for k = 1 : numel(N1)
   tmp = tenmat( X_1,k );
   [U_ini{k},~] = svds( tmp.data, min( R(k), N1(k) ));
end
G_ini = ttm( X_1,U_ini, 1:numel(N1), 't');
U_ini_nc = U_ini;G_ini_nc=G_ini;
K
MaxTS = 5;
X_new = cell( 2^(numel(N)),1 );
for d = 1 : MaxTS 
    for i = 1 : s(1)
       if in(i,1) == 1
           d11 = 1; d12 = d_0(1)+step(1)*(d-1);
       else
           d11 = d_0(1)+step(1)*(d-1)+1; d12 = d_0(1)+ step(1)*d;
       end
       if in(i,2) == 1
           d21 = 1; d22 = d_0(2)+step(2)*(d-1);
       else
           d21 = d_0(2)+step(2)*(d-1)+1; d22 = d_0(2)+ step(2)*d;
       end
       if in(i,3) == 1
           d31 = 1; d32 = d_0(3)+step(3)*(d-1);
       else
           d31 = d_0(3)+step(3)*(d-1)+1; d32 = d_0(3)+ step(3)*d;
       end
       X_new{ i } = XX(d11:d12,d21:d22,d31:d32);
    end
    [G_new,U_new,t_new] = on_the_fly_m3( G_ini,U_ini,X_new,d_ini,in,0.1 );
    [G_nc,U_nc,t_nc] = on_the_fly_nc_m3( G_ini_nc,U_ini_nc,X_new,d_ini,in );
    d_ini = d_0 + step*(d);
    X_all = XX(1:d_0(1)+step(1)*(d),1:d_0(2)+step(2)*(d),1:d_0(3)+step(3)*(d));
    X_est = ttm( G_new,U_new,1:numel(N) );
    Error = ( X_all - X_est ).^2;
    e = ce( X_est,X_all)/ce(X_all,0);
    X_est_nc = ttm( G_nc,U_nc,1:numel(N) );
    Error_nc = ( X_all - X_est_nc ).^2;
    e_nc = ce( X_est_nc,X_all)/ce(X_all,0);
%
    n = FN(X_all);
    [~,G_batch,U_batch,t_b,e_b] = tb( X_all,R,500,1e-6 );
    X_tb = ttm( G_batch,U_batch,1:numel(N) );
    [~,G_als,U_als,t_als,e_als] = als( X_all,R,3 );
    X_als = ttm( G_als,U_als,1:numel(N) );
    [~,G_ta,U_ta,t_ta,e_ta] = tuckals3( X_all,R,3 );
    X_ta = ttm( G_ta,U_ta,1:numel(N) );
    [X_svdk,~,~,~,t_svdk,e_svdk] = svdk(X_all,R,3);
    [X_svdmk,~,~,~,t_svdmk,e_svdmk] = svdmk(X_all,R,3);
    [X_nnmfk,~,~,t_nnmfk,e_nnmfk] = nnmfk(X_all,R,3);
    [X_nnmfmk,~,~,t_nnmfmk,e_nnmfmk] = nnmfmk(X_all,R,3);
    [recoverXaek,t_aek,e_aek] = aek(X_all,3);
    [recoverXaemk,t_aemk,e_aemk] = aemk(X_all,3);
    [recoverXaesk,t_aesk,e_aesk] = aekstack(X_all,3);
    [recoverXaesmk,t_aesmk,e_aesmk] = aemkstack(X_all,3);
% 
% 
     E =  [E;  [e e_nc e_b e_als e_ta]./ n];
     E1 = [E1; [e     e_nc e_b e_als e_ta e_svdk e_svdmk e_nnmfk e_nnmfmk e_aek e_aemk e_aesk e_aesmk]];    
     T =  [T;  [t_new t_nc t_b t_als t_ta t_svdk t_svdmk t_nnmfk t_nnmfmk t_aek t_aemk t_aesk t_aesmk]];
    
    U_ini = U_new;G_ini=G_new;
    U_ini_nc = U_nc;G_ini_nc = G_nc;
    
    fprintf('Rank of %g; Errors of at %g step is:\n',K, d);
    fprintf('on-the-fly: %g, on-the-fly-nc: %g\n',e,e_nc);
    fprintf('hosvd: %g, als: %g, tuckals3: %g\n',e_b,e_als,e_ta);
end
% 
% ERROR{j} = E;
% ERROR1{j} = E1;
% TIMES{j} = T;
end

ERROR{j} = E;
ERROR1{j} = E1;
TIMES{j} = T;

XOTD(j,:,:,:)	 =X_est_nc;
XTB(j,:,:,:)     =X_tb;
XALS(j,:,:,:)	 =X_als;
XTA(j,:,:,:)     =X_ta;
Xsvd1(j,:,:,:)   =X_svdk;
Xsvd2(j,:,:,:)   =X_svdmk;
Xnnmf1(j,:,:,:)  =X_nnmfk;
Xnnmf2(j,:,:,:)  =X_nnmfmk;
Xae1(j,:,:,:)    =recoverXaek;
Xae2(j,:,:,:)    =recoverXaemk;
Xaes1(j,:,:,:)    =recoverXaesk;
Xaes2(j,:,:,:)    =recoverXaesmk;
%%
% end
extention='.mat';
filepath = '/Users/xiaohouping/Documents/MATLAB/dynamic_tucker_decomposition/accelerate_online_low_rank_tensor/on_the_fly/JOCR5/Results/CIFAR';
matname = fullfile(filepath, ['Error_cifar_2_' int2str(j) '_' int2str(K) extention]);
save(matname, 'ERROR1')
matname = fullfile(filepath, ['Times_cifar_2_' int2str(j) '_' int2str(K) extention]);
save(matname, 'TIMES')
end
%%
%%
k=1;
% for k = 1:10
% ERR = ERROR1{1};
% TIM = TIMES{1};
% for k = 2:10
%     ERR = ERR + ERROR1{k};
%     TIM = TIM + TIMES{k};
% end
% ERRORAVG = ERR / k;
% TIMEAVG = TIM / k;
% % %
% % ERROR2 = ERRORAVG(:,2:13);
% % TIMES2 = TIMES{k}(:,2:13);
% %
% ERROR2 = ERRORAVG(:,2:13);
% TIMES2 = TIMEAVG(:,2:13);

ERROR2 = ERROR1{k}(:,2:13);
TIMES2 = TIMES{k}(:,2:13);
ERROR = ERROR2;
TIMES1 = TIMES2;

m = 400;
l=2.5;

% Create figure
figure1 = figure('InvertHardcopy','off','Color',[1 1 1]);
set (gcf,'Position',[400,100,1000,600])
set (gcf,'OuterPosition',[400,100,1150,650])
axes1 = axes('Parent',figure1,'Position',[0.1, 0.2 0.85 0.75]);
hold(axes1,'on');
hold all
% for i = 1:5
scatter(TIMES1(:,2),ERROR(:,2),m+200,[0 0 1]   ,'filled'           ,'v','Parent',axes1,'LineWidth',l,'DisplayName','HOSVD')
scatter(TIMES1(:,3),ERROR(:,3),200,[1 0 0],'filled' ,'h','Parent',axes1,'LineWidth',5,'DisplayName','ALS')
scatter(TIMES1(:,4),ERROR(:,4),m+500,[0 0 0]              ,'<','Parent',axes1,'LineWidth',l,'DisplayName','TUCKALS3')
scatter(TIMES1(:,5),ERROR(:,5),m+100,[0 1 0]  ,'s','Parent',axes1,'LineWidth',l,'DisplayName','SVD1')
scatter(TIMES1(:,6),ERROR(:,6),m,[0.466 0.674 0.188],'filled'  ,'p','Parent',axes1,'LineWidth',l,'DisplayName','SVD2')
scatter(TIMES1(:,7),ERROR(:,7),m-200,[0 0.447 0.741],'filled'      ,'^','Parent',axes1,'LineWidth',l,'DisplayName','NNMF1')
scatter(TIMES1(:,8),ERROR(:,8),m,[0 0 0]   ,'d','Parent',axes1,'LineWidth',l,'DisplayName','NNMF2')
scatter(TIMES1(:,9),ERROR(:,9),m,[1 0 1]              ,'s','Parent',axes1,'LineWidth',l,'DisplayName','AutoEncoder1','LineWidth',2)
scatter(TIMES1(:,10),ERROR(:,10),m,[0.929 0.694 0.125],'+','Parent',axes1,'LineWidth',l,'DisplayName','AutoEncoder2')
scatter(TIMES1(:,11),ERROR(:,11),m,[1 0 1]              ,'d','Parent',axes1,'LineWidth',l,'DisplayName','SAE1','LineWidth',2)
scatter(TIMES1(:,12),ERROR(:,12),m,[0.929 0.694 0.125],'<','Parent',axes1,'LineWidth',l,'DisplayName','SAE2')
    
scatter(TIMES1(:,1),ERROR(:,1),m,[1 0 0]            ,'o','Parent',axes1,'LineWidth',l,'DisplayName','Ours(OTD)')
ylim([0,2])
set(gca, 'XScale', 'log');
% xlabel('Rank','FontName','Times New Roman');
xlabel('Running Time (s)','FontName','Times New Roman');
% title(['Time = ' num2str(i)],'FontName','Times New Roman');
%     title(['N = ' num2str(D_im(i))],'FontName','Times New Roman');
ylabel('Reconstruction Error','FontName','Times New Roman');
box(axes1,'on');
set(axes1,'FontSize',20);

legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.1 0.02 0.8 0.07],...
    'Orientation','horizontal',...
    'FontSize',14,...
    'FontName','Times New Roman');
%%
outdir = '/Users/xiaohouping/Documents/MATLAB/dynamic_tucker_decomposition/accelerate_online_low_rank_tensor/on_the_fly/JOCR5/Results/Figures';
fig = gcf;
ax = gca;
ax.LooseInset = ax.TightInset;

savefig(figure1,fullfile(outdir,['cifar-error-time-' int2str(K) '.fig']));
print(figure1,fullfile(outdir,['cifar-error-time-' int2str(K) '.eps']),'-depsc','-painters');
% end
