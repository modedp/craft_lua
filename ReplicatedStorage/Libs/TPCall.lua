--[[
	TPCall (Threaded Protected Call) Module

	Manages a pool of runner ModuleScripts to execute functions in a semi-isolated,
	error-catching environment. This simulates a safer execution context similar
	to pcall, but leverages separate script instances (runners).

	Usage:
	local tpcall = require(script.Parent.TPCall)
	local success, result1, result2, ... = tpcall(functionToCall, arg1, arg2, ...)
	local success, errorMessage, simplifiedTraceback = tpcall(functionThatErrors, arg1, ...)

	If the function executes successfully:
		- success = true
		- result1, result2, ... = return values of functionToCall

	If the function errors:
		- success = false
		- errorMessage = The error message captured.
		- simplifiedTraceback = A potentially simplified traceback string (may be empty).
]]

-- Services
local HttpService = game:GetService("HttpService")
local ScriptContext = game:GetService("ScriptContext")

-- Constants
local INITIAL_POOL_SIZE = 10 -- Number of runners to create initially

-- Module Variables
local coroutineToRunnerMap = {} -- Maps active runner coroutines back to their runner module instance (temporary during execution)
local availableRunners = {} -- Set-like table holding runner modules ready for use
local allRunners = {} -- Map of runnerId -> runner module instance
local runnerCounter = 0 -- Counter for generating unique runner IDs
local instanceId = HttpService:GenerateGUID():gsub("%W", "") -- Unique ID for this TPCall instance to differentiate runners in error messages
local runnerTemplate = script.Parent.runner -- The ModuleScript template for runners

-- Variables for tracking the last error caught from a runner
local lastErrorRunnerId = nil
local lastErrorMessage = nil
local lastErrorTraceback = nil -- Simplified traceback extracted from ScriptContext.Error

--[[----------------------------------------------------------------------------
	Initialization: Create the initial pool of runners
------------------------------------------------------------------------------]]
for i = 1, INITIAL_POOL_SIZE do
	runnerCounter = runnerCounter + 1
	local runnerId = "tpcall:" .. instanceId .. ":" .. runnerCounter
	
	-- Clone and setup the runner module
	local runnerInstance = runnerTemplate:Clone()
	runnerInstance.Name = runnerId
	runnerInstance.Parent = script -- Keep runners organized, prevents accidental deletion if Parent is nil initially

	-- Require the module to get its execution function and store it
	local runnerModule = require(runnerInstance)
	runnerModule.id = runnerId -- Assign the unique ID to the module table itself
	
	allRunners[runnerId] = runnerModule
	availableRunners[runnerModule] = true -- Mark as available
end

