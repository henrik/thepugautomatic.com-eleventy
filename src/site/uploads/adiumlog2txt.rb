require "CGI"

TO_FILE = "/tmp/adium.txt"
ACCOUNT = "ICQ.4618664"
CONTACT = "1234567"
output = []

Dir["#{ENV["HOME"]}/Library/Application\ Support/Adium\ 2.0/Users/Default/Logs/#{ACCOUNT}/#{CONTACT}/*"].each do |filename|
	File.open(filename).each do |line|
		output << CGI.unescapeHTML($1).gsub(%r{</?[^>]+>}, "") if line =~ %r{<div class="receive">.*?<pre class="message">(.*?)</pre></div>}
	end
end

File.open(TO_FILE, "w") do |file|
	file.puts output.join(" ")
end