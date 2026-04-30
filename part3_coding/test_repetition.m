clc;
clear;

N = 10;
L = 3;
p = 0.2;

bits = generate_bits(N);
coded = repetition_encode(bits, L);
received = bsc_channel(coded, p);
decoded = repetition_decode(received, L);

disp('Original: '); disp(bits);
disp('Decoded: '); disp(decoded);

ber = compute_ber(bits, decoded);
disp(['BER = ', num2str(ber)]);
