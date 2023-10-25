--class inheritance
function extend(class,baseclass)
    for k,v in pairs(baseclass) do
        class[k]=v
    end
end