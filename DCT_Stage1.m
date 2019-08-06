%%DCT based sparsity method to impute missing values in columns of
%%incomplete matrix
%Input Matrix - X_in
%Filled matrix - X_rev
%Input the matrix whose columns needs to be filled
X_in = incomp;
[row col] = size(X_in);
for i=1:1:col
        Xvec = X_in(:,i);
        [phi, y]=getphi(Xvec);
        D=dctmtx(row);
        H=phi*D';
        opts = spgSetParms('verbosity',0);       
        sigma = 0.000000001;
        tau = pi;
        x_rec = spg_bpdn(H, y,sigma, opts);
        X_rev= D'*x_rec;
end
