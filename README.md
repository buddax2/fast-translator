fast-translator
===============

fast translator will work with Yandex.Translator API

# Alfred integration

create a new AppleScript in Alfred preferences and add this:

<pre>
  <code class="applescript">
on alfred_script(q)
  tell application "fast translator"
		activate
		do direct parameter command q
	end tell
end alfred_script
  </code>
</pre>
