-- simple wait-callback utility

timers={
    timers={}
}

-- delay the execution of a function by x seconds
function wait(callback_fn, seconds)
    add(timers.timers, {callback_fn, time()+seconds})
end

function timers._update()
    -- iterate through each timer
    for timer in all(timers.timers) do
        local callback, end_time=unpack(timer)

        -- if time is up, run callback
        if time()>=end_time then
            callback()
            del(timers.timers, timer)
        end
    end
end