clc; 
clear; 
close all;

N = 20;
p = 0.2;

bits = generate_bits(N);
received = bsc_channel(bits, p);

disp('Original:');
disp(bits);
disp('Received:');
disp(received);