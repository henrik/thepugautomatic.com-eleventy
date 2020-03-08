/*
author>
            Matthias Hader (R/GA)
            Nick Coronges (R/GA)
            Jeff Baxter (R/GA) - Design
</author>
<company>NIKE</company>
<copyright>(c)2006 NIKE ALL RIGHTS RESERVED</copyright>
 */

var assetsLoaded = false;

function loadAssets(){
	// force the images to load.
	//alert("buttonload");
	var img = new Image;
	img.src = 'Done_black.png';
	var img = new Image;
	img.src = 'Done_red.png';
	
	var img = new Image;
	img.src = 'Loginon.png';
	var img = new Image;
	img.src = 'Loginoff.png';
	var img = new Image;
	img.src = 'Logouton.png';
	var img = new Image;
	img.src = 'Logoutoff.png';
	
	var img = new Image;
	img.src = 'Default.png';
	var img = new Image;
	img.src = 'challengeBack.png';
	
	assetsLoaded = true;
} 