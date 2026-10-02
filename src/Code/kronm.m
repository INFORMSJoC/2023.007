function u = kronm( U,k )
% this function is built to calculate the kronecker product of U1 kron U2
% kron ...kron UK
I = size( U );
UU = cell( I );
for i = 1 : I(1)
   UU{i} = U{ I(1)-i+1 }; 
end
UU(I(1)-k+1,:) = [];

u = UU{1};
for i = 1 : (I(1)-2)
   u =  kron( u,UU{i+1});
end
end