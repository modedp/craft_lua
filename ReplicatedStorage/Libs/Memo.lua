--[[
	Compares two tables (intended for argument lists) for deep equality.
	Returns true if they contain the same values in the same order, false otherwise.
	@param listA {table} - The first list (table) to compare.
	@param listB {table} - The second list (table) to compare.
	@return {boolean} - True if the lists are equal, false otherwise.
]]
local function areListsEqual(listA, listB)
	-- Check for identity (same table instance)
	if listA == listB then
		return true
	end

	-- Check if lengths are different
	if #listA ~= #listB then
		return false
	end

	-- Check element-wise equality
	-- Assumes lists are numerically indexed from 1 to #list
	for i = 1, #listA do
		if listA[i] ~= listB[i] then
			return false
		end
	end

	-- If all checks pass, the lists are considered equal
	return true
end

--[[
	Creates a memoized version of the input function.
	The memoized function caches results based on arguments. If called again
	with the same arguments, it returns the cached result instead of recomputing.
	@param funcToMemoize {function} - The function to memoize.
	@return {function} - The memoized version of the function.
]]
return function(funcToMemoize)
	-- Cache storage: Array of tables, each { args = {arg1, ...}, result = funcResult }
	local cache = {}

	--[[
		Adds a new argument-result pair to the cache.
		@param args {table} - The list of arguments used.
		@param result - The result returned by the function for these arguments.
	]]
	local function addToCache(args, result)
		cache[#cache + 1] = {
			args = args,
			result = result
		}
	end

	--[[
		Retrieves a cached result for the given arguments or computes, caches,
		and returns a new result if no matching entry is found.
		@param argsList {table} - The list of arguments passed to the memoized function.
		@return - The cached or newly computed result.
	]]
	local function getCachedOrCompute(argsList)
		-- Search the cache for an entry with matching arguments
		for _, cacheEntry in ipairs(cache) do -- Use ipairs for sequential array iteration
			if areListsEqual(argsList, cacheEntry.args) then
				-- Found a match, return the cached result
				return cacheEntry.result
			end
		end

		-- No match found in cache:
		-- 1. Call the original function with the arguments
		-- Use table.unpack (or unpack in older Lua versions) for clarity
		local result = funcToMemoize(table.unpack(argsList))

		-- 2. Add the new arguments and result to the cache
		addToCache(argsList, result)

		-- 3. Return the newly computed result
		return result
	end

	-- Return the memoized function wrapper
	-- This function captures variable arguments (...)
	return function(...)
		-- Pack arguments into a table and pass to the core logic
		return getCachedOrCompute({ ... })
	end
end
