-- Constants used for modulo wrapping to keep values within a specific range.
-- related to 64-bit integer representations or specific hashing requirements.
local MOD_OFFSET = 1099511627776 -- 2^40
local MOD_VALUE  = 2199023255552 -- 2^41

-- The base multiplier used in the polynomial hash calculation.
local HASH_BASE = 31

--[[
	Wraps a given numerical value within the range [-MOD_OFFSET, MOD_OFFSET - 1]
	using modulo arithmetic. This function is crucial for keeping intermediate
	and final hash values within a manageable, consistent range.

	The formula (value + MOD_OFFSET) % MOD_VALUE - MOD_OFFSET ensures that
	the result stays centered around zero within the 2^41 range.

	@param value (number) The number to wrap.
	@return (number) The wrapped number.
]]
local function wrapValue(value)
	-- Equivalent to: (value + 2^40) % 2^41 - 2^40
	return (value + MOD_OFFSET) % MOD_VALUE - MOD_OFFSET
end

--[[
	Calculates (base ^ (2 ^ powerOfTwoExponent)) using repeated squaring.
	It applies `wrapValue` at each step of the squaring process to ensure
	the intermediate results remain within the defined modulo range.

	This is a non-standard way to calculate powers for hashing, typically
	hash functions use base^exponent directly. The use of 2^exponent suggests
	a specific design choice for this particular hash algorithm.

	@param base (number) The base number for the exponentiation.
	@param powerOfTwoExponent (number) The exponent (which itself is a power of 2) for the base.
	@return (number) The calculated power component, wrapped using wrapValue.
]]
local function calculatePowerComponent(base, powerOfTwoExponent)
	local result = base
	-- Perform repeated squaring 'powerOfTwoExponent' times
	for _ = 1, powerOfTwoExponent do
		-- Square the current result and wrap it using the modulo arithmetic
		result = wrapValue(result * result)
	end
	return result
end

--[[
	Returns the main hashing function. This function takes an input value,
	converts it to a string, and computes a hash value based on its characters.
	It uses a variant of a polynomial rolling hash algorithm.

	The hash is calculated as:
	Sum [ charByte[i] * (HASH_BASE ^ (2 ^ (length - i + 1))) ] % MOD_VALUE
	where the wrapping is applied at each step of the summation and power calculation.

	@param input (any) The value to hash. It will be converted to a string.
	@return (number) The calculated integer hash value.
]]
return function(input)
	-- Ensure the input is treated as a string
	local inputString = tostring(input)
	local hashValue = 0
	local stringLength = #inputString

	-- Iterate through each character (byte) of the input string
	for i = 1, stringLength do
		-- Get the numerical byte value of the character at the current position 'i'
		local charByte = inputString:sub(i, i):byte()

		-- Calculate the exponent for the power component. This exponent decreases
		-- from stringLength down to 1 as we iterate through the string.
		-- The exponent itself is used as the power of 2 for the HASH_BASE.
		local exponent = stringLength - i + 1

		-- Calculate the power component: HASH_BASE ^ (2 ^ exponent)
		-- This is done using the helper function which handles repeated squaring and wrapping.
		local powerComponent = calculatePowerComponent(HASH_BASE, exponent)

		-- Update the rolling hash value:
		-- Add the product of the character's byte value and the calculated power component.
		-- Wrap the result at each step to keep it within the defined range.
		hashValue = wrapValue(hashValue + charByte * powerComponent)
	end

	-- Return the final computed hash value
	return hashValue
end
