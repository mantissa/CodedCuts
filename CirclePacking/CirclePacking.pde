
import processing.svg.*;
import processing.pdf.*;

ArrayList <Circle> circles;
PShape [] shapes;

boolean addShapes = true;
String fileName;
boolean exportShapes;
int exportLayer;
float randomRotation = 0.1; // 10% or (-5% left 5% right)

// background layer red
// bottom layer: layer 0 ( blue)
// top layer: layer 1 (yellow)

void setup() {
  
  size(600, 600);
  
  // load 4 SVG files into memory
  shapes = new PShape[4];
  shapes[0] = loadShape("01_Small.svg");
  shapes[1] = loadShape("02_Medium.svg");
  shapes[2] = loadShape("03_Large.svg");
  shapes[3] = loadShape("04_XLarge.svg");
  
  // disable svg file styles, so we can set them ourselves
  for (int i=0; i<4; i++) {
    shapes[i].disableStyle();
  }

  // collection of circles
  circles = new ArrayList();
  
  // start with one
  AddCircle();
}

void draw() {

  background(255, 255, 0);

  if ( exportShapes ) {
      // if recording
      beginRecord(SVG, fileName);
  } 

  // center the graphics
  shapeMode(CENTER);
  rectMode(CENTER);

  if ( addShapes) {

     // add one new shape per frame
    for (int i=0; i<1; i++) AddCircle();

    // grow circles until they overlap
    // do a little jiggle too
    
    for ( Circle c : circles ) {

      int ox = (int)random(-10, 10);
      int oy = (int)random(-10, 10);

      boolean isOverlapping = false;

      for ( int j=0; j< circles.size(); j++) {

        Circle other = circles.get(j);

        if ( c != other ) {

          if ( dist( other.x, other.y, c.x+ox, c.y+oy) < (other.d + c.d + c.growRate)) {

            isOverlapping = true;
            break;
          }
        } 
      }

      if ( !isOverlapping && c.isOnScreen((int)c.x+ox, (int)c.y+oy)) {
        c.x += ox;
        c.y += oy;
      }
    }

    // test if circle is overlapping
    // if not grow a little bit

    for ( Circle c : circles ) {

      boolean isOverlapping = false;

      for ( int j=0; j< circles.size(); j++) {

        Circle other = circles.get(j);

        if ( c != other ) {

          if ( dist( other.x, other.y, c.x, c.y) < (other.d + c.d + c.growRate)) {

            isOverlapping = true;
            break;
          }
        } 
      }

      // grow if isn't overlapping and shape is still on screen
      if ( !isOverlapping && c.isOnScreen((int)c.x, (int)c.y)) {
        c.grow();
      }
    }
  }

  // draw the shapes
  for ( Circle c : circles){
    
    c.draw();
  }

  // finish exporting
  if ( exportShapes ) {
    
    endRecord();
    
    
    if( exportLayer == 0 ){
      
       // if exporting layer 0, start next layer
       fileName = "data/export/layer1.svg";
       exportLayer = 1;
       
       println("exporting layer 1");
      
    } else {
      
        // if exporting layer 1, exporting is complete
        println("exporting completed");
     
        exportShapes = false;
    }
  }
}

void mousePressed() {

  boolean clickedOnClircle = false;
  
  int testIndex = 0;
  
  while( !clickedOnClircle && testIndex < circles.size()){
  
      // if we clicked on circle change the mode
      clickedOnClircle = circles.get(testIndex).getMouseClicked( mouseX, mouseY);
      
      if( clickedOnClircle ){
       
          circles.get(testIndex).nextMode();
      }
      
      testIndex++;
  }
  
  // if we didn't clicked on a circle, add a new one
  // (but only if it's 10 pix away from an existing shape)
  
  if( !clickedOnClircle ){
  
    float d = 10; //random(5, 100);
    int x = mouseX;
    int y = mouseY;
  
    boolean circleAdded = false;
  
    while ( !circleAdded) {
  
      boolean isOverlapping = false;
  
      for ( int j=0; j< circles.size(); j++) {
  
        Circle other = circles.get(j);
  
        // test if 10 less than 10 pixels & the diameter
        if ( dist( other.x, other.y, x, y) < (other.d + d)) {
  
          isOverlapping = true;
          break;
        }
      }
  
      if ( !isOverlapping && isOnScreen(x, y, (int)d)) {
        
        Circle c = new Circle(x, y, d);
        circles.add(c);
        circleAdded = true;
      
      } else {
        
        d--;
        if ( d == 3) {
          circleAdded = true;
        }
      }
    }
  }
}

// test if shape is offscreen (with boundary)

boolean isOnScreen(int x, int y, int d) {
 
  return((x+d) < width && (y+d) < height && (x-d) >= 0 && (y-d) >= 0);
}

// add a new circle with a random diameter

void AddCircle() {

  float d = random(3, 100);
  float x = random(d*2, width-d*2);
  float y = random(d*2, height-d*2);

  boolean isOverlapping = false;

  for ( int j=0; j< circles.size(); j++) {

    Circle other = circles.get(j);

    if ( dist( other.x, other.y, x, y) < (other.d + d)) {

      isOverlapping = true;
      break;
    }
  }

  // add if/when it's not overlapping

  if ( !isOverlapping ) {
    Circle c = new Circle(x, y, d);
    circles.add(c);
  }
}

void keyPressed() {

  //println(key);

  if ( key == 's') {

    // press 's' to start exporting
    
    println("exporting layer 0");

    fileName = "data/export/layer0.svg";
    exportShapes = true;
    exportLayer = 0;
    addShapes = false;
    
  } else if( key == 'c'){
    
      // press 'c' to clear and start again
    
      circles.clear();
      AddCircle();
  }
}