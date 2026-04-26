clc;
clear;
close all;

N = 10;
Tb = 1;
fs = 100;

bits = generate_bits(N);

[signal, t] = bpsk_signal(bits, Tb, fs);

disp('Bits:');
disp(bits);

disp('Mapped BPSK');
disp(2*bits - 1);

figure;
plot(t, signal, 'LineWidth', 2);
xlabel('Time');
ylabel('Amplitude');
title('BPSK Signal');
grid on;