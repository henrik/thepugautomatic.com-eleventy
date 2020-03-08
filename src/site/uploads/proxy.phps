<?php 

$from = "malesca.tumblr.com";
$unto = "henrik.nyh.se/tumble";

// Because Dreamhost doesn't do remote fopens, and to get content-type
function fetch($url) {
	$curl = curl_init();
	$timeout = 5; // set to zero for no timeout
	curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($curl, CURLOPT_URL, $url);
	curl_setopt($curl, CURLOPT_CONNECTTIMEOUT, $timeout);
	curl_setopt($curl, CURLOPT_FOLLOWLOCATION, 1);
	$html = curl_exec($curl);
	$content_type = curl_getinfo($curl, CURLINFO_CONTENT_TYPE);
	curl_close($curl);
	return array($html, $content_type);
}

list($html, $content_type) = fetch($_GET['url']);

// Fix root-relative links etc.
$html = preg_replace('/\b(href|src|rel)="\//', '$1="http://'.$unto.'/', $html);
// Replace the old URL with the new
$html = str_replace($from, $unto, $html);

header("Content-type: $content_type");
echo $html;

?>