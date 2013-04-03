Add this Apple script to alfred and try to tranlsate something

on alfred_script(q)
	tell application "fast translator"
		activate
		do direct parameter command q
	end tell
end alfred_script