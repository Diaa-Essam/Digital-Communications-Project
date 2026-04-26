function [signal, t] = bpsk_signal(bits, Tb, fs)

    N = length(bits);
    
    bpsk = 2 * bits - 1;
    
    t = 0:1/fs:N*Tb;
    signal = zeros(size(t));
    
    for i = 1:N
        idx = (t >= (i-1)*Tb) & (t < i*Tb);
        signal(idx) = bpsk(i);
    end
end
   