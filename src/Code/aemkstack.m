function [X_new,t,e] = aemkstack(X,k)
% MF algorithm to compute matrix factorization
% after mattricization on the mode k
t1 = tic;
tmp = tenmat(X,k);
% [U,G,V] = svds(tmp.data, min(R(k),I(k)),'largest', opt);
% [U,G,V] = svds(tmp.data, min(R(k),I(k)));
autoenc1 = trainAutoencoder(tmp.data,100,...
'MaxEpochs',10,'ShowProgressWindow',0);
autoenc2 = trainAutoencoder(tmp.data,100,...
    'MaxEpochs',10,'ShowProgressWindow',0);
autoenc3 = trainAutoencoder(tmp.data,100,...
    'MaxEpochs',10,'ShowProgressWindow',0);


newX1 = predict(autoenc1,tmp.data);
newX2 = predict(autoenc2,tmp.data);
newX3 = predict(autoenc3,tmp.data);

newX = (newX1+newX2+newX3)/3;

t = toc(t1);
% newX = U*G*V';

tmp2 = tenmat(newX,tmp.rdims,tmp.cdims,tmp.tsize);

X_new = tensor( tmp2 );
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