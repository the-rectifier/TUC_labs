function X = bits_to_2PAM(bits)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   X = bits_to_2PAM(bits)                                                %
%                                                                         %
%       OUTPUT                                                            %
%            X: An array which contains only 1's and -1's                 %
%       INPUT                                                             %
%           bits: An array which contains only 1's and 0's                %
%                                                                         %
%    O. Stavrou, O. Tsirou, Oct. 2020                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
X = zeros(1, length(bits));
X(bits==1) = -1;
X(bits==0) =  1;
end