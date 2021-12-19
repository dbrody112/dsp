function periodogram = periodogram_averaging(signal, N)
%{
    Averages N-point periodograms over the signal where # of observed values is
    N/2
%}
num_periodograms = size(signal,2)/(N/2);

%initializing periodogram

periodogram = zeros(num_periodograms, N);
for j = 1 : num_periodograms
    
    %grabbing the next sample of length N/2
    
    signal_grabbed = signal(1 + ((j-1)*(N/2)):(N/2)+((j-1)*(N/2)));
    
    %zero padding to N
    
    added_zero = zeros(1, N/2);
    total_signal = cat(2,signal_grabbed, added_zero);
    
    % computation of periodogram (Q = N/2)
    
    fft_total_signal = fft(total_signal,64);
    periodogram(j, 1:N) = (1/(N/2))*abs(fft_total_signal).^2;
end

%averaging over all possible periodograms in signal

periodogram = (1/num_periodograms)*sum(periodogram);
end