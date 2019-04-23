
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

  shape( shapes[0], 150, 150 );
  shape( shapes[1], 450, 150 );
  shape( shapes[2], 450, 450 );
  shape( shapes[3], 150, 450 );
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

    saveFrame();
  }
}