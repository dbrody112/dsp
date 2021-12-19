function err = plot_against_ideal(Hejw2, estimate, title_name)
    %{

        Plots estimate of Hejw2 to Hejw2 with the plot title being
        title_name 

        output of the function being the error between
        ground truth and estimate as in (1)

    %}
    
    err = compute_error(Hejw2, estimate);
    
    figure;
    
    stem(Hejw2(1:64))
    hold on
    stem(1:64, estimate(1:64))
    legend('Ideal', 'Estimate')
    title(title_name + " (Error =  " + num2str(round(err,3)) + ")")
    
    
end