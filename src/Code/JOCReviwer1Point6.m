clear
clc
EE = [];
TT = [];
KK = 10;
% for KK = 10 % rank = KK/2
% construct dynamic tensors on 3 dimensions
dim = [600 600 600]; % original tensor size
DD = 20; %core tensor size
d = cell( 3,1 ); % projection matrix size
d{1} = [ dim(1),DD ];
d{2} = [ dim(2),DD ];
d{3} = [ dim(3),DD ];
RR = [1 1 1]*KK; % tensor rank
G = tensor( rand( [DD DD DD] ) );
U = cell( 3,1 );
U_a = cell( 3,1 );
for i = 1 : 3
   U{i} = rand( d{i}(1),round(RR(i)/2))*rand(round(RR(i)/2),DD );
   U_a{i} = rand( d{i}(2),RR(i)-round(RR(i)/2))*rand(RR(i)-round(RR(i)/2),DD );
end
X = ttm( G,{[U{1};U_a{1}],[U{2};U_a{2}],[U{3};U_a{3}]},[1,2,3] );
%%
N = size(X);
TIMES = [];
ERROR = [];
ERROR1 = [];

in = index(3); % indicated one which mode data is increasing (2 yes; 1 no)
s = size( in );
for K = 3 % estimated tensor rank
in(:,1)=1;
in(:,2)=1;
% d_0=[200,200,200]; %n >> d
% step = [10,10,10];
% step = [0,0,10];
d_0=[50,50,250]; %n << d
step = [0,0,2];
% d_0=[50,50,50]; %n == d
% step = [0,0,50];
d_ini=d_0;

E = [];
E1= [];
T = [];
% HOSVD on the first time stamp
X_1 = X(1:d_0(1),1:d_0(2),1:d_0(3));
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
MaxTS = 100;
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
       X_new{ i } = X(d11:d12,d21:d22,d31:d32);
    end
    [G_new,U_new,t_new] = on_the_fly_m3( G_ini,U_ini,X_new,d_ini,in,0.1 );
    [G_nc,U_nc,t_nc] = on_the_fly_nc_m3( G_ini_nc,U_ini_nc,X_new,d_ini,in );
    d_ini = d_0 + step*(d);
    X_all = X(1:d_0(1)+step(1)*(d),1:d_0(2)+step(2)*(d),1:d_0(3)+step(3)*(d));
    X_est = ttm( G_new,U_new,1:numel(N) );
    Error = ( X_all - X_est ).^2;
    e = ce( X_est,X_all)/ce(X_all,0);
    X_est_nc = ttm( G_nc,U_nc,1:numel(N) );
    Error_nc = ( X_all - X_est_nc ).^2;
    e_nc = ce( X_est_nc,X_all)/ce(X_all,0);
%
    n = FN(X_all);
    [G_batch,U_batch,t_b,e_b] = tb( X_all,R,100,1e-10 );
    [G_als,U_als,t_als,e_als] = als( X_all,R,1 );
    [G_ta,U_ta,t_ta,e_ta] = tuckals3( X_all,R,1 );    
    [~,~,~,~,t_svdk,e_svdk] = svdk(X_all,R,3);
    [~,~,~,~,t_svdmk,e_svdmk] = svdmk(X_all,R,3);
    [~,~,~,t_nnmfk,e_nnmfk] = nnmfk(X_all,R,3);
    [~,~,~,t_nnmfmk,e_nnmfmk] = nnmfmk(X_all,R,3);
    [~,t_aek,e_aek] = aek(X_all,3);
    [~,t_aemk,e_aemk] = aemk(X_all,3);
% 
     E =  [E;  [e e_nc e_b e_als e_ta]./ n];
     E1 = [E1; [e     e_nc e_b e_als e_ta e_svdk e_svdmk e_nnmfk e_nnmfmk e_aek e_aemk]];    
     T =  [T;  [t_new t_nc t_b t_als t_ta t_svdk t_svdmk t_nnmfk t_nnmfmk t_aek t_aemk]];
    
    U_ini = U_new;G_ini=G_new;
    U_ini_nc = U_nc;G_ini_nc = G_nc;
    
    fprintf('Rank of %g; Errors of at %g step is:\n',K, d);
    fprintf('on-the-fly: %g, on-the-fly-nc: %g\n',e,e_nc);
    fprintf('hosvd: %g, als: %g, tuckals3: %g\n',e_b,e_als,e_ta);
end
% ERROR = [ERROR; mean(E)];
% ERROR1 = [ERROR1; mean(E1)];
% TIMES = [TIMES; mean(T)];
ERROR = [ERROR; mean(E)];
ERROR1 = [ERROR1; mean(E1)];
TIMES = [TIMES; mean(T)];
end
% EE = [EE; (ERROR1)];
% TT = [TT; (TIMES)];
% end
%%
extention='.mat';
f = 'E505050_002_50';
filepath = '/Users/xiaohouping/Documents/MATLAB/dynamic_tucker_decomposition/accelerate_online_low_rank_tensor/on_the_fly/JOC/JOCR1/Reviwer1Point6';
matname = fullfile(filepath, [f extention]);
save(matname, 'E1')
f = 'T505050_002_50';
matname = fullfile(filepath, [f extention]);
save(matname, 'T')
%%
error = [];
times = [];
for m = 10:50:500
[G_batch,U_batch,t_b,e_b] = tb( X_all,R,m,1e-10 );
error= [error e_b];
times = [times t_b];
end
%%
% clc
% error = [];
% times = [];
% for i = 1000:100:2000
% opts.tol = 1e10;
% opts.maxit = i;
% t = tic;
% [a,b,c] = svds(A,10,'largest',opts);
% toc(t);
% e = sum(sum((a*b*c'-A).*(a*b*c'-A)));
% error = [error e];
% end