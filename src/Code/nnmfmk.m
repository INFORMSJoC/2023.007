function [X_new,W,H,t,e] = nnmfmk(X,R,k)
% MF algorithm to compute matrix factorization
% after mattricization on the mode k
% opt.tol=1e-3;

t1 = tic;
I = size(X);
tmp = tenmat(X,k);
% [U,G,V] = svds(tmp.data, min(R(k),I(k)),'largest', opt);
opt = statset('MaxIter',100, 'TolX',1e-2,'TolFun',1e-2);

[W,H] = nnmf(tmp.data, min(R(k),I(k)),'Algorithm','mult','options',opt);

newX = W*H;

tmp2 = tenmat(newX,tmp.rdims,tmp.cdims,tmp.tsize);

X_new = tensor( tmp2 );
t = toc(t1);
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