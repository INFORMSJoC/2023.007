function [X_new1,t,e] = aekstack(X,i)
% MF algorithm to compute svd on each
% matrix along each mode

I = size(X);
% i = 1;
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
autoenc1 = trainAutoencoder(tmp.data,10,...
    'MaxEpochs',10,'ShowProgressWindow',0);
autoenc2 = trainAutoencoder(tmp.data,10,...
    'MaxEpochs',10,'ShowProgressWindow',0);
autoenc3 = trainAutoencoder(tmp.data,10,...
    'MaxEpochs',10,'ShowProgressWindow',0);
% stackednet = stack(autoenc1,autoenc2,autoenc3);

newX{k} = (predict(autoenc1,tmp.data)+predict(autoenc2,tmp.data) + predict(autoenc3,tmp.data))/3;
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