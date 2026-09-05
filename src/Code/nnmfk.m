function [X_new,W,H,t,e] = nnmfk(X,R,i)
% MF algorithm to compute svd on each
% matrix along each mode

I = size(X);
% i = 1;
newX = cell (I(i),1);
W = cell( I(i),1 );
H = cell( I(i),1 );
t1 = tic;
for k = 1 : I(i)
    if i == 1
        tmp = X(k,:,:);
    elseif i ==2
        tmp = X(:,k,:);
    else
        tmp = X(:,:,k);
    end

    opt = statset('MaxIter',20, 'TolX',5e-2,'TolFun',5e-2);
[W{k},H{k}] = nnmf(tmp.data, min(R(i),min(min(I(1),I(2)),I(3))),...
    'Algorithm','mult','options',opt);
newX{k} = W{k}*H{k};
end

t = toc(t1);

X_new1 = tensor( rand(I) );
if i == 1
    for k = 1 : I(i)
        X_new1(k,:,:) = newX{k};
    end
elseif i == 2
    for k = 1 : I(i)
        X_new1(:,k,:) = newX{k};
    end
else
    for k = 1 : I(i)
        X_new1(:,:,k) = newX{k};
    end
end

X_new = X_new1;

% t = toc(t1);
% Error = (X-X_new).^2;
% e = sqrt(sum(sum(sum(Error.data))));
e = ce( X_new,X ) / ce(X,0);
end