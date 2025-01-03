return function(parent)
    local class = {}
    local instanceMarker = {}

    -- Inherit from parent if provided
    if parent then
        setmetatable(class, { __index = parent })
    end

    -- Metatable for instances
    local instanceMetatable = { __index = class }

    -- Placeholder constructor
    function class.constructor(instance, ...)
    end

    -- Create a new instance
    function class.new(...)
        local instance
        if parent then
            instance = setmetatable(parent.new(...), instanceMetatable)
        else
            instance = setmetatable({}, instanceMetatable)
        end
        instance[instanceMarker] = true
        instance:constructor(...)
        return instance
    end

    -- Check if an object is an instance of this class
    function class.objectIsSelf(object)
        return type(object) == "table" and object[instanceMarker] or false
    end

    -- Check if an object is an instance of a given class
    function class.isA(object, classType)
        return classType and classType.objectIsSelf(object)
    end

    return class
end