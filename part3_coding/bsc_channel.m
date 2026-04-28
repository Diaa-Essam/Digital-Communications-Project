function received = bsc_channel(bits, p)
    N = length(bits);
    
    errors = rand(1, N) < p; % Generates array of boolean values if random is less than p val is true else val is false;
    
    received = xor(bits, errors);
end