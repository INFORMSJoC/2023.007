function Ui = pmum( X,G,U,m )
% Update the auxiliary matrix on mode i
d = size( X );
order = 1 : numel(d);
order (order==m) = [];
G = ttm( G, U, order );
%G_new = ttm( G, {U{1},U{2},U{3},U{4}}, dims );
G_i = tenmat( G,m );
X_i = tenmat( X,m );

Ui = X_i.data / G_i.data;


end
