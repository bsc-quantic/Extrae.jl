macro user_function(body)
    quote
        Extrae.user_function(1)
        $body
        Extrae.user_function(0)
    end
end
