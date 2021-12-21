clc;
close all;
clear variables;

%Dan Brody
%ECE 310- DSP
%Professor Keene
%11/2/2021
%Project 3 : Filter Design

load projIB

%issues with plots in wring sections so need a condition when publishing

html = true;


%% (a)

if(html == true)
    close all;
end

% specifications
Gsb_max = -55; 
Gpb_max = 40;
Gpb_min = 37;

Rp = Gpb_max-Gpb_min; % passband gain
Rs = Gpb_max-Gsb_max; % stopband attenuation


Wp = 2500/(fs/2); 
Ws = 4000/(fs/2);

filters = ["Butterworth", "Chebyshev Type 1", "Chebyshev Type 2", "Elliptic", "Parks-Mclellan", "Kaiser"];

%initializing array where I will take filter orders for each respective
%filter and put in table (Part (a))

filter_orders = zeros(1,size(filters,2));

%initializing array where I will take number of multiplications for each respective
%filter and put in table (Part (b))

filter_multiplications = zeros(1,size(filters,2));


%% Butterworth IIR

if(html == true)
    close all;
end


%finding order

[n_buttord,Wn_buttord] = buttord(Wp,Ws,Rp,Rs);
[z_buttord,p_buttord,k_buttord] = butter(n_buttord, Wn_buttord);

%finding transfer function and sos

[b_buttord, a_buttord] = zp2tf(z_buttord,p_buttord,k_buttord);
sos = zp2sos(z_buttord,p_buttord,k_buttord);

%populating filter order and multiplication array

filter_orders(1) = n_buttord;
filter_multiplications(1) = length(a_buttord) + length(b_buttord);

%graphing (c) - (e)

graph_appropriate_graphs(dfilt.df1sos(sos), fs, noisy, "Butterworth", false);

%sound is clear but sound of a mic in the beginning


%% Chebyshev Type 1

if(html == true)
    close all;
end

%finding order

[n_chebyshev_1,Wp_chebyshev_1] = cheb1ord(Wp,Ws,Rp,Rs);
[z_chebyshev_1,p_chebyshev_1, k_chebyshev_1] = cheby1(n_chebyshev_1, Rp, Wp_chebyshev_1);

%finding transfer function and sos

[b_chebyshev_1,a_chebyshev_1] = zp2tf(z_chebyshev_1,p_chebyshev_1,k_chebyshev_1);
sos = zp2sos(z_chebyshev_1,p_chebyshev_1,k_chebyshev_1);

%populating filter order and multiplication array

filter_orders(2) = n_buttord;
filter_multiplications(2) = length(a_chebyshev_1) + length(b_chebyshev_1);

%graphing (c) - (e)

graph_appropriate_graphs(dfilt.df1sos(sos), fs, noisy, "Chebyshev Type 1", false);

%sound is clear but sound of a mic in the beginning

%% Chebyshev Type 2

if(html == true)
    close all;
end

%finding order

[n_chebyshev_2,Ws_chebyshev_2] = cheb2ord(Wp,Ws,Rp,Rs);
[z_chebyshev_2,p_chebyshev_2, k_chebyshev_2] = cheby2(n_chebyshev_2, Rs, Ws_chebyshev_2);

%finding transfer function and sos

[b_chebyshev_2,a_chebyshev_2] = zp2tf(z_chebyshev_2,p_chebyshev_2,k_chebyshev_2);
sos = zp2sos(z_chebyshev_2,p_chebyshev_2,k_chebyshev_2);

%populating filter order and multiplication array

filter_orders(3) = n_chebyshev_2;
filter_multiplications(3) = length(a_chebyshev_2) + length(b_chebyshev_2);

%graphing (c) - (e)

graph_appropriate_graphs(dfilt.df1sos(sos), fs, noisy, "Chebyshev Type 2", false);

%sound in the beginning like a mic but other than that sound is clear

%% Elliptic

if(html == true)
    close all;
end

%finding order

[n_elliptic,Wp_elliptic] = ellipord(Wp,Ws,Rp,Rs);
[z_elliptic,p_elliptic,k_elliptic] = ellip(n_elliptic,Rp,Rs,Wp_elliptic); 

%finding transfer function and sos

[b_elliptic,a_elliptic] = zp2tf(z_elliptic,p_elliptic,k_elliptic);
sos = zp2sos(z_elliptic,p_elliptic,k_elliptic);

%populating filter order and multiplication array

filter_orders(4) = n_elliptic;
filter_multiplications(4) = length(a_elliptic) + length(b_elliptic);

%graphing (c) - (e)

