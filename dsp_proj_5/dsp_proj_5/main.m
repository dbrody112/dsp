%% Heading

%Dan Brody
%ECE-310-Digital Signal Processing
%Professor Keene 
%12/15/2021
%Project 5

%*close all is used between sections because there were some errors in
%plots leaking into different sections. set html = false if running code.

html = true;

clc;
close all;

load pj2data.mat

%% Preliminary Plotting

%plotting y and Hejw2

Q = 32;

figure;

plot(1:512, y)
title('y[n]')
xlabel('n')

figure;

plot(1:512, Hejw2)
title('|H(e^{jw})|^2')
ylabel('magnitude')
xlabel('k')



%% A. Autocorrelation and MATLAB

%% A.1

if(html == true)
    close all;
end
figure;

y1_n = y(1:Q);


plot(xcorr(y1_n, y1_n,'biased'))
title('autocorr')

y1_negative_n = fliplr(y1_n);


figure;
plot(conv(y1_negative_n, y1_n))
title('alternative autocorr')

%both autocorrs the same


%before talking about what xcorr would calculate let us talk about 
%biased vs. unbiased estimators. As opposed to biased estimators the 
%expected value of the unbiased estimator of the estimated parameter is 
%the parameter. The biased estimator of autocorrelation (xcorr) 
%is (1/Q) * c_vv [m] where cvv[m] corresponding to the aperiodic correlation of 
%a rectangularly windowed segment of x[n] of length Q. 
%In tandem, however, the unbiased estimator is 1/(Q-|m|) * c_vv [m] 
%so this is the equation that will be calculated when we 
%replace ‘biased’ with ‘unbiased’.

%% A.2

%% (a)

%The fourier transform of the autocorrelation function is the PSD (Power
%Spectral Density) thus the output of the fourier transform must be positive and real.

%% (b)
if(html == true)
    close all;
end
figure;

%Following A.1 c_y1y1[m] = Q * xcorr(y1, y1, 'biased')

cy1_y1 = xcorr(y1_n,y1_n,'biased');
y_ = fft(cy1_y1,64);
mag = abs(y_);
phse = unwrap(angle(y_));

%plotting magnitude of c_y1y1[m]


stem(1:64,mag)
title('magnitude of 64-point DFT')
xlabel('k')
ylabel('magnitude')

figure;

%plotting phase of c_y1y1[m]

figure;
stem(1:64, phse)
title('phase of 64-point dft')
xlabel('k')
ylabel('phase')

%the relationship between c_y1y1[m] and the deterministic autocorrelation is a
%that they are the same or similar (i.e. deterministic autocorrelation = xcorr(y1,y1,'biased')).

deterministic_autocorr = zeros(1, 32);
for i = 1:32
    deterministic_autocorr(1, i) = 1/32 * sum(y1_n(i:32).*y1_n(1:32-i+1));
end

%% (c)

if(html == true)
    close all;
end

deterministic_autocorr_1 =  cy1_y1;
deterministic_autocorr_2 =  deterministic_autocorr;


%verifying signal is correct by plotting both signal's phase and magnitude
%response against each other.

y1 = fft(deterministic_autocorr_1,64);
mag1 = abs(y1);
phse1 = (angle(y1));

y2 = fft(deterministic_autocorr_2,64);
mag2 = abs(y2);
phse2 = (angle(y2));

%magnitude response subplot

subplot(2,1,1);
stem(1:64,mag1)
title('magnitude of 64-point DFT for Deterministic Autocorr from c_{y1y1}[m]')
xlabel('k')
ylabel('magnitude')


subplot(2,1,2);
stem(1:64,mag2)
title('magnitude of 64-point DFT for Deterministic Autocorr')
xlabel('k')
ylabel('magnitude')


%% A.3

%% (a)
if(html == true)
    close all;
end
figure;

stem(1:64,mag2)
title('magnitude of 64-point DFT for Deterministic Autocorr')
xlabel('k')
ylabel('magnitude')

%% (b)

if(html == true)
    close all;
end

y1_n_fft = fft(y1_n,64);
disp(size(y1_n_fft))
mag_squared_32 = abs(y1_n_fft).^2;
figure;
stem(1:64,mag_squared_32)
title('magnitude squared of 64-point DFT for y1[n]')
xlabel('k')
ylabel('magnitude^2')

%% (c)

if(html == true)
    close all;
end

y_n_fft = fft(y (1:64), 64);

mag_squared_64 = abs(y_n_fft).^2;
figure;
stem(1:64,mag_squared_64)
title('magnitude squared of 64-point DFT for y[n]')
xlabel('k')
ylabel('magnitude^2')

