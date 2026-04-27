clc;
clear;
close all;

N = 10;
Tb = 1;
fs = 1000;
B = 5;

bits = generate_bits(N);
[signal, t] = bpsk_signal(bits, Tb, fs);

Y = fftshift(fft(signal));          % shift here
f = linspace(-fs/2, fs/2, length(Y));

H = abs(f) <= B;

Y_filtered = Y .* H;                % no extra shift here

signal_filtered = real(ifft(ifftshift(Y_filtered)));

figure;
plot(t, signal, 'b', 'LineWidth', 1.5); hold on;
plot(t, signal_filtered, 'r', 'LineWidth', 1.5);
legend('Original', 'After Channel');
title('Effect of Band-Limited Channel');
xlabel('Time');
ylabel('Amplitude');
grid on;