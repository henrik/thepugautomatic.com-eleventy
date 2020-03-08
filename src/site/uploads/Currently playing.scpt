-- The Album art code is from http://www.macosxhints.com/article.php?story=20060406080910401

set theTitle to "Currently playing"

set tempArt to "/tmp/growlart.tiff"
set tempArtPath to POSIX file tempArt
set tempArtFile to tempArtPath as file specification

set doMusic to false
set doArt to false

tell application "iTunes"
	if player state is playing then
		set theArtist to artist of current track
		set theSong to name of current track
		set theAlbum to album of current track
		if (count of artwork of current track) > 0 then -- artwork is present
			
			do shell script "rm -rf " & tempArt
			
			set artworkData to data of artwork 1 of current track
			
			set fileRef to (open for access tempArtPath with write permission)
			try
				set eof fileRef to 512
				write artworkData to fileRef starting at 513
				close access fileRef
			on error errorMsg
				try
					close access fileRef
				end try
				error errorMsg
			end try
			
			-- Convert to tiff
			
			tell application "Finder" to set creator type of tempArtPath to "????"

			tell application "Image Events"
				set theImage to open tempArtFile
				save theImage as TIFF in tempArtFile with replacing
			end tell
			
			set doArt to true
			
		end if
			
		set doMusic to true

	end if
end tell

set appName to theTitle
set notification to theTitle
set myAllNotesList to {notification}

tell application "System Events"
	 set isRunning to (name of processes) contains "GrowlHelperApp"
end tell

if isRunning then	
	tell application "GrowlHelperApp"
		register as application appName  all notifications myAllNotesList  default notifications myAllNotesList  icon of application "iTunes"
		
		if doMusic
			set theDesc to "Track: " & theSong & "\nAlbum: " & theAlbum & "\nArtist: " & theArtist
			if doArt
				notify with  name notification  title theTitle  description theDesc  application name appName  image from location tempArt
			else
				notify with  name notification  title theTitle  description theDesc  application name appName
			end if
		else
			notify with  name notification  title theTitle  description "Nothing."  application name appName
		end if
	end tell
end if