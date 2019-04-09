class Circle {
  
  float x;
  float y;
  float diam;
  
  int c = (int)random(255);
  float r = random(TWO_PI);
  int padding = 0;

  float growRate = 1;

  Circle(float x_, float y_, float d_ ) {
    
    // create a circle @ xy with diameter d
    x = x_;
    y = y_;
    diam = d_;
  }


  void draw() {

    noStroke();
    
    pushMatrix();

    translate(x, y);

    rotate( r );

    ellipse(0, 0, diam, diam);

    popMatrix();
  }
};