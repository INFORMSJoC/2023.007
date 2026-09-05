function [newX,t2,e] = aek4(XX,i)
% MF algorithm to compute svd on each
% matrix along each mode

II = size(XX);
X_new1 = tensor( rand(II) );
tt = [];
for j =1:II(1)
    X = XX(j,:,:,:);
    I = size(X);
newX = cell (I(i),1);
t1 = tic;
for k = 1 : I(i)
    if i == 1
        tmp = X(k,:,:);
    elseif i ==2
        tmp = X(:,k,:);
    else
        tmp = X(:,:,k);
    end
% [U{k},G{k},V{k}] = svds(tmp.data, min(R(i),min(min(I(1),I(2)),I(3))));
% newX{k} = U{k}*G{k}*V{k}';
autoenc = trainAutoencoder(tmp.data,...
    'MaxEpochs',100,'ShowProgressWindow',0);
newX{k} = predict(autoenc,tmp.data);
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
% X_new = X_new1;

% t = toc(t1);
% Error = (X-X_new).^2;
% e = sqrt(sum(sum(sum(Error.data))));
e = ce( X_new1,XX ) / ce(XX,0);
end