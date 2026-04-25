clc;
clear;
close all;

% Parameters
N = 10;
Tb = 1;
fs = 100;

bits = generate_bits(N);

[signal, t] = nrz_signal(bits, Tb, fs);

disp('Bits:');
disp(bits);

figure;
plot(t, signal, 'LineWidth', 2);
xlabel('Time');
ylabel('Amplitude');
title('NRZ Signal');
grid on;