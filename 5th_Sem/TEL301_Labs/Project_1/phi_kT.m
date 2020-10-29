function [phi_K] = phi_kT(phi, time, T, Ts, A)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Time shifts phi k*T to the right in the given time vector
%   Zero fills left and right when needed
%   k = (0:1:2*A)
%
%   INPUT:
%       function phi,
%       time vector,
%       T constant,
%       Ts constant
%   
%   OUTPUT:
%       k x length(time) Matrix

phi_K = zeros(11,length(time));
for k=0:1:2*A
    offset = k*T/Ts;
    padL = zeros(1,offset);
    padR = zeros(1,length(time) - offset - length(phi));
    t_phi_k = [padL, phi, padR];
    phi_K(k+1,:)= t_phi_k;
end
end

