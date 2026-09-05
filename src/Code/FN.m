function a = FN( X )
% this function is built to calculate the F norm of a tensor X

s = size( X );
a = (X.data).^2;

for i = 1 : numel( s )
    a = sum(a);
end

end