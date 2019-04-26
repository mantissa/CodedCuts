
import processing.svg.*;
import java.util.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

String fileName;
boolean exportShapes;

void setup() {
  
  size(600, 600);
}

void draw() {

  if( exportShapes ){
    
    beginRecord(SVG, fileName);
  }
  
  // yellow background
  // we call background after beginRecord 
  // so it will be included in the expored file 
  background(255, 255, 0);
  
  // draw a (5x5) grid of white shapes with blue outlines
  
  int nSteps = 5;
  float stepSize = float(width) / (nSteps-1);
  float strokeW = 10;
  
  // fill white, blue stroke
  fill(255);
  stroke(0, 0, 255);
  strokeWeight(strokeW);
  
  // draw circles in center
  ellipseMode(CENTER);
  
  for(int i=0; i<nSteps; i++){
    for(int j=0; j<nSteps; j++){ 
      
        float x = i * stepSize;
        float y = j * stepSize;
        
        ellipse( x, y, stepSize - strokeW*2, stepSize - strokeW*2);
    }
  }
  
  //noFill();
  //rect(0, 0, width, height);
  
  if( exportShapes ){
    
     endRecord();
     
     println("Finished saving SVG file");
     
     exportShapes = false;
  }
}


void keyPressed() {

  if ( key == 's') {

    // press 's' to start exporting

    // create a dynamic name for exporting (based on today's date) 
    // so that we don't overwrite any previous exports
    // note: extra java libraries imported at top of sketch
    DateFormat formatter = new SimpleDateFormat("yyyy_MM_dd_HH_mm_ss");
    Date d = new Date();
    
    // add strings to begin/end, including name and file type
    fileName = "Export_"+formatter.format(d)+".svg";
    
    println("Writing to file "+fileName);
    
    exportShapes = true;
  } 
}