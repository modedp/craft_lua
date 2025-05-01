--[[
	Module for data compression techniques.
	Includes Run-Length Encoding (RLE) and a custom 3D byte array encoding.
]]
local Compress = {
	rle = {},
	byte3d = {}
}

-- Roblox-specific yielding function to prevent script timeouts
local lastTick = tick(); --[[TickWait]]
local Heartbeat = game:GetService("RunService").Heartbeat;
local yieldTask = function()
	if tick() - lastTick > 0.05 then
		Heartbeat:Wait();
		lastTick = tick();
	end;
end; -- TWait is a task.wait() wrapper or similar

-- Maximum run length representable by a single byte (excluding the special marker)
local MAX_RUN_LENGTH_BYTE = 126
-- Special character used to indicate run lengths greater than MAX_RUN_LENGTH_BYTE
local LONG_RUN_MARKER = string.char(127) -- ASCII 127

--[[
	Encodes a string using a custom Run-Length Encoding (RLE) algorithm.
	Format: [Count][Character]
	- Count is represented by one or more bytes.
	- If Count <= 126, it's represented by string.char(Count).
	- If Count > 126, it's represented by one or more LONG_RUN_MARKER bytes
	  followed by the remaining count byte. Each LONG_RUN_MARKER represents 126.
	  Example: A run of 300 'A's -> "\127\127\048A" (126 + 126 + 48 = 300)

	@param inputStr The string to encode.
	@return The RLE encoded string.
]]
function Compress.rle.encode(inputStr)
	if not inputStr or #inputStr == 0 then
		return ""
	end

	local encoded = {} -- Use a table for efficient concatenation
	local currentChar = inputStr:sub(1, 1)
	local runLength = 1

	-- Helper function to append the current run to the encoded table
	local function appendRun()
		local countStr = ""
		local remainingLength = runLength
		-- Handle runs longer than MAX_RUN_LENGTH_BYTE
		while remainingLength > MAX_RUN_LENGTH_BYTE do
			countStr = countStr .. LONG_RUN_MARKER
			remainingLength = remainingLength - MAX_RUN_LENGTH_BYTE
		end
		-- Append the final count byte (even if it's 0 after subtracting multiples of 126)
		-- and the character itself.
		table.insert(encoded, countStr .. string.char(remainingLength) .. currentChar)
	end

	for i = 2, #inputStr do
		local char = inputStr:sub(i, i)
		if char == currentChar then
			runLength = runLength + 1
		else
			-- Character changed, append the previous run
			appendRun()
			-- Start a new run
			currentChar = char
			runLength = 1
		end

		-- Yield periodically to prevent timeouts
		if i % 500 == 0 then -- Increased frequency for potentially long strings
			yieldTask()
		end
	end

	-- Append the final run
	appendRun()

	return table.concat(encoded)
end

--[[
	Decodes a string encoded with the custom RLE algorithm.

	@param encodedStr The RLE encoded string.
	@return The original decoded string.
]]
function Compress.rle.decode(encodedStr)
	if not encodedStr or #encodedStr == 0 then
		return ""
	end

	local decoded = {} -- Use a table for efficient concatenation
	local i = 1
	local len = #encodedStr

	while i <= len do
		local runLength = 0
		local byteVal = string.byte(encodedStr, i)

		-- Read count byte(s)
		while byteVal == 127 do -- Check if it's the LONG_RUN_MARKER
			runLength = runLength + MAX_RUN_LENGTH_BYTE
			i = i + 1
			if i > len then
				warn("RLE Decode Error: Unexpected end of string after long run marker.")
				return table.concat(decoded) -- Return what we have so far
			end
			byteVal = string.byte(encodedStr, i)
		end

		-- Add the final count byte value
		runLength = runLength + byteVal
		i = i + 1

		-- Read the character
		if i > len then
			warn("RLE Decode Error: Unexpected end of string, missing character after count.")
			return table.concat(decoded) -- Return what we have so far
		end
		local char = encodedStr:sub(i, i)
		i = i + 1

		-- Append the character `runLength` times
		table.insert(decoded, string.rep(char, runLength))

		-- Yield periodically
		if i % 500 == 0 then -- Match encode yield frequency
			yieldTask()
		end
	end

	return table.concat(decoded)
end


--[[
	Encodes a 3D table of bytes (0-127) into a single string.
	The 3D table is flattened row by row, layer by layer (Z -> Y -> X).

	@param data3D The 3D table (e.g., data3D[x][y][z]) containing byte values (0-127).
	@param sizeX The size of the first dimension.
	@param sizeY The size of the second dimension.
	@param sizeZ The size of the third dimension.
	@return A string representing the flattened 3D byte data.
]]
function Compress.byte3d.encode(data3D, sizeX, sizeY, sizeZ)
	local encoded = {} -- Use a table for efficiency
	local expectedTotal = sizeX * sizeY * sizeZ
	local count = 0

	for x = 1, sizeX do
		if not data3D[x] then error("Encoding Error: Missing X index: " .. x) end
		for y = 1, sizeY do
			if not data3D[x][y] then error("Encoding Error: Missing Y index at X=" .. x .. ", Y=" .. y) end
			for z = 1, sizeZ do
				local byteValue = data3D[x][y][z]
				if not byteValue then error("Encoding Error: Missing Z index at X="..x..", Y="..y..", Z="..z) end

				-- Validate byte range
				if byteValue < 0 or byteValue > 127 then
					error(("Encoding Error: Value '%s' at [%d][%d][%d] is out of bounds (0-127)"):format(tostring(byteValue), x, y, z))
				end
				table.insert(encoded, string.char(byteValue))
				count = count + 1
			end
		end
		-- Yield once per X slice to balance performance and responsiveness
		yieldTask()
	end

	if count ~= expectedTotal then
		warn(("Encoding Warning: Expected %d bytes, but processed %d. Input data might be inconsistent."):format(expectedTotal, count))
	end

	return table.concat(encoded)
end

--[[
	Decodes a string back into a 3D table of bytes.
	Assumes the string was encoded using Compress.byte3d.encode.

	@param encodedStr The string containing the flattened byte data.
	@param sizeX The size of the first dimension for the resulting table.
	@param sizeY The size of the second dimension.
	@param sizeZ The size of the third dimension.
	@return The reconstructed 3D table (data[x][y][z]).
]]
function Compress.byte3d.decode(encodedStr, sizeX, sizeY, sizeZ)
	local expectedLength = sizeX * sizeY * sizeZ
	if #encodedStr ~= expectedLength then
		error(("Decoding Error: Input string length (%d) does not match expected size (%d * %d * %d = %d)."):format(#encodedStr, sizeX, sizeY, sizeZ, expectedLength))
	end

	local data3D = {}
	local index = 1 -- Current position in the encoded string (1-based)

	for x = 1, sizeX do
		local yTable = {}
		for y = 1, sizeY do
			local zTable = {}
			for z = 1, sizeZ do
				-- Calculate the correct linear index (already tracked by `index`)
				-- local linearIndex = (x - 1) * sizeY * sizeZ + (y - 1) * sizeZ + z -- Formula for reference
				zTable[z] = string.byte(encodedStr, index)
				index = index + 1
			end
			yTable[y] = zTable
		end
		data3D[x] = yTable
		-- Yield once per X slice
		yieldTask()
	end

	return data3D -- Return the reconstructed table
end


return Compress
