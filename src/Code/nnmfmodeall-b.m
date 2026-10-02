function [w,H,t,e] = nnmfmodeall(X,R)
% MF algorithm to compute matrix factorization
% after mattricization
t1 = tic;
I = size(X);
newX = cell( numel(I),1 );
w = cell( numel(I),1 );
H = cell( numel(I),1 );
for k = 1 : numel(I)
tmp = tenmat(X,k);
[w{k},H{k}] = nnmf(tmp.data, min(R(k),I(k)));
newX{k} = w{k}*H{k};
end

t = toc(t1);

X_new1 = tensor( rand(I) );
for j = 1 : I(k)
    X_new1(j,:,:) = newX{1}(:,(j-1)*I(k)+1:j*I(k));
end
X_new2 = tensor( rand(I) );
for j = 1 : I(k)
    X_new2(:,j,:) = newX{2}(:,(j-1)*I(k)+1:j*I(k));
end
X_new3 = tensor( rand(I) );
for j = 1 : I(k)
    X_new3(:,:,j) = newX{3}(:,(j-1)*I(k)+1:j*I(k));
end

X_new = (X_new1+X_new2+X_new3)/3;

% t = toc(t1);
% Error = (X-X_new).^2;
% e = sqrt(sum(sum(sum(Error.data))));
e = ce( X_new,X ) / ce(X,0);
end