set working_directory to POSIX file ((POSIX path of (path to me)) & "/..") as text
set desired_callers_file to (working_directory & "desired_callers.txt")
set desired_callers to {}

set autoVideo to false # start video-call automatically
set scanDelay to 5 # seconds

set callers to paragraphs of (read file desired_callers_file)
repeat with nextLine in callers
	if length of nextLine is greater than 0 then
		set encoded to nextLine as Unicode text
		
		copy encoded to the end of desired_callers
	end if
end repeat

# State handling
repeat
	if not ApplicationIsRunning("Skype") then
		set clickedButton to button returned of (display dialog "Skype is not running right now.. do you want to start Skype now?" buttons {"Stop AutoSkype", "Start Skype"} default button "Start Skype")
		
		if clickedButton is "Start Skype" then
			tell application "Skype" to activate
		else
			error number -128
		end if
	else
		tell application "Skype"
			set calls to send command "SEARCH ACTIVECALLS" script name "AutoSkype"
			set callID to last word of calls
			if callID is not "CALLS" then
				set status to send command "GET CALL " & callID & " STATUS" script name "AutoSkype"
				set caller to send command "GET CALL " & callID & " PARTNER_HANDLE" script name "AutoSkype"
				if last word of status is "RINGING" and desired_callers contains last word of caller then
					log "desired caller!!"
					send command "ALTER CALL " & callID & " ANSWER" script name "AutoSkype"
				else if autoVideo then
					send command "ALTER CALL " & callID & " START_VIDEO_SEND" script name "AutoSkype"
				end if
			end if
		end tell
	end if
	
	delay scanDelay
end repeat

# found at Vincent Gable’s Blog
# http://vgable.com/blog/2009/04/24/how-to-check-if-an-application-is-running-with-applescript/
on ApplicationIsRunning(appName)
	tell application "System Events" to set appNameIsRunning to exists (processes where name is appName)
	return appNameIsRunning
end ApplicationIsRunning