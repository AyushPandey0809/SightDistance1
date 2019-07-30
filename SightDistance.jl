using Polynomials, Roots, NLsolve

#Eqn of road
function y_r(x::Real; g1 = 0.1, g2 = 0.05, l = 10)
    if x<0
        y = g1*x;
    elseif x>=0 && x<l
        y = g1*x - ((g1 + g2)*x^2)/(2*l);
    else
        y = (g1 + g2)*l/2 - g2*x;
    end
    return y
end

#Graient of road
function y_r_prime(x::Real; g1 = 0.1, g2 = 0.05, l = 10)
    if x<0
        y = g1;
    elseif x>=0 && x<l
        y = g1 - ((g1 + g2)*x)/(l);
    else
        y = -g2;
    end
    return y
end

#Eqn of eyes of driver
function y_c(x::Real, hc::Real; g1 = 0.1, g2 = 0.05, l = 10)
    return y_r(x, g1 = g1, g2 = g2, l = l) + hc
end

#Finding sight distance
function sd(xc::Real, hc::Real)
    f(x)  = y_r_prime(x)*(xc - x) + y_r(x) - y_r(xc) - hc;
    xm = find_zero(f, [xc, xc + 500]);
    return xm
end

#declaring input variables
xc = -5;
hc = 1;
ho = 1;

#Point of intersection of line of sight and road
xm = sd(xc, hc);
ym = y_r(xm);

println("The line of sight hits the road at $xm, $ym")

#Eqn of line of sight
function los(x, xc, xm, hc)
    yc = y_c(xc, hc);
    ym = y_r(xm);
    m = (yc - ym)/(xc - xm);
    c = yc - m*xc;
    return m*x + c
end

#soling the eqn of line of sight for xo
function objd(xc, xm, hc, ho)
    f(x) = y_r(x) + ho - los(x, xc, xm, hc)
    xo = find_zero(f, [xm, xm+10000]);
    return xo
end

xo = objd(xc, xm, hc, ho);

println("The driver at $xc with height $hc can see an object of height $ho at $xo")
