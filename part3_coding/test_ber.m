clc; 
clear;

N = 100;
p = 0.1;

bits = generate_bits(N);

received = bsc_channel(bits, p);

ber = compute_ber(bits, received); % BER Should be almost like p.

disp(['BER = ', num2str(ber)]);