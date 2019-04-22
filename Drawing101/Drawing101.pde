
// setup the processing sketch

void setup(){
 
    // create a window with dimensions w & h
    size(600, 600);
    
    // set the frame rate to 30 FPS
    frameRate(30);
}

// draw function (called 30x/sec)

void draw(){
  
    // clear sceen (fill gray)
    background( 220 );
  
    // draw shapes clockwise
  
    // top left: line
    line( 100, 100, 200, 200);
    
    // top right: cirlce
    ellipseMode(CENTER);
    ellipse( 450, 150, 100, 100);
    
    // bottom right: square
    rectMode(CENTER);
    rect( 450, 450, 100, 100);
    
    // bottom left: rectangle
    rect( 150, 450, 100, 200);
}