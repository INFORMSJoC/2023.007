function [W,H,t,e] = nnmfall(X,R)
% MF algorithm to compute svd on each
% matrix along each mode

I = size(X);
% i = 1;
updatedX = cell (numel(I),1);
tt = cell(numel(I),1);

for i = 1 : numel(I)
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
tt{i} = t;

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

updatedX{i} = X_new1;

end
X_new = 0;
ttt = 0;
for i = 1 : numel(I)
   X_new = X_new + updatedX{i} ;
   ttt = ttt + tt{i};
end
X_new = X_new / numel(I);
t = ttt;
% t = toc(t1);
% Error = (X-X_new).^2;
% e = sqrt(sum(sum(sum(Error.data))));
e = ce( X_new,X ) / ce(X,0);
end