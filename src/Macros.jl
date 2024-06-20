macro user_function(name, description)
    quote
        Extrae.user_function($name, 1)
        $body
        Extrae.user_function($name, 0)
    end
end
