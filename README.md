fast-translator
===============

fast translator is licensed under [the MIT License (MIT)](http://opensource.org/licenses/MIT).

fast translator will work with Yandex.Translator API
![Fast translator](https://github.com/buddax2/fast-translator/blob/master/screenshots/appScreen.png?raw=true)

# AppleScript support

You can call 'translate "some text"' from your AppleScript
The app will activate and show you translation of "some text"

Now it translates from English to Russian but I will add auto-detection of a source text later.

# Alfred integration
![Alfred support](https://github.com/buddax2/fast-translator/blob/master/screenshots/Alfred.png?raw=true)

I added two extensions for Alfred. So you can just install them or create yourself.

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
