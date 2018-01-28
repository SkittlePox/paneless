on run argv
	--return "ssf"
	delay 1
	
	script pull
		tell application "System Events"
			set this_info to {}
			set app_info to {}
			repeat with theProcess in (application processes where visible is true)
				try
					set result to (value of (first attribute whose name is "AXWindows") of theProcess)
					if length of result is not equal to 0 then
						set this_info to this_info & result
						set end of app_info to name of theProcess
					end if
					--log (count of attributes of theProcess)
					--log class of theProcess
				on error errMsg number errorNumber
					--log theProcess
				end try
			end repeat
			
			set dows to {}
			repeat with wdow in this_info
				set dows to dows & (position of wdow & size of wdow)
			end repeat
		end tell
		
		set {TID, text item delimiters} to {text item delimiters, ","}
		set {picString, text item delimiters} to {dows as text, TID}
		
		set {BID, text item delimiters} to {text item delimiters, ","}
		set {appString, text item delimiters} to {app_info as text, BID}
		
		set UnixPath to POSIX path of ((path to me as text) & "::")
		do shell script "/usr/local/bin/python3 " & UnixPath & "drawRects.py -c " & picString & " -f " & UnixPath & (item 2 of argv) with administrator privileges
		
		return ((length of app_info) as text) & "," & appString & "," & picString
	end script
	
	script push
		try
			tell application (item 2 of argv)
				activate
				set bounds of window 1 to {(item 3 of argv), (item 4 of argv), (item 5 of argv), (item 6 of argv)}
			end tell
		on error errMsg number errorNumber
			return
		end try
	end script
	
	if (count of argv) = 0 then
		--run pull
		return "No arguments passed"
	else
		if item 1 of argv is "pull" then
			run pull
		else if item 1 of argv is "push" then
			run push
		else
			return "No valid arguments passed"
		end if
	end if
	
end run
