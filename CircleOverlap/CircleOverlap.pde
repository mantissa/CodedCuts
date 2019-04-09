
// define two circles
Circle c1;
Circle c2;

void setup(){
 
    size( 800, 400);
  
    // create two circles 
    // note: two different diameters
    c1 = new Circle( width/2 - 120, height/2, 220);
    c2 = new Circle( width/2 + 120, height/2, 160);
}

void draw(){
  
    // clear the background
    background(127);
    
    // --------- draw the first circle ---------
    
    fill( 0, 255, 0);
    c2.draw();
    
    // --------- draw the second circle ---------
    
    // test if two circles overlap
  
    if( getCirclesOverlap( c1, c2 )){
     
        // if they do, draw in red
        fill( 255, 0, 0);
        
    } else {
     
        // if not, draw in blue
        fill( 0, 0, 255);
    }
  
    c1.draw();
    
    // --------- draw a line connecting the two circles ---------
    
    stroke( 0 );
    strokeWeight(5);
    
    line( c1.x, c1.y, c2.x, c2.y);
}

boolean getCirclesOverlap( Circle c1, Circle c2 ){
    
    // calculate distance on x-axis
    float dx = c1.x - c2.x;
    
    // calculate distance on y-axis
    float dy = c1.y - c2.y;
    
    // distance = square root of (x*x + y*y) 
    float d = sqrt( dx * dx + dy * dy);
    
    // if distance is less than the radius (diameter/2)
    if( d < c1.diam/2 + c2.diam/2 ){
        return true;
    }
    
    return false;
}

void mousePressed(){
 
    c1.x = mouseX;
    c1.y = mouseY;
}

void mouseDragged(){
 
    c1.x = mouseX;
    c1.y = mouseY;
}