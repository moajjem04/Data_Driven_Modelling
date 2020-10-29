function [Ar,Br,Cr,Dr,HSVs] = ERA(YY,m,n,nin ,nout,r)

for i=1:nout
    for j=1:nin
        Dr(i,j) = YY(i,j,1);
        %%
        % 
        % * ITEM1
        % * ITEM2
        % 
        Y(i,j,:) = YY(i,j,2:end);
    end
end

% Yss = Y(1,1,end);
% Y = Y-Yss;
% Y(i,j,k)::
% i refers to ith output
% j refers to jth input
% k refers to kth time step
% nin,nout number of inputs and outputs
% m,n dimensions of Hankel matrix
% r, dimensions of reduced model

assert(length(Y(:,1,1))==nout);
assert(length(Y(1,:,1))==nin);
assert(length(Y(1,1,:))>=m+n);

% how do you determine the dimensions of hankel matrix
for i=1:m
    for j=1:n
        for Q=1:nout
            for P=1:nin
                H(nout*i-nout+Q,nin*j-nin+P) = Y(Q,P,i+j-1);
                H2(nout*i-nout +Q,nin*j-nin+P) = Y(Q,P,i+j);
            end
        end
    end
end

[U,S,V] = svd(H,'econ');
Sigma = S(1:r,1:r);
Ur = U(:,1:r);
Vr = V(:,1:r);
Ar = Sigma^(-.5)*Ur'*H2*Vr*Sigma^(-.5);
Br = Sigma^(-.5)*Ur'*H(:,1:nin);
Cr = H(1:nout ,:)*Vr*Sigma^(-.5);
HSVs = diag (S);

