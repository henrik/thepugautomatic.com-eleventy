set theTitle to "Currently playing"
set albumArt to null
set doMusic to false

tell application "iTunes"
	if player state is playing then
		set theArtist to artist of current track
		set theSong to name of current track
		set theAlbum to album of current track
		
		try
			set albumArt to data of artwork 1 of current track
		on error
			set albumArt to null
		end try
			
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
			set theDesc to "Track:\t" & theSong & "\nAlbum:\t" & theAlbum & "\nArtist:\t" & theArtist
		else
			set theDesc to "Nothing."
		end

		if albumArt is not null
			notify with  name notification  title theTitle  description theDesc  application name appName  pictImage albumArt
		else
			notify with  name notification  title theTitle  description theDesc  application name appName
		end if

	end tell
end if