graph_appropriate_graphs(dfilt.df1sos(sos), fs, noisy, "Elliptic", false);

%sound is clear and less noise than other signals


%% Parks-Mclellan

if(html == true)
    close all;
end

ParksMcClellan = designfilt('lowpassfir','PassbandFrequency',2500,'StopbandFrequency',4000,'PassbandRipple',Rp,'StopbandAttenuation',Rs,'SampleRate',fs,'DesignMethod','equiripple');        
[filter_order, multiplications] = compute_order_mult(ParksMcClellan);

%populating filter order and multiplication array

filter_orders(5)= filter_order;
filter_multiplications(5) = multiplications;

%graphing (c) - (e)

graph_appropriate_graphs(ParksMcClellan , fs, noisy, "Parks-Mclellan", false);

%clear but there is some noise in the beginning like a mic

%% Kaiser

if(html == true)
    close all;
end

Kaiser = designfilt('lowpassfir','PassbandFrequency',2500,'StopbandFrequency',4000,'PassbandRipple',Rp,'StopbandAttenuation',Rs,'SampleRate',fs,'DesignMethod','kaiserwin');
[filter_order, multiplications] = compute_order_mult(Kaiser);

%populating filter order and multiplication array

filter_orders(6)= filter_order;
filter_multiplications(6) = multiplications;

%graphing (c) - (e)

graph_appropriate_graphs(Kaiser, fs, noisy, "Kaiser", false);

%sound is clear

%% Table of Filter Orders and Filter Multiplications

if(html == true)
    close all;
end

T = table(filters.', filter_orders.');
T.Properties.VariableNames = {'Filter','Filter Order'};
T

T2 = table(filters.', filter_multiplications.');
T2.Properties.VariableNames = {'Filter','Filter Multiplications'};
T2

%% Noisy vs. Filtered Sound

if(html == true)
    close all;
end

soundsc(noisy, fs)
audiowrite('noisy.wav', noisy, fs);

%The noisy sound is very high-pitched and sounds almost like hissing
%whereas filtering the signal much of the high frequencies were filtered
%out (i.e. since we are using lowpass filters). The filtered sound said
%"That noise problem becomes more annoying each day". A few filters
%performed better than others for this audio. Particularly both the kaiser and
%elliptic filter did particularly well whereas more noise was heard in other
%filters.

%% Functions


function [filter_order, multiplications] = compute_order_mult(filter_input)
    %{
    computing filter order and multiplications using a designfilt object 
%}
    
    %compute filter order
    
    filter_order = filtord(filter_input);
    
    % compute filter multiplications
    
    [b,a] = tf(filter_input);
    multiplications = length(b) + length(a);
end

function graph_appropriate_graphs(filter_input, fs, noisy, filter_name, play_sound)
    %{
        graphing (c) - (e) for filter_name where filter_input is some
        filter object, fs is the sampling frequency, noisy is the noisy
        signal, and play_sound is a boolean that allows the user to
        specify whether or not to play the filtered sound.
%}
    [h,w] = freqz(filter_input, fs);
    mag_db = 20*log10(abs(h));
    
    %plotting magnitude response as in (c)
    
    figure;
    subplot(3,1,1);
    plot(w, mag_db);
    title (filter_name + ' Filter Magnitude Response');
    xlabel('Radian Frequency (w)');
    ylabel('Magnitude(dB)');
    
    %plotting magnitude response w/ passband ripple detail as in (c)
    
    subplot(3,1,2);
    plot(w,abs(h));
    xlim([0.3, 0.5]);
    title (filter_name + ' Filter Passband Ripple Detail');
    xlabel('Rdaian Frequency (w)');  
    ylabel('Magnitude (Linear Scale)');
    
    %plotting group delay as in (c)
    
    subplot(3,1,3);
    [gd,w] = grpdelay(filter_input, fs);
    plot(w,gd);
    title (filter_name + ' Filter Group Delay');
    xlabel ('Radian Frequency (w)');
    ylabel ('Group Delay');
    
    %plotting pole-zero diagram as in (d)
    
    figure;
    [z, p, k] = zplane(filter_input); 
    zplane(z,p);
    title(filter_name + ' Filter Pole-Zero Plot');
    
    %plotting impulse response as in (e)
    
    figure;
    [impResp,t] = impz(filter_input, 100); 
    stem(t,impResp);
    title(filter_name + ' Filter Impulse Response');
    xlabel('Samples');
    ylabel('Magnitude');
    
    filtered = filter(filter_input, noisy);
    if play_sound
        soundsc(filtered, fs)
    end
    audiowrite(filter_name+'.wav', filtered, fs);
end




