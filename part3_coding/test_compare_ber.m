clc;
clear;
close all;

N = 1000;

L_values = [3 5 7];
p_values = 0:0.05:0.5;

ber_uncoded = zeros(size(p_values));
ber_coded = zeros(length(L_values), length(p_values));

for k = 1:length(p_values)

    p = p_values(k);

    bits = generate_bits(N);

    % Uncoded
    received_uncoded = bsc_channel(bits, p);
    ber_uncoded(k) = compute_ber(bits, received_uncoded);

    % Coded
    for j = 1:length(L_values)

        L = L_values(j);

        coded = repetition_encode(bits, L);

        received_coded = bsc_channel(coded, p);

        decoded = repetition_decode(received_coded, L);

        ber_coded(j, k) = compute_ber(bits, decoded);

    end
end

% Plot
figure;

plot(p_values, ber_uncoded, 'LineWidth', 2);
hold on;

plot(p_values, ber_coded(1,:), 'LineWidth', 2);
plot(p_values, ber_coded(2,:), 'LineWidth', 2);
plot(p_values, ber_coded(3,:), 'LineWidth', 2);

legend('Uncoded', 'L = 3', 'L = 5', 'L = 7');

xlabel('Channel Error Probability (p)');
ylabel('BER');

title('BER Comparison for Different Repetition Factors');

grid on;