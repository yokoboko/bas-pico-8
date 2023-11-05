-- t = how far through the current movement you are
-- b = where the movement starts
-- c = the final change in value at the end.
-- d = the total duration of the movement
function easing_cubic_out(t,b,c,d)
    t /= d
    t-=1
    return c*(t*t*t + 1) + b
end 

function easing_cubic_in(t,b,c,d)
    t /= d
    return c*t*t*t + b
end

function easing_cubic_in_out(t,b,c,d)
    t /= d/2
    if (t < 1) return c/2*t*t*t + b
    t-=2
    return c/2*(t*t*t + 2) + b
end