%w{cgi iconv rexml/document}.each { |lib| require lib }

unless ARGV[0]
    STDERR.puts %{Usage: ruby "#{$0}" "/Some/Dir/SharePod_iTunes_Import.xml"}
    exit
end

puts "Processing..."
doc = REXML::Document.new(ARGF)

# Loop over location strings, recoding them from encoded Latin-1 to encoded UTF-8
doc.elements.each('//key[.="Location"]/following-sibling::string') do |node|
    source = CGI.unescape(node.text)  # Unescape into Latin-1
    recoded_source = CGI.escape(Iconv.iconv('utf8', 'latin1', source).first)  # Convert to UTF-8 and re-escape
    node.text = recoded_source.gsub('+', '%20').gsub('%2F', '/').sub('file%3A//', 'file://')  # Fix stuff iTunes would choke on
end

output_file = ARGV[0].sub(/(\.xml)?$/i, '_fixed.xml')
File.open(output_file, 'w') { |f| f.print doc }

puts "Done."
