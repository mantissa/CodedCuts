
import processing.svg.*;
import processing.pdf.*;

PShape svgShape;

boolean addShapes = true;
String fileName;
boolean exportShapes;

void setup() {
  
  size(600, 600);
  
  // load 4 SVG files into memory
  svgShape = loadShape("ThumbsUp.svg");
}

void draw() {

  background(255, 255, 0);

  shape( svgShape, 0, 0);
}



void keyPressed() {

  //println(key);

  if ( key == 's') {

    // press 's' to start exporting
    
    println("exporting layer 0");


    
  } 
}