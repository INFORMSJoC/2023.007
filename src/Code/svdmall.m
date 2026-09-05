function [U,G,V,t,e] = svdmall(X,R)
% MF algorithm to compute matrix factorization
% after mattricization
t1 = tic;
I = size(X);
newX = cell( numel(I),1 );
X_new1 = cell( numel(I),1);
U = cell( numel(I),1 );
G = cell( numel(I),1 );
V = cell( numel(I),1 );
for k = 1 : numel(I)
tmp = tenmat(X,k);
[U{k},G{k},V{k}] = svds(tmp.data, min(R(k),I(k)));
newX{k} = U{k}*G{k}*V{k}';
X_new1{k} = tensor(tenmat(newX{k},tmp.rdims,tmp.cdims,tmp.tsize));

end

t = toc(t1);

X_new = 0;
for i = 1 : numel(I)
   X_new = X_new + X_new1{i} ;
end
X_new = X_new / numel(I);

% t = toc(t1);
% Error = (X-X_new).^2;
% e = sqrt(sum(sum(sum(Error.data))));
e = ce( X_new,X ) / ce(X,0);
end