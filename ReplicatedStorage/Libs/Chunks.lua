-- Splits a string into chunks of specified size
-- @param inputString The string to be split
-- @param chunkSize The size of each chunk
return function(inputString, chunkSize)
    local chunks = {}
    
    -- Calculate number of chunks needed and split the string
    for chunkIndex = 1, math.ceil(#inputString / chunkSize) do
        -- Extract substring using the current chunk boundaries
        local startPos = (chunkIndex - 1) * chunkSize + 1
        local endPos = chunkIndex * chunkSize
        chunks[chunkIndex] = inputString:sub(startPos, endPos)
    end
    
    return chunks
end
