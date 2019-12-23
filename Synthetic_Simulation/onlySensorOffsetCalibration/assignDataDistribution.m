function combination_sample = assignDataDistribution(num_data)

    % factorization of the number of data
    vec_factor = factor(num_data);
    % length of prime factors
    length_factor = length(vec_factor);

    if length_factor == 1
        pos_primeFactors = randperm(4, 1);
    elseif length_factor == 2 
        pos_primeFactors = randperm(4, 2);
    elseif length_factor == 3 
        pos_primeFactors = randperm(4, 3);
    elseif length_factor == 4 
        pos_primeFactors = randperm(4, 4);
    end

   combination_sample = ones(1, 4);
   for i=1:length_factor
       combination_sample(pos_primeFactors(i)) = vec_factor(i);
   end    
end