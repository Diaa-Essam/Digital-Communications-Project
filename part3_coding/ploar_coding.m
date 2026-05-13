%% =====================================================
%%  Polar Code - BSC BER Simulation
%%  Digital Communications Lab - Part 3
%%
%%  Encoder : G_N = F^(xn)  polarization transform
%%  Decoder : Successive Cancellation (SC)
%%  Channel : Binary Symmetric Channel (BSC)
%%
%%  OUTPUT FIGURES:
%%    Figure 1 - Bhattacharyya parameters (bit-channel reliability)
%%    Figure 2 - BER vs BSC flip probability p
%%
%%  Run with:  polar_code
%% =====================================================
clear; clc; close all;

%% ---- Parameters ----
N          = 64;    % Code length  (power of 2)
K          = 32;    % Information bits  =>  rate r = K/N = 0.5
num_trials = 3000;  % Codewords per p value
p_range    = 0:0.02:0.5;
p_design   = 0.1;   % Frozen set designed at this p value

BER = zeros(size(p_range));

%% ---- Build frozen/info sets ----
[frozen_set, info_set] = build_frozen_set(N, K, p_design);

%% =====================================================
%%  FIGURE 1: Bhattacharyya Parameters
%% =====================================================
Z_plot = compute_bhattacharyya(N, p_design);

figure(1);
stem(1:N, Z_plot, 'filled', 'MarkerSize', 3, 'Color', [0.18 0.45 0.70]);
hold on;
xline(N-K+0.5, 'r--', 'LineWidth', 2, 'Label', 'Frozen | Info boundary');
xlabel('Bit-channel index  i');
ylabel('Bhattacharyya Parameter  Z(u_i)');
title(sprintf('Bit-channel Reliability   [N=%d,  p_{design}=%.1f]', N, p_design));
legend('Z(u_i)  — higher = less reliable', 'Frozen/Info boundary', ...
       'Location', 'northeast');
grid on;
ylim([0 1.05]);
annotation('textbox', [0.15 0.65 0.2 0.1], 'String', ...
    sprintf('Frozen\\n(N-K=%d bits)', N-K), ...
    'FitBoxToText', 'on', 'EdgeColor', 'none', 'Color', 'red');
annotation('textbox', [0.65 0.15 0.2 0.1], 'String', ...
    sprintf('Info\\n(K=%d bits)', K), ...
    'FitBoxToText', 'on', 'EdgeColor', 'none', 'Color', [0 0.5 0]);

%% =====================================================
%%  BER Simulation
%% =====================================================
fprintf('Polar Code  N=%d  K=%d  rate=%.2f\n', N, K, K/N);
fprintf('Simulating %d codewords per p value...\n\n', num_trials);

for pi = 1:length(p_range)
    p = p_range(pi);

    if p < 1e-10
        alpha = 1e6;
    elseif p > 1-1e-10
        alpha = -1e6;
    else
        alpha = log((1-p)/p);
    end

    errors = 0;
    for t = 1:num_trials
        u_info   = randi([0 1], 1, K);
        codeword = polar_encode(u_info, N, info_set);
        received = xor(codeword, rand(1,N) < p);
        llr_ch   = (1 - 2*double(received)) * alpha;
        u_hat    = sc_decode(llr_ch, N, frozen_set, info_set);
        errors   = errors + sum(u_hat ~= u_info);
    end

    BER(pi) = errors / (num_trials * K);
    fprintf('  p = %.2f   BER = %.6f\n', p, BER(pi));
end

%% =====================================================
%%  FIGURE 2: BER vs p
%% =====================================================
figure(2);
semilogy(p_range, max(BER, 1e-6),     'b-o', 'LineWidth', 2, 'MarkerSize', 5);
hold on;
semilogy(p_range, max(p_range, 1e-6), 'r--', 'LineWidth', 2);
xlabel('BSC transition probability  p');
ylabel('Bit Error Rate (BER)');
title(sprintf('Polar Code BER over BSC   [N=%d,  K=%d,  rate=%.1f]', N, K, K/N));
legend('Polar Code (SC Decoding)', 'Uncoded reference', 'Location', 'northwest');
grid on;
ylim([1e-5 1]);
xlim([0 0.5]);

fprintf('\nDone. Two figures generated.\n');

%% ============================================================
%%                        FUNCTIONS
%% ============================================================

function Z = compute_bhattacharyya(N, p)
    Z = 2 * sqrt(p * (1-p));
    for lev = 1:log2(N)
        Z_prev = Z;
        Z = zeros(1, numel(Z_prev)*2);
        for i = 1:numel(Z_prev)
            zi        = Z_prev(i);
            Z(2*i-1)  = 2*zi - zi^2;
            Z(2*i)    = zi^2;
        end
    end
end

function [frozen_set, info_set] = build_frozen_set(N, K, p)
    Z = compute_bhattacharyya(N, p);
    [~, ord]   = sort(Z, 'descend');
    frozen_set = sort(ord(1:N-K));
    info_set   = sort(ord(N-K+1:N));
end

function x = polar_encode(u_info, N, info_set)
    u = zeros(1, N);
    u(info_set) = u_info;
    x = u;
    n = log2(N);
    for s = 1:n
        half = 2^(s-1);
        for j = 1 : 2*half : N
            a = x(j        : j+half-1);
            b = x(j+half   : j+2*half-1);
            x(j : j+half-1) = mod(a + b, 2);
        end
    end
end

function info_hat = sc_decode(llr_ch, N, frozen_set, info_set)
    is_frozen = false(1, N);
    is_frozen(frozen_set) = true;
    [u_hat, ~] = sc_node(llr_ch, N, is_frozen, 1);
    info_hat   = u_hat(info_set);
end

function [u_hat, idx] = sc_node(llr, N, is_frozen, idx)
    if N == 1
        if is_frozen(idx)
            u_hat = 0;
        else
            u_hat = double(llr < 0);
        end
        idx = idx + 1;
        return
    end
    half = N / 2;
    L1   = llr(1:half);
    L2   = llr(half+1:N);
    llr_f = sign(L1) .* sign(L2) .* min(abs(L1), abs(L2));
    [v_hat,   idx] = sc_node(llr_f, half, is_frozen, idx);
    llr_g = (1 - 2*v_hat) .* L1 + L2;
    [u_lower, idx] = sc_node(llr_g, half, is_frozen, idx);
    u_hat = [mod(v_hat + u_lower, 2),  u_lower];
end