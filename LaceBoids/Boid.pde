// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Boid class
// Methods for Separation, Cohesion, Alignment added

class Boid {

  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  int imgID;
  float scale;
  PVector sepAliCoh;
  float neighbordist = 50;

  Boid(float x, float y) {
    
    acceleration = new PVector(0, 0);
    velocity = new PVector(random(-1, 1), random(-1, 1));
    position = new PVector(x, y);
    
    //sepAliCoh = new PVector();
    
    neighbordist = boids_NeighborDistance;
    
    sepAliCoh = new PVector( random(0.5, 1.25), random(0.5, 1.25), random(0.5, 1.0)); 
    //sepForce = boids_Separation;
    sepAliCoh.x = boids_Separation;
    sepAliCoh.y = boids_Alignment;
    sepAliCoh.z = boids_Cohesion;
    
    //sepAliCoh = new PVector( 0.25, 0.25, 0.25);
    r = 2.5;
    maxspeed = 3.0; //random(2, 5);
    maxforce = 0.5; //random(0.02, 0.5);
    scale = 1.0;
  }

  void run(ArrayList<Boid> boids) {
    flock(boids);
    update();
    borders();
    render();
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Boid> boids) {
    PVector sep = separate(boids);   // Separation
    PVector ali = align(boids);      // Alignment
    PVector coh = cohesion(boids);   // Cohesion
    
    // Arbitrarily weight these forces
    sep.mult( sepAliCoh.x ); 
    ali.mult( sepAliCoh.y );
    coh.mult( sepAliCoh.z );
    
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }

  // Method to update position
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    position.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target
    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
  }

  void render() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);
    
    fill(0);
    //stroke(255);
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    
    beginShape(TRIANGLES);
     vertex(0, -r);
     vertex(-r, r);
     vertex(r, r);
    endShape();
    
    //ellipse(0, 0, r, r);
    
    /*
    
    stroke(255);
    //ellipse( 0, 0, 45 * scale, 45 * scale);
    
    fill( 255, 0, 0);
    ellipse( 0, 0, 10, 10);

    scale( 0.2 * scale, 0.2 * scale);

    //shape( shapes.get(imgID), 0, 0 );

    //
    */
    popMatrix();
  }

  void renderConnections (ArrayList<Boid> boids, float minDist) {

    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < minDist)) {

        line( position.x, position.y, other.position.x, other.position.y);
      }
    }
  }

  // Wraparound
  void borders() {

    int border = 20;

    if (position.x < border-r) position.x = width-border+r;
    if (position.y < border-r) position.y = height-border+r;
    if (position.x > width-border+r) position.x = border-r;
    if (position.y > height-border+r) position.y = border-r;
  }

  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<Boid> boids) {

    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < neighbordist)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Boid> boids) {
    //float neighbordist = 100;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } 
    else {
      return new PVector(0, 0);
    }
  }

  // Cohesion
  // For the average position (i.e. center) of all nearby boids, calculate steering vector towards that position
  PVector cohesion (ArrayList<Boid> boids) {
    //float neighbordist = 100;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all positions
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.position); // Add position
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the position
    } 
    else {
      return new PVector(0, 0);
    }
  }

  
}