clc;
clear;
close all;

N = 20;

bits = generate_bits(N);

disp('Generated Bits: ');
disp(bits);

t = 0:N-1;

figure;
stairs(t, bits, 'LineWidth', 2);
ylim([-0.5, 1.5]);
xlabel('Bit Index');
ylabel('Bit Value');
title('Random Bit Sequence');
grid on;