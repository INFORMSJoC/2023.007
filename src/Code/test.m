[U_svdall,G_svdall,V_svdall,t_svdall,e_svdall] = svdall(X_all,R);
[U_svdk,G_svdk,V_svdk,t_svdk,e_svdk] = svdk(X_all,R,3);
[U_svdmall,G_svdmall,V_svdmall,t_svdmall,e_svdmall] = svdmall(X_all,R);
[U_svdmk,G_svdmk,V_svdmk,t_svdmk,e_svdmk] = svdmk(X_all,R,1);


[U_nnmfall,G_nnmfall,t_nnmfall,e_nnmfall] = nnmfall(X_all,R);
[U_nnmfk,G_nnmfk,t_nnmfk,e_nnmfk] = nnmfk(X_all,R,3);
[U_nnmfmall,G_nnmfmall,t_nnmfmall,e_nnmfmall] = nnmfmall(X_all,R);
[U_nnmfmk,G_nnmfmk,t_nnmfmk,e_nnmfmk] = nnmfmk(X_all,R,1);
%%

X1 = X_all(:,:,1);
autoenc = trainAutoencoder(X1.data,25,...
    'ShowProgressWindow',0);
X1r = predict(autoenc,X1.data);

sum(sum((X1r-X1.data).^2)) / sum(sum((X1.data).^2))

% autoenc = trainAutoencoder(x',hiddenSize,...
%         'EncoderTransferFunction','satlin',...
%         'DecoderTransferFunction','purelin',...
%         'L2WeightRegularization',0.01,...
%         'SparsityRegularization',4,...
%         'SparsityProportion',0.10);

%% Training Options
Options.max_itera=100;            % maximum number of learning itterations
Options.N_gs=60;                  % number of gibbs samplling steps
Options.Nneurons=gamma(1);        % number of neurons in the hidden layer
Options.eps=0.001;                 % learning rate
Options.Sz_mb=100;                 % size if mini-batch of data
%% Training process 

net=RBM_TB(X1.data,Options);% training

[y]=RBM_RECONSTRUCT(net,X1.data);

sum(sum((y-X1.data).^2)) / sum(sum((X1.data).^2))
