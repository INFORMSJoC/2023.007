function [U,G,V,t,e] = mf(X,R)
% MF algorithm to compute 
% matrix factorization on each
% matrix on the third mode

I = size(X);
newX = cell (I(3),1);
U = cell( I(3),1 );
G = cell( I(3),1 );
V = cell( I(3),1 );
t1 = tic;
for k = 1 : I(3)
tmp = X(:,:,k);
[U{k},G{k},V{k}] = svds(tmp.data, min(R,min(I(1),I(2))));
newX{k} = U{k}*G{k}*V{k}';
end

t = toc(t1);

X_new1 = tensor( rand(I) );
for k = 1 : I(3)
    X_new1(:,:,k) = newX{k};
end

X_new = X_new1;

% t = toc(t1);
% Error = (X-X_new).^2;
% e = sqrt(sum(sum(sum(Error.data))));
e = ce( X_new,X ) / ce(X,0);
end