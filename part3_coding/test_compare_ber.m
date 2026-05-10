clc;
clear;
close all;

N = 1000;                          % Number of transmitted bits

L_values = [3 5 7];                % Repetition factors
p_values = 0:0.05:0.5;             % Channel error probabilities

ber_uncoded = zeros(size(p_values));
% Store BER values for uncoded system

ber_coded = zeros(length(L_values), length(p_values));
% Store BER values for coded systems

trials = 20;                       % Number of experiments for averaging

for k = 1:length(p_values)

    p = p_values(k);               % Current channel error probability

    ber_u = 0;                     
    % Accumulator for uncoded BER

    ber_c = zeros(1, length(L_values));
    % Accumulator for coded BER

    for t = 1:trials

        bits = generate_bits(N);
        % Generate random transmitted bits

        % -------- Uncoded System --------
        received_uncoded = bsc_channel(bits, p);
        % Pass bits through BSC channel

        ber_u = ber_u + compute_ber(bits, received_uncoded);
        % Add BER result to accumulator

        % -------- Coded Systems --------
        for j = 1:length(L_values)

            L = L_values(j);
            % Current repetition factor

            coded = repetition_encode(bits, L);
            % Encode bits using repetition code

            received_coded = bsc_channel(coded, p);
            % Pass coded bits through channel

            decoded = repetition_decode(received_coded, L);
            % Decode using majority voting

            ber_c(j) = ber_c(j) + compute_ber(bits, decoded);
            % Add coded BER result to accumulator

        end
    end

    % Average BER over all trials
    ber_uncoded(k) = ber_u / trials;

    ber_coded(:, k) = ber_c' / trials;

end

disp('Coding Overhead: ');

for j = 1:length(L_values)
    L = L_values(j);
    
    transmitted_bits = N * L;
    fprintf('L = %d -> Transmitted Bits = %d\n', L, transmitted_bits);
end

% -------- Plot Results --------
figure;

semilogy(p_values, ber_uncoded, 'LineWidth', 2);
hold on;

semilogy(p_values, ber_coded(1,:), 'LineWidth', 2);
semilogy(p_values, ber_coded(2,:), 'LineWidth', 2);
semilogy(p_values, ber_coded(3,:), 'LineWidth', 2);

legend('Uncoded', 'L = 3', 'L = 5', 'L = 7');

xlabel('Channel Error Probability (p)');
ylabel('BER');

title('BER Comparison for Different Repetition Factors');

grid on;

% Observation:
% Repetition coding reduces BER compared to uncoded transmission.
% Larger repetition factors provide better protection against errors.
% However, increasing repetition also increases redundancy and bandwidth usage.
%
% At high channel error probabilities, all systems degrade due to excessive errors.