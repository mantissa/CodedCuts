
enum CutMode 
{ 
  CUT, CUT_TO_BACK, CUT_TO_BACK_CIRCLE
}

class Circle {

  float x;
  float y;
  float d;
  int shapeIndex = 0; 
  float r = random(TWO_PI); // random rotation
  int padding = 3; // fixed padding
  CutMode cutMode = CutMode.CUT; 

  float growRate = 1;

  Circle(float x_, float y_, float d_ ) {
    
    x = x_;
    y = y_;
    d = d_;

    // random cut behavior
    // 33% change for each mode

    float randomMode = random(1.0);

    if ( randomMode < 0.33) {

      cutMode = CutMode.CUT_TO_BACK;
      
    } else if ( randomMode < 0.66 ) {

      cutMode = CutMode.CUT_TO_BACK_CIRCLE;
    }
  }

  void grow() {
    d = d+growRate;
  }

  // make sure shape isn't going offscreen 

  boolean isOnScreen(int x, int y) {
    return((x+d+growRate) < width && (y+d+growRate) < height && (x-d-growRate) >= 0 && (y-d-growRate) >= 0);
  }

  void draw() {
    
    noStroke();

    pushMatrix();

    translate(x, y);

    rotate( r );

    // which shape depends on size
    // we use map() to map the size to the shape index
    shapeIndex = (int)map( d, 10, 100, 0, 3);
    shapeIndex = constrain( shapeIndex, 0, 3);

    // we scale the shape to that it fits in the circle
    // with a bit of extra padding
    float scale =  (d * 2 - padding * 3 ) / shapes[shapeIndex].width ;

    noStroke();

    if ( !exportShapes) {
      
      // when not exporting

      switch( cutMode ) {

      case CUT:

        fill( 0, 0, 255);
        break;

      case CUT_TO_BACK:

        fill( 255, 0, 0);
        break;

      case CUT_TO_BACK_CIRCLE:

        fill(0, 0, 255);
        ellipse(0, 0, d*2-padding, d*2-padding);

        fill( 255, 0, 0);
        break;
      }

      scale( scale);
      shape(shapes[shapeIndex], 0, 0);
      
      
    } else {
      
      // when exporting
      
      fill(0);

      if ( exportLayer == 0 ) {

        switch( cutMode ) {

        case CUT:
          break;

        case CUT_TO_BACK:

          scale( scale);
          shape(shapes[shapeIndex], 0, 0);
          break;

        case CUT_TO_BACK_CIRCLE:

          scale( scale);
          shape(shapes[shapeIndex], 0, 0);
          
          break;
        }
        
      } else {

        // always cut
        
        if( cutMode == CutMode.CUT_TO_BACK_CIRCLE ){
          
            ellipse(0, 0, d*2-padding, d*2-padding);
        
        } else {
         
            scale( scale );
            shape(shapes[shapeIndex], 0, 0);
        }
      }
    }
    
    popMatrix();
  }
  
  // test if mouse clicked inside circle
  
  boolean getMouseClicked( int x, int y ){
   
      float dx = this.x - x;
      float dy = this.y - y;
      
      float dist = sqrt( dx * dx + dy * dy);
      
      return dist < d;
  }
  
  // progress to next state
  
  void nextMode(){
    
      switch( cutMode ) {

        case CUT:
          cutMode = CutMode.CUT_TO_BACK;
          break;

        case CUT_TO_BACK:

          cutMode = CutMode.CUT_TO_BACK_CIRCLE;
          break;

        case CUT_TO_BACK_CIRCLE:

          cutMode = CutMode.CUT;
          break;
        }
  }
};