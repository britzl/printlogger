require("printlogger")

print.set_log_level("CUSTOM", io.open("customlevel", "wa"))

print("This will be printed and logged using the default log level (DEBUG)")
print(print.CUSTOM, "This will end up in the custom file")
print(print.WARN, "This will end up in the warning file")
print(print.DEBUG, "This will end up in the debug file")
print.set_log_level(print.DEBUG, nil) -- disable the debug level
print(print.DEBUG, "This will NOT be logged")
