/*
1    2   3    4    5    6    7
date,time,lat,lng
*/

//BOUNDING BOX TOOL - http://boundingbox.klokantech.com/
//String dataPath = "/Users/AM_local/Desktop/DA_Project3V2/sketch_170406a/";

  /*color[] colors = {
    #ffffcc,#c7e9b4,#7fcdbb,#41b6c4,#2c7fb8, #253494
  };*/


Table path;

int totalPoints = 0;
int currentPoint = 0;

PImage img;

void setup() {
  ///size(1280,720,P3D);
  size(800,600);

  path = loadTable("MelissaPath.csv", "header");
  totalPoints = path.getRowCount();
  //loadHotelData("openpaths_AG.csv");

  noFill();
  
  //img = loadImage("moon2.jpg");
  img = loadImage("moon3.jpg");
  img.resize(width, height); 
  
  // control the 'clock' cycle
  frameRate(100);

  //println(path.getRowCount());
}

 int history = 50;

void draw() {
   background(img);
   //background(0);
  
   // increase the point id, wrapping around to start over again
   if (currentPoint >= totalPoints){
      currentPoint = 0; 
   }
   
    for (int i = 1; i < history; i++){
      int row = max(0, currentPoint-i);
      float latitude_old = path.getFloat(row, "lat");
      float longitude_old = path.getFloat(row, "lng");
      setXY_old(latitude_old, longitude_old, i);  
    }
    
    float latitude = path.getFloat(currentPoint, "lat");
    float longitude = path.getFloat(currentPoint, "lng");
    //println(latitude);
    //println(longitude);
    setXY(latitude, longitude);
    //delay(100);
  //}
}

float diameter = 0;
float grow = 1;
float maxDiameter = 40;
float base_diameter = 3;

// TOP LEFT, BOTTOM RIGHT
float[] bounds = {-74.027,40.69,-73.9,40.9};
 
float prev_x = 0;
float prev_y = 0;
 
int line_alpha = 200;
 
void setXY_old(float lat, float lng, int i) {

    // calculate x & y - longitude is x
    float x = map(lng, bounds[0], bounds[2], 85, width);
    float y = map(lat, bounds[3], bounds[1], height, 100);  
 
    // connect to old point
    stroke(255, 255, 255, line_alpha);
    line(prev_x, prev_y, x, y);
    prev_x = x;
    prev_y = y;
 
    // plot her old position
    strokeWeight(2);
    stroke(204, 204 - (204/history)*i, 255, 200);
    ellipse(x,y, base_diameter, base_diameter); 
}

void setXY(float lat, float lng) {
  
    // calculate x & y - longitude is x
    float x = map(lng, bounds[0], bounds[2], 85, width);
    float y = map(lat, bounds[3], bounds[1], height, 100);  

     // connect to old point
     stroke(0, 255, 255, line_alpha);
     line(prev_x, prev_y, x, y);
     prev_x = x;
     prev_y = y;

  if (diameter < maxDiameter){
    diameter = diameter + grow;
  } else {
    // move to the next point
    diameter = 0;
       currentPoint = currentPoint + 1;
  }

    // plot her position
    strokeWeight(2);
    stroke(255, 0, 0, 100);
    ellipse(x,y, base_diameter, base_diameter);
 
  // plot the 'blip' around her position
    stroke(0, 255 - diameter*4, 255 - diameter*4);
   ellipse(x,y, diameter, diameter);
   
   //tint(255, 127); 
   
   // plot the craters
   // crater 1
   int craterAlpha = 155;
   
   
   int crater1_x = 160;
   int crater1_y = 140;
   int crater1_diam1 = 135;
   int crater1_diam2 = 95;
   stroke(255, 0, 0, craterAlpha);
   strokeWeight(2);
   if (x < crater1_x + crater1_diam1/2){
     ellipse(crater1_x, crater1_y, crater1_diam1, crater1_diam2);
   }
   
   int crater2_x = 340;
   int crater2_y = 175;
   int crater2_diam1 = 230;
   int crater2_diam2 = 180;
   stroke(255, 0, 0, craterAlpha);
   strokeWeight(2);
   if (x > crater1_x + crater1_diam1/2 && x < crater2_x + crater2_diam1/2){
     ellipse(crater2_x, crater2_y, crater2_diam1, crater2_diam2);   
   }
   
   int crater3_x = 640;
   int crater3_y = 510;
   int crater3_diam1 = 50;
   int crater3_diam2 = 35;
   stroke(255, 0, 0, craterAlpha);
   strokeWeight(2);
   if (x > crater2_x + crater2_diam1/2){
     ellipse(crater3_x, crater3_y, crater3_diam1, crater3_diam2);    
   }
}