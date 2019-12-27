function combination_sample = assignDataDistribution(num_data)

    % factorization of the number of data
    vec_factor = factor(num_data);
    % length of prime factors
    length_factor = length(vec_factor);

    while true
        if length_factor == 1
            pos_primeFactors = randperm(4, 1);
            break;
        elseif length_factor == 2 
            pos_primeFactors = randperm(4, 2);
            break;
        elseif length_factor == 3 
            pos_primeFactors = randperm(4, 3);
            break;
        elseif length_factor == 4 
            pos_primeFactors = randperm(4, 4);
            break;
        else
            % prime factor���� ���� 4���� �ʰ��ϸ�, ���� ���� 2���� ���ؼ� prime factor���� 4������
            % ����
            temp_vec_factor = zeros(1, length(vec_factor)-1);
            temp_vec_factor(2:end) = vec_factor(3:end);
            temp_vec_factor(1) = vec_factor(1)*vec_factor(2);
            
            vec_factor = temp_vec_factor;
            length_factor = length(vec_factor);
        
        end
    end

   combination_sample = ones(1, 4);
   for i=1:length_factor
       combination_sample(pos_primeFactors(i)) = vec_factor(i);
   end    
end