class Cylinder {
  float cylinderBaseSize = 30;
  float cylinderHeight = 90;
  int cylinderResolution = 40;
  
  PShape cylinder = new PShape();
  PShape body = new PShape();
  PShape top = new PShape();
  PShape bottom = new PShape();
  
  float angle;
  float[] x = new float[cylinderResolution + 1];
  float[] y = new float[cylinderResolution + 1];
  
  Cylinder() {
    for(int i = 0; i < x.length; i++) {
      angle = (TWO_PI / cylinderResolution) * i;
      x[i] = sin(angle) * cylinderBaseSize;
      y[i] = cos(angle) * cylinderBaseSize;
    } 
  }
  
  // Créé le manteau du cylindre
  private PShape body() {
    body = createShape();
    body.beginShape(QUAD_STRIP); 
    // Dessine les bords du cyclindre
    for(int i = 0; i < x.length; i++) {
      body.vertex(x[i], 0, y[i]);
      body.vertex(x[i], -cylinderHeight, y[i]);
    }
    body.endShape(CLOSE);
    return body;
  }
  
  // Créé le dessus du cylindre
  private PShape top() {
    top = createShape();
    top.beginShape(TRIANGLE_FAN);
    for(int i = 0; i < x.length; i++) {
        top.vertex(x[i], -cylinderHeight, y[i]);    
    }
    top.endShape(CLOSE);
    return top;
  }
  
  // Créé le dessous du cylindre
  private PShape bottom() {
    bottom = createShape();
    bottom.beginShape(TRIANGLE_FAN);
    for (int i = 0; i < x.length; i++) {
      bottom.vertex(x[i], 0, y[i]);
    }
    bottom.endShape(CLOSE);
    return bottom;
  }
  
  // Retourne le cylindre créé à partir des 3 composantes body, top, bottom
  public PShape get() {
     cylinder = createShape(GROUP);
     cylinder.addChild(top());
     cylinder.addChild(bottom());
     cylinder.addChild(body());
     cylinder.setFill(color(146,154,204));
     return cylinder;
  }

}