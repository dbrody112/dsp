function signal = reconstruct_signal(modified_stft)

%{

    reconstructs signal from STFT or modified STFT

%}

%initialize signal

signal = zeros(256+128*(size(modified_stft,2)-1), 1);

for j = 1 : size(modified_stft,2)
    
    %grab first column
    
    modified_stft_col = modified_stft(:,j);
    
    %take ifft
    
    ifft_modified_stft_col = real(ifft(modified_stft_col));
    
    %grab first 256 entries. The fisrt 256 entries of the first columns on
    %the STFT correspond to samples 1:256 and the next 1+128:256+128 as
    %there is an overlap of 128.
    
    signal_entry = ifft_modified_stft_col(1:256);
    
    for k = 1+128*(j-1):256+128*(j-1)
        
        %allowing for averaging of overlap
        
        if signal(k) ~= 0
            signal(k) = mean([signal(k); signal_entry(k - 128*(j-1))]);
        
        %creating signal
        
        else
             signal(k) = signal_entry(k - 128*(j-1));         
        end
    end

 end
end



