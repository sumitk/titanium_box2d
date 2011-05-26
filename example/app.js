// This is a test harness for your module
// You should do something interesting in this harness 
// to test out the module and to provide instructions 
// to users on how to use it by example.


// open a single window
var window = Ti.UI.createWindow({
	backgroundColor:'white'
});
var label = Ti.UI.createLabel();
window.add(label);
window.open();

// TODO: write your module tests here
var box2d = require('ti.box2d');
Ti.API.info("module is => " + box2d);

label.text = box2d.example();

Ti.API.info("module exampleProp is => " + box2d.exampleProp);
box2d.exampleProp = "This is a test value";

if (Ti.Platform.name == "android") {
	var proxy = box2d.createExample({message: "Creating an example Proxy"});
	proxy.printMessage("Hello world!");
}