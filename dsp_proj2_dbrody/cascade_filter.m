function filter_order_N = cascade_filter(filter, N)
    %{
        cascades filter to order N
    %}

    filter_order_N = dfilt.cascade(filter);
    for j = 1:N-1
        addstage(filter_order_N, filter)
    end
end
