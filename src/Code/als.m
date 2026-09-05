function [X_new,G,U,t,e] = als( X,R,iteration )
% ALS algorithm to compute a rank-R tucker decomposition for an Nth-order
% tensor X of size N_1 * N_2 * ...* N_K. Also known as the HOOI

% initialize U_k (N_k * R) using hosvd
t1 = tic;
I = size(X);
U = cell( numel(I),1 );
for k = 1 : numel( I )
   tmp = tenmat( X,k ); 
   [U{k},~,~] = svds( tmp.data, min( R(k), I(k) ) );
end
iter = 1;
while(iter<= iteration)
for k = 1 : numel( I )
    order = 1:numel(I);
    order(order==k) = [];
    Y = ttm( X, U, order, 't' );
    tmpy =tenmat( Y,k );
    [U{k},~,~] = svds( tmpy.data, min( R(k), I(k) ) );
end
iter = iter + 1;
end
G = ttm( X, U, 1:numel(I), 't');
t = toc(t1);

X_new = ttm( G, U, 1:numel(I) );

% Error = (X-X_new).^2;
% e = sqrt(sum(sum(sum(Error.data))));
e = ce( X_new,X ) / ce(X,0);
end