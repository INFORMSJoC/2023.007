function [X_new1,t2,e] = nnmfk4(XX,R,i)
% MF algorithm to compute svd on each
% matrix along each mode

II = size(XX);
X_new1 = tensor( rand(II) );
tt = [];
for j = 1 : II(1)
    X = XX(j,:,:,:);
    I = size(X);
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
[W{k},H{k}] = nnmf(tmp.data, min(R(i),min(min(I(1),I(2)),I(3))));
newX{k} = W{k}*H{k};
end

t = toc(t1);
tt = [tt t];
% X_new1 = tensor( rand(I) );
if i == 1
    for k = 1 : I(i)
        X_new1(j,k,:,:) = newX{k};
    end
elseif i == 2
    for k = 1 : I(i)
        X_new1(j,:,k,:) = newX{k};
    end
else
    for k = 1 : I(i)
        X_new1(j,:,:,k) = newX{k};
    end
end

end
t2 = sum(tt);
% t = toc(t1);
% Error = (X-X_new).^2;
% e = sqrt(sum(sum(sum(Error.data))));
e = ce( X_new1,XX ) / ce(XX,0);
end