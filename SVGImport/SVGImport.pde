
// import the library
import processing.svg.*;

// define our shape
PShape svgShape;

void setup() {
  
  size(600, 600);
  
  // load the shape into 
  svgShape = loadShape("Trangle04_tif.svg");
}

void draw() {

  // clear the bg
  background(255, 255, 0);

  // draw the svg
  shape( svgShape, 0, 0);
}