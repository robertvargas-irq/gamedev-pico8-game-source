-- list object
-- 
-- attribution:
-- lua official documentation
-- https://www.lua.org/pil/11.4.html
list={}

function list.new ()
    return {first=0, last=-1}
end

function list.pushleft (list, value)
    local first=list.first-1
    list.first=first
    list[first]=value
end

function list.popright (list)
    local last=list.last
    if list.first > last then return nil end
    local value=list[last]
    list[last]=nil         -- to allow garbage collection
    list.last=last-1
    return value
end

function list.empty (list)
    return list.last > list.first
end