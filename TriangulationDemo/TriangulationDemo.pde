
/*
Instructions:
1. download triangulate library from http://n.clavaud.free.fr/processing/triangulate/triangulate-20100628.zip
2. place triangulate folder in your Processing/libraries/folder
3. restart Processing
*/

import org.processing.wiki.triangulate.*;

ArrayList points = new ArrayList();
ArrayList triangles = new ArrayList();

void setup() {
  
  size(600, 600);
  smooth();
}
 
void draw() {
  
  background(200);
  
  // if we have more than 3 pts
  // get the triangulated mesh
  if( points.size() >= 3 ){
    triangles = Triangulate.triangulate(points);
  }

  // draw the mesh of triangles
  stroke(0, 40);
  fill(255, 40);
  beginShape(TRIANGLES);
 
  for (int i = 0; i < triangles.size(); i++) {
    Triangle t = (Triangle)triangles.get(i);
    vertex(t.p1.x, t.p1.y);
    vertex(t.p2.x, t.p2.y);
    vertex(t.p3.x, t.p3.y);
  }
  endShape();
  
   // draw points as red dots     
  noStroke();
  fill(255, 0, 0);
  
  // loop thru and draw the pts
  for (int i = 0; i < points.size(); i++) {
    PVector p = (PVector)points.get(i);
    ellipse(p.x, p.y, 2.5, 2.5);
  }
}

void mousePressed(){
 
    // add new points on click
    points.add(new PVector(mouseX, mouseY));
}

void keyPressed(){
 
    // clear the canvas
    if( key == 'c' ) {
      points.clear();
      triangles.clear();
    }
    
    if( key == 's' ){
     
        saveFrame();
    }
}