tell app "Adium"
	set theContact to {"ICQ.123456/234567", "Jabber.me@jabber.org/them@jabber.org", "MSN.me@hotmail.com/them@hotmail.com"}
	set rubyScript to "
	require \"Time\"
	log_path = \"#{ENV['HOME']}/Library/Application Support/Adium 2.0/Users/Default/Logs\";
	date = Time.now.strftime(\"%Y-%m-%d\");

	ARGV.map do |friend|  # Get today's logs for contact
		Dir[\"#{log_path}/#{friend}/*(#{date}).html\"].first 
	end.compact.each do |file|  # Scan last message from each log for URLs
		last_message = File.open(file).readlines.last
		next if last_message.match(/^<div class=\"send\"/)  # Nevermind outgoing messages
		timestamp = last_message.match(%r{<span class=\"timestamp\">(.*?)</span>})[1]
		next if (Time.now.to_i - Time.parse(timestamp).to_i) > 5  # Nevermind old messages
		urls = last_message.scan(/<a href=\"(.+?)\"/i)
		next if urls.empty?
		urls = urls.flatten.map {|url| '\"' + url.gsub('\"', '\\\"') + '\"'}  # Avoid injections
		# Detach process, or incoming message will be delayed
		`{
		osascript -e 'say \"incoming URL#{'s' if urls.size>1}\"'
		sleep 2
		open #{urls.join(' ')}
		} &>/dev/null &`
	end
"
	set AppleScript's text item delimiters to " "
	do shell script "ruby -e " & quoted form of rubyScript & " " & (theContact as text)
end