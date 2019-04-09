
// we need these libraries for importing/exporting svgs
// and also for triangulation & ui
import java.util.List;
import org.processing.wiki.triangulate.*;
import processing.pdf.*;
import processing.svg.*;
import controlP5.*;

// boids & boids positions
ArrayList<Boid> boids;
ArrayList points;
ArrayList triangles;

// drawing state
boolean paused = false;
boolean drawBoids = false;

// saving options
boolean saveFile = false;
String fileName = "LaceBoids.svg";

// gui 
ControlP5 cp5;
float boids_Separation = 1.;
float boids_Alignment = 1;;
float boids_Cohesion = 1.;
int boids_NeighborDistance = 50;
int boids_Count = 500;
boolean uiVisible = true;
boolean showMesh = false;

void setup() {

  // 700 x 700 canvas
  frameRate(30);
  size(700, 700);

  boids = new ArrayList<Boid>();
  points = new ArrayList();
  triangles = new ArrayList();
  
  createUI();
   
  createBoids();
}

void draw() {

  background(255);

  // update the boids
  if ( !paused)
  {
    for (Boid b : boids)
    {
      b.flock(boids);
      b.update();
      b.borders();
    };
  }

  stroke(0);
  strokeWeight(1);
  strokeCap(ROUND);
  noFill();

  // collect the positions
  points.clear();

  for (Boid b : boids)
  {
    points.add( b.position );
  };
  
  

  if( drawBoids ){
    
    // draw the boids
    
    shapeMode(CENTER);

    for (Boid b : boids)
    {
      b.render();
    };
    
  } else {
    
    // draw the triangles
  
    triangles = Triangulate.triangulate(points);

    if( saveFile){
     
        beginRecord(SVG, fileName);
    }
  
    // draw the mesh of triangles

    noStroke();
    fill(0);
    
    randomSeed(200);
    
    for (int i = 0; i < triangles.size(); i++) {
      
      Triangle t = (Triangle)triangles.get(i);
      
      if( showMesh ){
        
          float r = random(255);
          float g = random(255);
          float b = random(255);
          
          fill(r,g,b);
     
          beginShape(TRIANGLES);
          vertex(t.p1.x, t.p1.y);
          vertex(t.p2.x, t.p2.y);
          vertex(t.p3.x, t.p3.y);
          endShape();

      } else {
       
          // here we inset the mesh by a fixed amout
          // because we want to make sure the triangles are 
          // smaller and therefore not touching
        
          PVector p1 = new PVector( (int)t.p1.x, (int)t.p1.y );
          PVector p2 = new PVector( (int)t.p2.x, (int)t.p2.y );
          PVector p3 = new PVector( (int)t.p3.x, (int)t.p3.y );
      
          // inset vertices by 1.5 pixels
      
          float insetAmt = 1.5;
          PVector inset1 = getInset( p1, p2, p3, insetAmt );
          PVector inset2 = getInset( p2, p1, p3, insetAmt );
          PVector inset3 = getInset( p3, p1, p2, insetAmt );
          
          // make sure all 3 points fall in the original triangle
          
          boolean i1 = pointInTriangle( inset1, p1, p2, p3);
          boolean i2 = pointInTriangle( inset2, p1, p2, p3);
          boolean i3 = pointInTriangle( inset3, p1, p2, p3);

         if( i1 && i2 && i3 ){
           
             beginShape(TRIANGLES);
             vertex(inset1.x, inset1.y);
             vertex(inset2.x, inset2.y);
             vertex(inset3.x, inset3.y);
             endShape();
         }
      }
    }
    
    // if we're saving/exporting, close and stop
    
    if ( saveFile ) {
      endRecord();
      saveFile = false;
    }
  }
}

void createUI(){
  
  cp5 = new ControlP5(this);
  
  cp5.addSlider("boids_Count")
     .setPosition(20,20)
     .setRange(10,500)
     .setValue(200);
  
  cp5.addSlider("boids_Separation")
     .setPosition(20,40)
     .setRange(0.1,2.0)
     .setValue(1.0);
     
   cp5.addSlider("boids_Alignment")
     .setPosition(20,60)
     .setRange(0.1,2.0)
     .setValue(1.0);
     
   cp5.addSlider("boids_Cohesion")
     .setPosition(20,80)
     .setRange(0.1,2.0)
     .setValue(1.0);
     
   cp5.addSlider("boids_NeighborDistance")
     .setPosition(20,100)
     .setRange(20,200)
     .setValue(100);
     
    cp5.addToggle("show_Boids")
     .setPosition(20,120)
     .setSize(50,20);
    
   cp5.addButton("New_Flock")
     .setValue(0)
     .setPosition(20,160)
     .setSize(200,19);
     
   cp5.addButton("Save_File")
     .setValue(0)
     .setPosition(20,185)
     .setSize(200,19);
   
   cp5.getController("boids_Count").getCaptionLabel().setColor(color(255, 0, 0) );
   cp5.getController("boids_Separation").getCaptionLabel().setColor(color(255, 0, 0) );
   cp5.getController("boids_Alignment").getCaptionLabel().setColor(color(255, 0, 0) );
   cp5.getController("boids_Cohesion").getCaptionLabel().setColor(color(255, 0, 0) );
   cp5.getController("boids_NeighborDistance").getCaptionLabel().setColor(color(255, 0, 0) );
   cp5.getController("show_Boids").getCaptionLabel().setColor(color(255, 0, 0) );
}

