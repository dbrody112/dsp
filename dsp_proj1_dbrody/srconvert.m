

function [out,time] = srconvert(in)

%{
function to convert signal "in" to a different sampling rate. In this case
the signal's sampling rate is multiplied by L/M = 320/147. This function in
particular is the single-stage implementation

%}

disp("single-stage : ")

tic

signal = in;
signal = upsample(signal, 320);

%specifying passband ripple and stopband attenuation in dB as well as normalzied
%cutoff frequencies and desired amplitudes

passband_ripple = 0.02;  
atten = 112;  

f = [(1/320) 1.2*(1/320)];    % Cutoff frequencies
a = [1 0];        % Desired amplitudes

%converting passband ripple and stopband attenuation to linear units

pass_dev  = (10^(passband_ripple/20) - 1)/(10^(passband_ripple/20)+1);
atten_dev = 10^(-atten/20);

dev  = [pass_dev atten_dev];

%finding optimal lowpass filter using firpmord

[n,fo,ao,w] = firpmord(f,a,dev);

b = firpm(n,fo,ao,w);

%filtering signal with lowpass filter found

signal = filter(b,1, signal);

%downsampling

signal = downsample(signal, 147);

disp("Time : " + num2str(toc) + "seconds")

time = toc;

%displaying sound

soundsc(signal, 24000);
out = signal;

toc
end