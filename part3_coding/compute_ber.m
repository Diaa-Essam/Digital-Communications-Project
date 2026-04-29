function ber = compute_ber(original, received)
    errors = sum(original ~= received);
    
    ber = errors/ length(original);
    
end