% relationship between (a) and (b) is a factor of 1/Q where Q here is 64.
% (i.e.) the graph of (a) = 1/Q * graph in (b) theoretically. 
%Relationship between (b) and (c) is that (b) is the FFT of y2[n] windowed 
%where y2[n] is the first 64 samples of y.

freqresp = downsample(Hejw2,8);

%% B.1

if(html == true)
    close all;
end

err = plot_against_ideal(freqresp,mag2,"Ideal PDS vs. Estimate Using DFT of \phi_{y1y1}");

%% B.2

Q = 1024;

if(html == true)
    close all;
end

%using idea demonstrated in A.3 in defining a periodogram

fft_deterministic_autocorr_all = fft(y,1024);
y_k_squared = abs(fft_deterministic_autocorr_all).^2;
autocorr_estimate = (1/Q)*y_k_squared;

err_trunc = plot_against_ideal(freqresp, downsample(autocorr_estimate,16), "Ideal PDS vs. Estimate Using DFT of \phi_{yy} w/ Downsampling to 64");

%% B.3

if(html == true)
    close all;
end

periodogram = periodogram_averaging(y, 64);

averaging_err = plot_against_ideal(freqresp, periodogram, "Ideal PDS vs. Periodogram Averaging Estimate");

%There is a notable difference between B.1 and B.2. from B.3. The error for
%B.1. and B.2. are 5.97 and 5.92 respectively whereas the error for B.3
%is 3.1403. In addition, in looking between figures we can see that periodogram
%averaging results in a smoother signal 

%% B.4

if(html == true)
    close all;
end

autocorr_estimate = xcorr(y,y,'biased');
centered_31 = autocorr_estimate((512-15):(512+15));
padded_seq = cat(2,centered_31, zeros(1, 64-31));
fft_padded_seq = abs(fft(padded_seq, 64));

indirect_blackman_tukey_err = plot_against_ideal(freqresp, fft_padded_seq, "Ideal PDS vs. Indirect Blackman-Tukey Estimate");

%% B.5

if(html == true)
    close all;
end

disp("Table of Errors for Different Estimators of PDS")

Errors = [err;err_trunc; averaging_err; indirect_blackman_tukey_err];
Estimators = [ "Estimate Using DFT of \phi_{y1y1}" ; "Estimate Using DFT of \phi_{yy} w/ Truncation at 64" ; "Periodogram Averaging Estimate" ; "Blackman-Tukey Estimate"];
table(Estimators, Errors)

%% (a)
 
%Indirect Blackman-Tukey estimate performed the best 

%% (b)

%Rather than averaging several waveforms the indirect Blackman-Tukey method is taking the autocorrelation
%estimate as the first calculation and applying a window before taking the DFT 
%which makes the wave smoothed without averaging. The effect is we are convolving
%the periodogram with the fourier transform of the autocorrelation window
%thus smoothing the rapid fluctuations of the periodogram spectrum
%estimate. Another part as to why the Indirect Blackman-Tukey method is
%doing so well is because 0<=|m|<=15
%approaches Q = 31 and as |m| approaches Q, fewer and
%fewer samples of x[n] are involved in the computation of the autocorrelation estimate;
%With less samples the variance of the autocorrelation estimate should
%decrease . Refer to eq. 10.98(b) in the textbook for a mathematical
%interpretation.

%<information can be found on pages 850 - 851 of textbook>

%% (c)

if(html == true)
    close all;
end

figure;

triangular_windowed_centered_31 = (triang(31).').*centered_31;
padded_seq = cat(2,triangular_windowed_centered_31, zeros(1, 64-31));
fft_padded_seq = abs(fft(padded_seq,64));

blackman_tukey_traingular_err = plot_against_ideal(freqresp, fft_padded_seq, "Ideal PDS vs. Indirect Blackman-Tukey Estimate (Triangular)");
disp("Indirect Blackman-Tukey Error w/ Triangular Window : " + num2str(blackman_tukey_traingular_err))

%% Comments
%The calculation is likely different due to the specifications for each
%respective window. For example the rectangular window has an approximate width of main
%lobe of 4pi/(M+1) whereas the triangular/bartlett approximate width of
%main lobe is 8pi/M, indicating that the bartlett window should have more
%width in the mainlobe. This can easily be shown if we compare the figure
%above and the figure calculated in B.5. 

%% Functions

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
    periodogram(j, 1:N) = (1/(N))*abs(fft_total_signal).^2;
end

%averaging over all possible periodograms in signal

periodogram = (1/num_periodograms)*sum(periodogram);
end


















