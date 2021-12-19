function err = compute_error(Hejw2, estimate)
%{
    computes error as described in (1)
%}
    err = 1/64 * sum( (Hejw2(1:64) - estimate(1:64)).^2);
end