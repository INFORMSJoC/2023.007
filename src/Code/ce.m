function e = ce( X,Y )
s = size(X);
E = ( X - Y ).^2;
Ed = E.data;
for i = 1 : numel(s)
    Ed = sum(Ed);
end
e = sqrt( Ed );
end