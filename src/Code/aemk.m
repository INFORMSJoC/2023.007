function [X_new,t,e] = aemk(X,k)
% MF algorithm to compute matrix factorization
% after mattricization on the mode k
t1 = tic;
tmp = tenmat(X,k);
% [U,G,V] = svds(tmp.data, min(R(k),I(k)),'largest', opt);
% [U,G,V] = svds(tmp.data, min(R(k),I(k)));
autoenc = trainAutoencoder(tmp.data,5,...
'MaxEpochs',10,'ShowProgressWindow',0);
newX = predict(autoenc,tmp.data);

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