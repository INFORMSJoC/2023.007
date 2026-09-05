function l = index( k )
%%
%k=4;
temp = 1:k;
l = [];
for i = 0 : k
   ll = combnk(temp,i);
   if isempty(ll)
       t = ones(1,k);
       l = [l;t];
   else
       a = size(ll);
       for j = 1 : a(1)
           t = ones(1,k);
           for s = 1 : length(ll(j,:))
               t(ll(j,s)) = 2;
           end
           l=[l;t];
       end
   end
end