void keyPressed() {
  
  // space: pause/unpause
  // u: show/hide ui
  // m: show/hide mesh

  if ( key == ' ' ) paused = !paused;
  
  if( key == 'm' ) showMesh = !showMesh;
  
  if( key == 'u' ) {
    
    if(!uiVisible  ){
      
      cp5.show();
    
    } else {
    
      cp5.hide();
    }
    
    uiVisible = !uiVisible;
  }
}

// create a new collection of boids

void createBoids(){
 
  boids.clear();
  
  for (int i=0; i<boids_Count; i++)
  {
    //float x = width/2 + random(-200, 200);
    //float y = height/2 + random(-200, 200);
    
    float x =  random(250, width-250);
    float y = random(250, height-250);

    boids.add( new Boid(x, y) );
  }
}

// ui callbacks (called when ui button/slider states have changed)

public void show_Boids(boolean theValue) {
  
  println("a button event from show_Boids "+theValue);
  
  drawBoids = theValue;
}

// function colorA will receive changes from 
// controller with name colorA
public void New_Flock(int theValue) {
  
  println("a button event from New_Flock");
  
  createBoids();
}

public void Save_File(int theValue) {
  
  println("a button event from Save_File");
  
  saveFile = true;
}

PVector getInset( PVector pt, PVector left, PVector right, float distance) {

  PVector CB = new PVector( right.x - left.x, right.y - left.y);
  PVector BA = new PVector( left.x - pt.x, left.y - pt.y);
  PVector CA = new PVector( right.x - pt.x, right.y - pt.y);

  float lengthBA = BA.mag();
  float lengthCA = CA.mag();
  float ratio = lengthBA / ( lengthBA + lengthCA );
  

  CB.mult(ratio);
  PVector D = new PVector(left.x, left.y);
  D.add(CB);
  PVector AD = new PVector(D.x, D.y);
  AD.sub( pt );
  PVector bisect = new PVector(AD.x, AD.y);
  bisect.normalize();

  float theta = acos( BA.dot( CA ) / (lengthBA * lengthCA) ) / 2.0;
  float AE = distance/(sin(theta));


  //println(AD.mag());

  PVector newPos = new PVector(pt.x, pt.y);
   
  newPos.z += AE/AD.mag() * (D.z - pt.z); 
  newPos.x += bisect.x*AE;
  newPos.y += bisect.y*AE;

  return newPos;
};

float getArea( PVector p1,  PVector p2,  PVector p3){
  
   PVector _p1 = new PVector(p1.x, p1.y);
   _p1.sub( p2 );
   
   PVector _p2 = new PVector(p2.x, p2.y);
   _p2.sub( p3 );
   
   PVector _p3 = new PVector(p3.x, p3.y);
   _p3.sub( p1 );
   
   float a = _p1.mag();
   float b = _p2.mag();
   float c = _p3.mag();
   
   float s = (a + b + c) / 2;
   
   return sqrt(s*(s-a)*(s-b)*(s-c)) ;
};

boolean isPointInTriangle(PVector p, PVector p0, PVector p1, PVector p2){
 
    float A = 1/2 * (-p1.y * p2.x + p0.y * (-p1.x + p2.x) + p0.x * (p1.y - p2.y) + p1.x * p2.y);
    float sign = A < 0 ? -1 : 1;
    float s = (p0.y * p2.x - p0.x * p2.y + (p2.y - p0.y) * p.x + (p0.x - p2.x) * p.y) * sign;
    float t = (p0.x * p1.y - p0.y * p1.x + (p0.y - p1.y) * p.x + (p1.x - p0.x) * p.y) * sign;
    
    return s > 0 && t > 0 && (s + t) < 2 * A * sign; 
}

float sign (PVector p1, PVector p2, PVector p3)
{
    return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y);
}

boolean pointInTriangle (PVector pt, PVector v1, PVector v2, PVector v3)
{
    float d1, d2, d3;
    boolean has_neg, has_pos;

    d1 = sign(pt, v1, v2);
    d2 = sign(pt, v2, v3);
    d3 = sign(pt, v3, v1);

    has_neg = (d1 < 0) || (d2 < 0) || (d3 < 0);
    has_pos = (d1 > 0) || (d2 > 0) || (d3 > 0);

    return !(has_neg && has_pos);
}

void boids_Separation(float sep) {

  println("setting boids_Separation to "+sep);
  
  for( Boid b : boids ){
      b.sepAliCoh.x = sep;
  }
}

void boids_Alignment(float ali) {

  println("setting boids_Alignment to "+ali);
  
  for( Boid b : boids ){
      b.sepAliCoh.y = ali;
  }
}

void boids_Cohesion(float coh) {

  println("setting boids_Cohesion to "+coh);
  for( Boid b : boids ){
      b.sepAliCoh.z = coh;
  }
}

void boids_NeighborDistance(float dist) {

  println("setting boids_NeighborDistance to "+dist);
  for( Boid b : boids ){
      b.neighbordist = dist;
  }
}