function [G_new,U_new,t_new] = on_the_fly_m3( G,U,X,d,in,alpha )
% this function is built to implement the online tucker decomposition
% method, on-the-fly with constrait that the projection matrices should be
% orthogonormal matrices (i.e., U' * U = I )
t = tic;
U1 = cell( 2,1 );U1{1} = U{1};%U1{2} = eye( d{1}(2),R(1) );
U2 = cell( 2,1 );U2{1} = U{2};%U2{2} = eye( d{2}(2),R(2) );
U3 = cell( 2,1 );U3{1} = U{3};%U3{2} = eye( d{3}(2),R(3) );
%U4 = cell( 2,1 );U4{1} = U{4};%U3{2} = eye( d{3}(2),R(3) );
%U5 = cell( 2,1 );U5{1} = U{5};%U3{2} = eye( d{3}(2),R(3) );
%U6 = cell( 2,1 );U6{1} = U{6};%U3{2} = eye( d{3}(2),R(3) );
%U7 = cell( 2,1 );U7{1} = U{7};%U3{2} = eye( d{3}(2),R(3) );
%U_new = U_old;
% update auxiliary matrices
[a,b] = size(in);
for i = 1 : a
    if in(i,1) == 2
        U1{in(i,1)} = pmum( X{ i },G,{U1{in(i,1)},U2{in(i,2)},U3{in(i,3)}},1 );
    end
    if in(i,2) == 2
        U2{in(i,2)} = pmum( X{ i },G,{U1{in(i,1)},U2{in(i,2)},U3{in(i,3)}},2 );
    end
    if in(i,3) == 2
        U3{in(i,3)} = pmum( X{ i },G,{U1{in(i,1)},U2{in(i,2)},U3{in(i,3)}},3 );
    end
%     if in(i,4) == 2
%         U4{in(i,4)} = pmum( X{ i },G,{U1{in(i,1)},U2{in(i,2)},U3{in(i,3)},...
%             U4{in(i,4)}},4 );
%     end
%     if in(i,5) == 2
%         U5{in(i,5)} = pmum( X{ i },G,{U1{in(i,1)},U2{in(i,2)},U3{in(i,3)},...
%             U4{in(i,4)},U5{in(i,5)}},5 );
%     end
%     if in(i,6) == 2
%         U6{in(i,6)} = pmum( X{ i },G,{U1{in(i,1)},U2{in(i,2)},U3{in(i,3)},...
%             U4{in(i,4)},U5{in(i,5)},U6{in(i,6)},U7{in(i,7)}},6 );
%     end
%     if in(i,7) == 2
%         U7{in(i,7)} = pmum( X{ i },G,{U1{in(i,1)},U2{in(i,2)},U3{in(i,3)},...
%             U4{in(i,4)},U5{in(i,5)},U6{in(i,6)},U7{in(i,7)}},7 );
%     end
end

U_new = cell( b,1 );
U_new{1} = [U{1}; U1{2}];
U_new{2} = [U{2}; U2{2}];
U_new{3} = [U{3}; U3{2}];
%U_new{4} = [U{4}; U4{2}];
%U_new{5} = [U{5}; U5{2}];
% U_new{6} = [U{6}; U6{2}];
% U_new{7} = [U{7}; U7{2}];
% Orthogonalization

U_new{1} = gs(U_new{1});
U_new{2} = gs(U_new{2});
U_new{3} = gs(U_new{3});
%U_new{4} = gs(U_new{4});
%U_new{5} = gs(U_new{5});
% U_new{6} = gs(U_new{6});
% U_new{7} = gs(U_new{7});
% update core tensor
G_new = ttm(G,{U_new{1}(1:d(1),:)'*U{1}, U_new{2}(1:d(2),:)'*U{2},...
    U_new{3}(1:d(3),:)'*U{3}}, 1:b);
for i = 2 : a
    if in(i,1) == 1
        U11 = U_new{1}(1:d(1),:);
    else
        U11 = U_new{1}(d(1)+1:end,:);
    end
    if in(i,2) == 1
        U22 = U_new{2}(1:d(2),:);
    else
        U22 = U_new{2}(d(2)+1:end,:);
    end
    if in(i,3) == 1
        U33 = U_new{3}(1:d(3),:);
    else
        U33 = U_new{3}(d(3)+1:end,:);
    end
%     if in(i,4) == 1
%         U44 = U_new{4}(1:d(4),:);
%     else
%         U44 = U_new{4}(d(4)+1:end,:);
%     end
%     if in(i,5) == 1
%         U55 = U_new{5}(1:d(5),:);
%     else
%         U55 = U_new{5}(d(5)+1:end,:);
%     end
%     if in(i,6) == 1
%         U66 = U_new{6}(1:d(6),:);
%     else
%         U66 = U_new{6}(d(6)+1:end,:);
%     end
%     if in(i,7) == 1
%         U77 = U_new{7}(1:d(7),:);
%     else
%         U77 = U_new{7}(d(7)+1:end,:);
%     end
    G_new = G + alpha*ttm(X{i},{U11,U22,U33},1:b,'t');
end

t_new = toc(t);
end