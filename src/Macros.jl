macro user_function(body)
    quote
        Extrae.user_function(true)
        $(esc(body))
        Extrae.user_function(false)
    end
end
