%%DCT based sparsity method to impute missing values in columns of
%%incomplete matrix
%Incomplete input Matrix - X_in
%Filled matrix from Stage-1  - X_rev
%Output imputed matrix- X_reconstructed
%Input the matrix whose columns needs to be filled
load X_in.mat;
[row col] = size(X_in);
%Normalize data if range of values is high
% function 'data_preprocessing.m' for Normalizing data
%function 'data_reverseprocess.m' for converting normalized data back to original values
%Stage 1: using compressive sensing to fill the incomplete matrix
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

%Stage 2: TV denoising to remove noise from the matrix recovered
for l=1:col
        xrow2 = X_rev(:,l);
        xout2= denoiseTV(xrow2',4,200); %set lambda and Nit accordingly
        X_reconstructed(:,l) = xout2;
end
for s=1:col
    for t=1:row
        if(X_in(t,s)~=0)
            X_reconstructed(t,s) = X_in(t,s);
        end
    end
end
