function [bit_seq_dec] = decode(decision_symb)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%BIT SEQ    In_Phase   Quadrature
% 0 0 0 <->  1          0
% 0 0 1 <->  0.7071     0.7071
% 0 1 1 <->  0          1
% 0 1 0 <-> -0.7071     0.7071
% 1 1 0 <-> -1          0
% 1 1 1 <-> -0.7071    -0.7071
% 1 0 1 <->  0         -1
% 1 0 0 <->  0.7071    -0.7071
%
%
% Input:    Nx2 matrix with symbol definitions
% Output:   Nx3 matrix with 3-bit tuple in each row
% Decode using the above table
%
% for each one of the 8 points available append 
% the correct bit sequence
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N_symbols = length(decision_symb(:,1));
bit_seq_dec = zeros(N_symbols,3);
for k=1:N_symbols
    if(decision_symb(k,1) == 1 && decision_symb(k,2) == 0)
        bit_seq_dec(k,:) = [0 0 0];
    elseif(decision_symb(k,1) == sqrt(2)/2 && decision_symb(k,2) == sqrt(2)/2)
        bit_seq_dec(k,:) = [0 0 1];
    elseif(decision_symb(k,1) == 0 && decision_symb(k,2) == 1)
        bit_seq_dec(k,:) = [0 1 1];
    elseif(decision_symb(k,1) == -sqrt(2)/2 && decision_symb(k,2) == sqrt(2)/2)
        bit_seq_dec(k,:) = [0 1 0];
    elseif(decision_symb(k,1) == -1 && decision_symb(k,2) == 0)
        bit_seq_dec(k,:) = [1 1 0];
    elseif(decision_symb(k,1) == -sqrt(2)/2 && decision_symb(k,2) == -sqrt(2)/2)
        bit_seq_dec(k,:) = [1 1 1];
    elseif(decision_symb(k,1) == 0 && decision_symb(k,2) == -1)
        bit_seq_dec(k,:) = [1 0 1];
    elseif(decision_symb(k,1) == sqrt(2)/2 && decision_symb(k,2) == -sqrt(2)/2)
        bit_seq_dec(k,:) = [1 0 0];
    end
end