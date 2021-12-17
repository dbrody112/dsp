%%% Dan Brody
%%% DSP Project 1
%%% 10/8/2021

close all;
clc;

%Verifying

%Single Stage 

figure;
[y,time_1] = srconvert([1 zeros(1, 3000)]);
specs = verify(y);

%Multi-Stage

figure;
[y_multi, time_2] = srconvert_multi([1 zeros(1, 3000)]);
specs_multi = verify(y_multi);

%Table of Times

implementation = ["single-stage" ; "multi-stage"];
time_spent_seconds = [time_1 ; time_2];

table(implementation, time_spent_seconds)

%Note : the table shows that multi-stage is considerably faster than
%single-stage by a factor of approximately 500. This makes sense since
%designing for filters with lower cutoff frequency is much faster.


%Audio

[signal, fs] = audioread('wagner.wav');
[audio_update,~] = srconvert_multi(signal);
audiowrite('updated_wagner.wav', audio_update, 24000)

%Note : may have to raise volume for updated_wagner.wav

