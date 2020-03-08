<?php

function lastfm_sidebar_module($args) {
	global $scrobbler_user;
	extract($args);

	if ( function_exists('get_scrobbler') ) {
		echo $before_module . $before_title . $title . $after_title;
?>
		<span class="metalink"><a href="http://www.last.fm/user/<?php echo $scrobbler_user; ?>" class="feedlink" title="My Last.fm profile"><img src="http://static.last.fm/matt/favicon.ico" alt="Last.fm" /></a></span>
		
		<?php
		get_scrobbler();
		echo $after_module;
	}
}

register_sidebar_module('Last.fm module', 'lastfm_sidebar_module', 'sb-lastfm');

?>
