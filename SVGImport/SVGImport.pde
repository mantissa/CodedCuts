
// import the library
import processing.svg.*;

// define our shape
PShape svgShape;

void setup() {
  
  size(800, 800);
  
  // load the shape into 
  svgShape = loadShape("Trash.svg");
  
  // if we want to set change how the SVG 
  // files are drawn
  //svgShape.disableStyle();
}

void draw() {

  // clear the bg (yellow)
  background(255, 255, 0);
  
  // draw white without stroke 
  // ignored by default (see disableStyle() above)
  fill(255);
  noStroke();
  
  // center the shape when drawing 
  // usually draws from upper left coordinate
  shapeMode(CENTER);

  // draw the svg
  shape( svgShape, width/2, height/2);
}