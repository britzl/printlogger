--- print() replacement that will print to stdout and to file
-- @module printlogger
-- @usage
--
-- require("printlogger")
--
-- print.set_log_level("CUSTOM", io.open("customlevel", "wa"))
--
-- print(print.CUSTOM, "This will end up in the custom file")
-- print(print.WARN, "This will end up in the warning file")
-- print(print.DEBUG, "This will end up in the debug file")
-- print.set_log_level(print.DEBUG, nil) -- disable the debug level
-- print(print.DEBUG, "This will NOT be logged")
--
-- Author: Björn Ritzl
-- License: Apache License 2.0

local M = {
	print = print,
	levels = {},
	stdout_enabled = true,
}

--- Sets a log level
-- The log level will be accessible on the print table as print["name of level"]
-- @function set_log_level
-- @param level Name of the log level
-- @param file An open file to write log entries to
function M.set_log_level(level, file)
	M[level] = level
	M.levels[level] = file
end


--- Log output to stdout and file
-- If the first argument is a previously set log level the rest of the arguments will be written to the logfile
-- on a single line. The arguments will be tab delimited. tostring() will be used on each argument.
-- The arguments will also be printed to stdout if print.stdout_enabled is true (default).
-- @param arg The arguments to log
local function log(...)
	table.remove(arg, 1)

	local level = M.default
	if #arg > 1 and M.levels[arg[1]] then
		level = arg[1]
		table.remove(arg, 1)
	end

	local log_level = M.levels[level]
	if not log_level then
		return
	end

	local output = ""
	for i=1,#arg do
		output = output .. tostring(arg[i]) .. "\t"
	end

	if M.stdout_enabled then
		M.print(level, output)
	end

	log_level:write(output .. "\n")
end

M.set_log_level("DEBUG", io.open("DEBUG", "wa"))
M.set_log_level("INFO", io.open("INFO", "wa"))
M.set_log_level("WARN", io.open("WARN", "wa"))
M.set_log_level("ERROR", io.open("ERROR", "wa"))
M.set_log_level("FATAL", io.open("FATAL", "wa"))

--- Default log level. Defaults to DEBUG
-- @field #string default
M.default = M.DEBUG

setmetatable(M, { __call = log })

print = M
