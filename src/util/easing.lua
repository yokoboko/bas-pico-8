-- t = how far through the current movement you are
-- b = where the movement starts
-- c = the final change in value at the end.
-- d = the total duration of the movement
function easing_cubic_out(t,b,c,d)
    t /= d
    t-=1
    return c*(t*t*t + 1) + b
end 