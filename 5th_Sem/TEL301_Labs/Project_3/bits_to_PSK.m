function [out] = bits_to_PSK(bit_seq)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
% Input:   Nx3 matrix with 3-bit tuple in each row
% Output:    Nx2 matrix with symbol definitions
% 
% Encode using the above table
%
% for each one of the 8 3-bit segments available 
% create the correspoding point with I and Q values
%
% Note: Values close to 0 ie: cos(π/2) are hardcoded to 0
%       manualy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = length(bit_seq(:,1));
xn = [0 0];
out = zeros(N, 2);
n = 1;

for i=1:N
   if(bit_seq(i,1) == 0 && bit_seq(i,2) == 0 && bit_seq(i,3) == 0)
       xn(1) = cos(2*pi*0/8);
       xn(2) = sin(2*pi*0/8);
       out(n,:) = xn;
   elseif(bit_seq(i,1) == 0 && bit_seq(i,2) == 0 && bit_seq(i,3) == 1)
       xn(1) = cos(2*pi*1/8);
       xn(2) = sin(2*pi*1/8);
       out(n,:) = xn;
   elseif(bit_seq(i,1) == 0 && bit_seq(i,2) == 1 && bit_seq(i,3) == 1)
       xn(1) = 0; % cos(2*pi*2/8);
       xn(2) = sin(2*pi*2/8);
       out(n,:) = xn;
   elseif(bit_seq(i,1) == 0 && bit_seq(i,2) == 1 && bit_seq(i,3) == 0)
       xn(1) = cos(2*pi*3/8);
       xn(2) = sin(2*pi*3/8);
       out(n,:) = xn;
   elseif(bit_seq(i,1) == 1 && bit_seq(i,2) == 1 && bit_seq(i,3) == 0)
       xn(1) = cos(2*pi*4/8);
       xn(2) = 0; %sin(2*pi*4/8);
       out(n,:) = xn;
   elseif(bit_seq(i,1) == 1 && bit_seq(i,2) == 1 && bit_seq(i,3) == 1)
       xn(1) = cos(2*pi*5/8);
       xn(2) = sin(2*pi*5/8);
       out(n,:) = xn;
   elseif(bit_seq(i,1) == 1 && bit_seq(i,2) == 0 && bit_seq(i,3) == 1)
       xn(1) = 0; % cos(2*pi*6/8);
       xn(2) = sin(2*pi*6/8);
       out(n,:) = xn;
   elseif(bit_seq(i,1) == 1 && bit_seq(i,2) == 0 && bit_seq(i,3) == 0)
       xn(1) = cos(2*pi*7/8);
       xn(2) = sin(2*pi*7/8);
       out(n,:) = xn;
   end
   n = n + 1;
end
end

