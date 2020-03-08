-- iPhoto quick keyword tagging
-- by Henrik Nyh <http://henrik.nyh.se> 2006-08-14
-- Free to modify, but please credit.
--
-- KNOWN ISSUES:
-- Does not handle non-ASCII very well.

tell app "iPhoto"
	-- Fetch keywords
	set the keys to the name of every keyword whose name is not "_Favorite_"
	
	-- Prompt
	activate
	set theDialog to display dialog "Tags to apply, comma-separated:" default answer "" buttons {"Cancel", "Tag"} default button "Tag"
	set tags to text returned of theDialog
end tell

-- Add or remove tags? 

set AppleScript's text item delimiters to ""
set charsTags to the text items of tags
set removeTags to (the first item of charsTags is "-")
if removeTags then set the tags to the rest of charsTags as string

-- Match abbreviated keywords to actual keywords in Ruby

set AppleScript's text item delimiters to "\",\""
set the keys to the keys as string

set the expandedTags to do shell script "ruby -e '
tags = \"" & tags & "\".split(/\\s*,\\s*/)
normalized = {}
[\"" & keys & "\"].each {|kw| normalized[kw.downcase] = kw}

tag_with = tags.map do |tag|
	normalized[
		normalized.keys.sort.find {|kw| kw.index(tag)==0} ||  # prefix match
		normalized.keys.sort.find {|kw| kw.gsub(/(\\w)\\w*\\s*/, %q{\\1}) == tag}  # initials match
	]
end.compact.uniq.join(%{,})
puts tag_with
'"

-- Split keywords
set AppleScript's text item delimiters to ","
set expandedTags to the text items of expandedTags

-- Apply or remove keywords
repeat with tag in expandedTags
	if removeTags -- remove keywords
		tell app "iPhoto"
				repeat with pic in (selection as list)
					remove keyword tag from pic
				end repeat
		end tell
		-- iPhoto seems to need this to refresh the display
		tell app "SystemUIServer" to activate
		tell app "iPhoto" to activate
	else -- apply keywords
		tell app "iPhoto" to assign keyword string tag
	end if 
end repeat