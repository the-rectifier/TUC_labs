function X = bits_to_4PAM(bits)
    X = zeros(1,length(bits)/2);
    j = 1;
    for i=1:2:length(bits)
        if(bits(i) == 0 && bits(i+1) == 0) 
            X(j) = +3;
        elseif(bits(i) == 0 && bits(i+1) == 1) 
            X(j) = +1;
        elseif(bits(i) == 1 && bits(i+1) == 1) 
            X(j) = -1;
        elseif(bits(i) == 1 && bits(i+1) == 0) 
            X(j) = -3;
        end
        j = j+1;
    end
end