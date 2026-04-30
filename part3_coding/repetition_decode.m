function decoded = repetition_decode(received, L)
    
    N = length(received) / L;
    decoded = zeros(1, N);
    
    for i = 1:N
        block = received((i - 1) * L + 1 : i * L);
        
        if sum(block) > L / 2
             decoded(i) = 1;
        else
             decoded(i) = 0;
        end
    end
end