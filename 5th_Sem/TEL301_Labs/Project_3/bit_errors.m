function num_of_bit_errors = bit_errors(est_bit_seq, b)
    % Sum up evey occurance of difference between the original bit sequence and the decoded
    num_of_bit_errors = sum(sum(est_bit_seq ~= b));
end

