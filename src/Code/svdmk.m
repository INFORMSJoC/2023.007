function [X_new,U,G,V,t,e] = svdmk(X,R,k)
% MF algorithm to compute matrix factorization
% after mattricization on the mode k
% opt.tol=1e-3;
opt.maxit = 200;
t1 = tic;
I = size(X);
X_new1=cell(3,1);
for i = 1:3
tmp = tenmat(X,i);
options = struct('tol',1e-3,'maxit',300);

% [U,G,V] = svds(tmp.data, min(R(k),I(k)),'largest', opt);
[U,G,V] = svds(tmp.data, min(R(i),I(i)),'largest',options);

newX = U*G*V';

tmp2 = tenmat(newX,tmp.rdims,tmp.cdims,tmp.tsize);

X_new1{i} = tensor( tmp2 );
end
t = toc(t1);
X_new = (X_new1{1}+X_new1{2}+X_new1{3})/3;
% if k == 1
%     for j = 1 : I(k)
%     X_new(j,:,:) = newX(:,(j-1)*I(k)+1:j*I(k));
%     end
% elseif k == 2
%     for j = 1 : I(k)
%     X_new(:,j,:) = newX(:,(j-1)*I(k)+1:j*I(k));
%     end
% else
% for j = 1 : I(k)
%     X_new(:,:,j) = newX(:,(j-1)*I(k)+1:j*I(k));
% end
% end
% t = toc(t1);
% Error = (X-X_new).^2;
% e = sqrt(sum(sum(sum(Error.data))));
e = ce( X_new,X ) / ce(X,0);
end