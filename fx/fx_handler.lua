fx_handler={
    active={}
}

function fx_handler.add(effect)
    add(fx_handler.active,
    effect:clone())
end

function fx_handler.remove(effect)
    del(fx_handler.active,effect)
end

function fx_handler._update()
    for a in all(fx_handler.active) do
        a:_update()
        if a.cycles_made>=a.cycles then
            fx_handler.remove(a)
        end
    end
end

function fx_handler._draw()
    for a in all(fx_handler.active) do
        a:render()
    end
end