--[[----------------------------------------------------------------------------
	Global Error Handler: Catches errors specifically from our runners
------------------------------------------------------------------------------]]
ScriptContext.Error:Connect(function(errorMessage, stackTrace, scriptInstance)
	-- Attempt to identify if the error came from one of this TPCall instance's runners
	local errorSourceId = stackTrace:match("(tpcall:" .. instanceId .. ":%d+)")
	
	if errorSourceId and allRunners[errorSourceId] then
		-- Error originated from one of our runners
		lastErrorRunnerId = errorSourceId
		
		-- Attempt to extract a cleaner error message (sometimes the runner ID is prepended)
		local extractedMessage = errorMessage:match("^" .. errorSourceId .. ":%d+: (.*)$")
		if extractedMessage then
			lastErrorMessage = extractedMessage
		else
			-- Fallback: Use the raw error message, potentially cleaning up line number info if possible
			local baseMessage, lineNumber = errorMessage:match("^(.-), line (%d+) %- [^\n]*\n")
			if baseMessage and stackTrace:sub(1, #baseMessage) == baseMessage then
				-- If the stack trace starts with the base message, remove it from the error
				lastErrorMessage = errorMessage:sub(#baseMessage + #lineNumber + 4) -- Adjust index based on ", line " and number length
			else
				lastErrorMessage = errorMessage -- Use the message as-is
			end
		end

		-- Attempt to capture a simplified traceback (often just the error line context)
		-- This part is fragile and depends heavily on the stack trace format.
		lastErrorTraceback = stackTrace:match("^(.*)\n[^\n]+\n[^\n]+\n$") or "" -- May result in empty string

		-- Signal the waiting coroutine via the runner's event
		local runner = allRunners[errorSourceId]
		if runner and runner.event then
			-- Use spawn to avoid potential deadlocks if Fire triggers another error immediately
			task.spawn(function()
				runner.event:Fire()
			end)
		end
	end
end)

--[[----------------------------------------------------------------------------
	Helper Function: getOrCreateRunner

	Retrieves an available runner from the pool or creates a new one if needed.
	The 'callingCoroutine' parameter from the original was not effectively used
	for retrieval, so it's removed here for clarity. The pool is treated as FIFO.
------------------------------------------------------------------------------]]
local function getOrCreateRunner()
	-- Check for an available runner in the pool
	local availableRunner = next(availableRunners)
	if availableRunner then
		return availableRunner
	end

	-- No available runners, create a new one
	runnerCounter = runnerCounter + 1
	local runnerId = "tpcall:" .. instanceId .. ":" .. runnerCounter
	
	local runnerInstance = runnerTemplate:Clone()
	runnerInstance.Name = runnerId
	runnerInstance.Parent = script

	local runnerModule = require(runnerInstance)
	runnerModule.id = runnerId
	
	allRunners[runnerId] = runnerModule
	-- This new runner is immediately used, so it doesn't go into availableRunners yet.
	return runnerModule
end

--[[----------------------------------------------------------------------------
	Main Exported Function: Executes the target function via a runner
------------------------------------------------------------------------------]]
return function(targetFunction, ...)
	local args = { ... }
	local runner = getOrCreateRunner()
	local originalRunnerCoroutine = runner.coroutine -- Store the previous coroutine associated with the runner (if any)

	-- Mark runner as unavailable
	availableRunners[runner] = nil

	-- Create a temporary event for synchronization between this thread and the runner thread
	local syncEvent = Instance.new("BindableEvent")
	runner.event = syncEvent -- Assign to runner for error handler access

	local results = nil
	local runnerCoroutine = nil -- Will hold the coroutine running inside the runner
	local eventConnection = nil

	-- Connect to the sync event. This function will run *inside the runner's context*
	eventConnection = syncEvent.Event:Connect(function()
		if eventConnection then
			eventConnection:Disconnect() -- Prevent multiple executions
			eventConnection = nil
		end

		runnerCoroutine = coroutine.running()
		runner.coroutine = runnerCoroutine -- Associate current running coroutine with the runner
		coroutineToRunnerMap[runnerCoroutine] = runner -- Map for potential (though currently unused) reverse lookup

		-- Execute the target function safely within the runner's context
		-- Note: The actual pcall happens *inside* the runner module script usually.
		-- This module orchestrates the call and error catching *around* the runner.
		results = { runner(targetFunction, unpack(args)) } -- The runner module itself is callable

		-- Signal completion (or if an error occurred, the error handler signals)
		syncEvent:Fire()
	end)

	-- Initiate the execution in the runner's context
	syncEvent:Fire()

	-- Wait for completion *unless* an error occurred specifically in *this* runner
	-- The error handler will have already fired the event if an error happened.
	local runnerId = runner.id
	if not results and lastErrorRunnerId ~= runnerId then
		-- Yield until the runner function completes or an error is caught for this runner
		syncEvent.Event:Wait()
	end

	-- Cleanup
	if eventConnection then
		eventConnection:Disconnect() -- Ensure disconnection if error occurred before execution
	end
	syncEvent:Destroy() -- Clean up the event
	runner.event = nil -- Remove reference from runner

	if runnerCoroutine then
		coroutineToRunnerMap[runnerCoroutine] = nil -- Clear the temporary mapping
	end
	runner.coroutine = originalRunnerCoroutine -- Restore previous coroutine association (if any)

	-- Check if an error was caught for this specific runner execution
	if lastErrorRunnerId == runnerId then
		local errMessage = lastErrorMessage
		local errTrace = lastErrorTraceback
		
		-- Reset global error state *after* capturing values
		lastErrorRunnerId = nil
		lastErrorMessage = nil
		lastErrorTraceback = nil
		
		-- Make the runner available again *after* handling the error
		if not originalRunnerCoroutine then -- Only add back if it wasn't previously associated with a persistent coroutine
			availableRunners[runner] = true
		end
		
		return false, errMessage, errTrace
	else
		-- No error for this runner, return success and results
		-- Make the runner available again
		if not originalRunnerCoroutine then
			availableRunners[runner] = true
		end
		return true, unpack(results or {}) -- Unpack results, handle nil case
	end
end
