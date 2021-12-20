function signal = reconstruct_signal(modified_stft)

signal = zeros(256+128*(size(modified_stft,2)-1), 1);

for j = 1 : size(modified_stft,2)
    modified_stft_col = modified_stft(:,j);
    ifft_modified_stft_col = real(ifft(modified_stft_col));
    
    signal_entry = ifft_modified_stft_col(1:256);
    for k = 1+128*(j-1):256+128*(j-1)
        if signal(k) ~= 0
            signal(k) = mean([signal(k); signal_entry(k - 128*(j-1))]);
        else
             signal(k) = signal_entry(k - 128*(j-1));         
        end
    end

 end
end



