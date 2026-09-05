function [X_new_batch,G_batch,U_pro_batch,tt,er] = tb( X_new,RR, m,e )
% This function is built for batch tucker decomposition of X, the rank of
% the core tensor is RR = [r1,r2,r3];
%X_new = X_all;RR=[3,3,3];
opts.tol=e;
opts.maxit = m;
t=tic;
I = size(X_new);
U_pro_batch = cell(numel(I),1);
%for r = 3
%RR = [r,r,r];
for i = 1 : numel(I)
    tmp = tenmat(X_new,i);
    [U_pro_batch{i},~,~] = svds( tmp.data,min(RR(i),I(i)),'largest',opts ) ;
end
G_batch = ttm( X_new, U_pro_batch, 1:numel(I), 't' );
tt = toc(t);
X_new_batch = ttm( G_batch, U_pro_batch, 1:numel(I) );

% Error_batch = (X_new-X_new_batch).^2;
% er = sqrt(sum(sum(sum(Error_batch.data))));

er = ce( X_new_batch,X_new) / ce(X_new,0);
end