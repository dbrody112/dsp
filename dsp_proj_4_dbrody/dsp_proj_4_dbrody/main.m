clc;
close all;

%Dan Brody
%ECE-310 DSP
%Professor Keene
%Project 4 : Spectrogram Analysis and Applications

%close all for html because issue with plots not being in the right section

html = true;

%% 1.

if html == true
    close all;
end

sampling_freq = 5e6;
chirp_rate = 4e9;

%chirp sampled at 5Mhz for 200e-6 s where instantaneous freq at t=0 is 0
%and chirp rate is 4e9 where chirp rate is (f1-f0)/T
%setting T = 1 f0 = 0, t1 = 1, and f1 = 4e9 


t = 0:1/(5e6):200e-6;
generated_chirp = chirp(t,0,1,4e9);

spectrogram(generated_chirp,triang(256),255,256, sampling_freq,'yaxis')
title('Discrete Time Linear FM Chirp Signal (Chirp Rate = 4e9)')



%% 2.

if html == true
    close all;
end




phi = 2*pi*chirp_rate*t.^2;

%as for the first calculation instantaneous frequency is given as 4e9 Hz *t
%seconds

f1 = chirp_rate.*t; 

%Second is given is doc

f2 = 1./(2*pi)*diff(phi)/(t(2)-t(1));

figure;
plot(t,f1,t(1:end-1), inst_freq2);
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title('Comparison of Two Definitions of Instantaneous Frequency');
legend('f1', 'f2');

%I would assume that f2 corresponds to the slope of the ridge of the
%spectrogram because f2 looks more like the slope
%of the ridge of the spectrogram

%% 3.

if html == true
    close all;
end

figure;

chirp_rate = 1e10;

generated_chirp = chirp(t,0,1,chirp_rate);

spectrogram(generated_chirp,triang(256),255,256, sampling_freq, 'yaxis')

title('Discrete Time Linear FM Chirp Signal (Chirp Rate = 1e10)')

%increases slope by almost double when chirp rate changes to 1e11
%% 4.

if html == true
    close all;
end

fs = 8e3;

%condition of overlap satisfied for triangular when R = M and L = M+1.
%high frequency resolution = high model order M

load s1.mat
load s5.mat

%soundsc(s1,fs)
%soundsc(s5,fs)

%narrowband

%experimented to find the best values for overlap, window length, FFT
%length

figure;

spectrogram(s1, triang(600),599,600, fs, 'yaxis')

title ('narrowband s1')

figure;

spectrogram(s5, triang(1000),999,1000, fs, 'yaxis')

title ('narrowband s5')

%clear frequency resolution in both spectrograms at the case of losing
%temporal resolution

%% 5.

if html == true
    close all;
end

%wideband

%experimented to find the best values for overlap, window length, FFT
%length

figure;

spectrogram(s1, triang(50),49,50, fs, 'yaxis')

title('wideband s1')

figure;

spectrogram(s5, triang(10),9,10, fs, 'yaxis')

title('wideband s5')

%clear temporal resolution in both spectrograms at the case of losing
%frequency resolution

%% 6.

if html == true
    close all;
end


load vowels.mat

s = spectrogram(vowels,rectwin(256),128,1024, fs, 'yaxis');

%in order to make columns 1024-pt

s = [s;flipud(s)];
signal = reconstruct_signal(s);

difference = ((signal - vowels(1:size(signal,1))).^2);

figure;

plot(difference)

ylabel('squared error')
xlabel('n')
title('(estimated signal - original signal)^2')


%% 7. 

if html == true
    close all;
end


s = spectrogram(vowels,rectwin(256),128,1024, fs, 'yaxis');

%throwing out every other sample

s = s(:,(1:2:end));

%in order to make columns 1024-pt

s = [s;flipud(s)];
faster_signal = reconstruct_signal(s);

subplot(2,1,1);
plot(signal)
xlabel('n')
title('signal recovered from STFT')

subplot(2,1,2); 
plot(faster_signal)
xlabel('n')
title('faster signal recovered modified STFT with every other slice')


%soundsc(vowels, fs)
audiowrite('vowels.wav', vowels, fs)
%soundsc(signal,fs)
audiowrite('vowels_estimate.wav', signal, fs)
%soundsc(faster_signal);
audiowrite('vowels_estimate_faster.wav', faster_signal, fs)

%Same frequency retained but faster time-scale is indicated by
%vowels_estimate_faster.wav which says the vowels faster.













