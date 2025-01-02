return {
	LOGGING_ENABLED = false, 
	LOGGING_FUNCTION = warn, 
	MAX_LENGTH_KEY = 49, 
	MAX_LENGTH_NAME = 50, 
	MAX_LENGTH_SCOPE = 50, 
	MAX_LENGTH_DATA = 260000, 
	MAX_PAGE_SIZE = 100, 
	YIELD_TIME_MIN = 0.2, 
	YIELD_TIME_MAX = 0.5, 
	YIELD_TIME_UPDATE_MIN = 0.2, 
	YIELD_TIME_UPDATE_MAX = 0.5, 
	WRITE_COOLDOWN = 6, 
	GET_COOLDOWN = 5, 
	THROTTLE_QUEUE_SIZE = 30, 
	SIMULATE_ERROR_RATE = 0, 
	BUDGETING_ENABLED = true, 
	BUDGET_GETASYNC = {
		START = 100, 
		RATE = 60, 
		RATE_PLR = 10, 
		MAX_FACTOR = 3
	}, 
	BUDGET_GETSORTEDASYNC = {
		START = 10, 
		RATE = 5, 
		RATE_PLR = 2, 
		MAX_FACTOR = 3
	}, 
	BUDGET_ONUPDATE = {
		START = 30, 
		RATE = 30, 
		RATE_PLR = 5, 
		MAX_FACTOR = 1
	}, 
	BUDGET_SETINCREMENTASYNC = {
		START = 100, 
		RATE = 60, 
		RATE_PLR = 10, 
		MAX_FACTOR = 3
	}, 
	BUDGET_SETINCREMENTSORTEDASYNC = {
		START = 50, 
		RATE = 30, 
		RATE_PLR = 5, 
		MAX_FACTOR = 3
	}, 
	BUDGET_BASE = 60, 
	BUDGET_ONCLOSE_BASE = 150, 
	BUDGET_UPDATE_INTERVAL = 1
};
