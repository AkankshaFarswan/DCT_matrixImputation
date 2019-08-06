function [X_process] = data_preprocessing(Y)
for g =1:1:size(Y,1)
    for h=1:1:size(Y,2)
        if(Y(g,h)~=0)
            X_process(g,h) = log10(Y(g,h)+1);
        end
    end
end




