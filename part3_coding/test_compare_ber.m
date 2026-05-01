clc;
clear;
close all;

N = 1000;
L = 3;
p_values = 0:0.05:0.5;

ber_uncoded = zeros(size(p_values));
ber_coded = zeros(size(p_values));

for k = 1:length(p_values)
    p = p_values(k);
    
    bits = generate_bits(N);

    received_uncoded = bsc_channel(bits, p);
    ber_uncoded(k) = compute_ber(bits, received_uncoded);

    coded = repetition_encode(bits, L);
    received_coded = bsc_channel(coded, p);
    decoded = repetition_decode(received_coded, L);
    ber_coded(k) = compute_ber(bits, decoded);
end 

figure;
plot(p_values, ber_uncoded, 'o-', 'LineWidth', 2); hold on;
plot(p_values, ber_coded, 's-', 'LineWidth', 2);
legend('Uncoded', 'Repetition Code(L = 3)');
xlabel('Channel Error Probability(p)');
ylabel('BER');
title('BER Comparison');
grid on;