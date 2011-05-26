Titanium Box2D Module for iOS 
=============================

This is a Box2D module for iOS developed by Jeff Haynie.

Basic usage:

~~~
var window = Ti.UI.createWindow();
var view = Ti.UI.createView();
window.add(view);
window.open();


// load the module
var box2d = require("ti.box2d");

// create the world, using view as the surface
var world = box2d.createWorld(view);

// create a block 
var redBlock = Ti.UI.createView({
	backgroundColor:"red",
	width:50,
	height:50,
	top:0
});

// add the block body to the world
var redBody = world.addBody(redBlock,{
	density:12.0, 
	friction:0.3, 
	restitution:0.4,
	type:"dynamic"	
});

redBlock.addEventListener("collision",function(e) {
	if ((e.a == redBody || e.b == redBody) && e.phase == "begin") {
		Ti.API.info("the redBody collided with something");
	}
});

// start the world
world.start();
~~~



TODO
===

There's a lot that's not currently supported and needs to be implemented.
Right now, I basically only support adding either a rectangle or cirlce body
to the world and the various body properties. No complex polygons.  I don't
yet support applying force or other more sophisticated physics capabilities.



