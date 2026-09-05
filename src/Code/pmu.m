function U = pmu( X,G,U1,U2,U3,i )
% Update the projection matrix on mode i
order = [1 2 3];
order(order==i)=[];
G_new = ttm( G, {U1,U2,U3},order );
G_new_i = tenmat( G_new,i );
X_i = tenmat( X,i );

U = X_i.data / G_new_i.data;

end