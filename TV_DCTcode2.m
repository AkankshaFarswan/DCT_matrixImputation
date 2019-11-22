clc;
clear all;
close all
load data.mat; %load input data
X_input = data;
[row,col]=size(X_input);
%Normalize data if range of values is high
for j = 1:1:9
    % Using compressive sensing to recover matrix from incomplete matrix
    obs = j; % Percentage observed [0...1]
    [Omega] = subsampling_code(X_input, obs); % randomly introducing missing values
    X_observed = X_input.*Omega;    
    %Stage 1: using compressive sensing to fill the incomplete matrix
    for i=1:col
        fprintf('col=%d\n', i);
        Xvec = X_observed(:,i);
        Xvec2 = X_observed(:);
        [phi, y]=getphi(Xvec);
        D=dctmtx(row);
        H=phi*D';
        opts = spgSetParms('verbosity',0);  
        sigma = 0.000000001;
        tau = pi;
        x_rec = spg_bpdn(H, y,sigma, opts);
        X_reconstructed(:,i) = D'*x_rec;
    end
    
    %error
    temp1 = norm(X_reconstructed-X_input,'fro');
    nrmse1(j) = temp1/norm(X_input,'fro');
    
    for l=1:col
        xrow2 = X_reconstructed(:,l);
        xout2= denoiseTV(xrow2',4,200);
        X_reconstructed2(:,l) = xout2;
    end
    for s=1:col
        for t=1:row
            if(X_observed(t,s)~=0)
                X_reconstructed2(t,s) = X_observed(t,s);
            end
        end
    end
    temp2 = norm(X_reconstructed2 - X_input,'fro');
    nrmse2(j) = temp2/norm(X_input,'fro');  
end

