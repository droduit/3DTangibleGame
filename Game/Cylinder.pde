class Cylinder {
  float cylinderBaseSize = 50;
  float cylinderHeight = 50;
  int cylinderResolution = 1550;
  
  PShape cylinder = new PShape();
  PShape body = new PShape();
  PShape top = new PShape();
  PShape bottom = new PShape();
  
  float angle;
  float[] x = new float[cylinderResolution + 1];
  float[] y = new float[cylinderResolution + 1];
  
  Plate plate;
    
  Cylinder(Plate plate) {
    this.plate = plate;
    
    for(int i = 0; i < x.length; i++) {
      angle = (TWO_PI / cylinderResolution) * i;
      x[i] = sin(angle) * cylinderBaseSize;
      y[i] = cos(angle) * cylinderBaseSize;
    } 
   
     cylinder = createShape(GROUP);
     cylinder.addChild(top);
     cylinder.addChild(body);
     cylinder.addChild(bottom);
  }
  
  PShape body() {
    body = createShape();
    body.beginShape(TRIANGLE_FAN); 
    for(int i = 0; i < x.length; i++) {
      body.vertex(x[i], -2*plate.size.y, y[i]);
      body.vertex(x[i], -2*plate.size.y+cylinderHeight, y[i]);
    }
    body.endShape(CLOSE);
    return body;
  }
  
  PShape top() {
    top = createShape();
    top.beginShape();
    for (int i = 0; i < x.length; i++) {
        top.vertex(x[i], y[i], cylinderHeight);    
    }
    top.endShape(CLOSE);
    return top;
  }
  
  PShape bottom() {
    bottom.beginShape();
    for (int i = 0; i < x.length; i++) {
      bottom.vertex( x[i], y[i], 0);
    }
    bottom.endShape(CLOSE);
    return bottom;
  }

}