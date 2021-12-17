%%% Dan Brody
%%% DSP Project 1
%%% 10/8/2021

%L/M = 24,000/11,025 = 320/147

%% Multi-Stage

function [out,time] = srconvert_multi(in)

%{
function to convert signal "in" to a different sampling rate. In this case
the signal's sampling rate is multiplied by L/M = 320/147. This function in
particular is the multi-stage implementation

concept : idea is to use multiple lowpass filters in sequence each with cutoff frequency of 1/factorsOfL[i] 
such that 1/factorsOfL[1] * 1/factorsOfL[2] * ..... 1/factorsOfL[n] = 1/L where n is the index of the last element. 
This is the multi-stage implementation as opposed to the single-stage which
only has one lowpass filter with cutoff frequency  1/L
%}

disp ("multi-stage : ")
tic

L = 320;
M = 147;

signal = in;

%specifying factors of L for multistage

factorsOfL = [8 5 8];

%specifying passband ripple and stopband attenuation in dB as well as normalzied
%desired amplitudes

passband_ripple = 0.02;  
atten = 112;  

a = [1 0];

%converting passband ripple and stopband attenuation to linear units

pass_dev  = (10^(passband_ripple/20) - 1)/(10^(passband_ripple/20)+1);
atten_dev = 10^(-atten/20);
dev = [pass_dev atten_dev];



%multi-stage implementation

for i = 1:3
    signal = upsample(signal, factorsOfL(i));
    cutoff_freq = 1/factorsOfL(i);
    
    %finding optimal lowpass filter using firpmord
    
    [n,fo,ao,w] = firpmord([cutoff_freq,1.2*(cutoff_freq)],a,dev);
    b = firpm(n,fo,ao,w);
    signal = filter(b,1, signal);
end

%downsampling by M
  
signal = downsample(signal, M);

disp("Time : " + num2str(toc) + "seconds")

time= toc;

%displaying sound
soundsc(signal, 24000);

out = signal;

end