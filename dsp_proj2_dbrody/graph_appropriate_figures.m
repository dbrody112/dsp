function graph_appropriate_figures(filter, filter_name, order)

    %{

    function that takes filter, filter name, and order and plots magnitude
    response, group delay, and a pole-zero plot for a filter of filter_name
    and order

    INPUTS:

    filter : (dfilt object) filter to use for plots
    filter_name : (string) name of filter to be used in titles
    order : (int) order of filter

    %}

    %magnitude response
    
    figure;
    
    [h,w] = freqz(filter);
    plot(w/pi, 20*log10(abs(h)))
    xlabel('Normalized Frequency ( X pi rad / sample)')
    ylabel('Magnitude (dB)')
    title(filter_name + ' of order ' + num2str(order) + ' Magnitude Response')
    
    %group delay
    
    figure;
    
    [gd,w] = grpdelay(filter);
    plot(w/pi, gd)
    xlabel('Normalized Frequency ( X pi rad / sample)')
    ylabel('Group Delay')
    title(filter_name + ' of order ' + num2str(order) + ' Group Delay')
    
    %pole-zero plot
   
    figure;
    
    zplane(filter);
    title(filter_name + ' of order ' + num2str(order) +  ' Pole-Zero Plot')
    
end
