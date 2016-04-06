class Cylinder {
  public static final float baseSize = 25; // Rayon de la base
  private final float height = 80; // Hauteur
  private final int resolution = 40; // Resolution 
  
  private PShape cylinder = new PShape(); 
  private PShape body = new PShape();
  private PShape top = new PShape();
  private PShape bottom = new PShape();
  
  private final color bg = color(146,154,204);

  private final float[] x;
  private final float[] y;
  
  public Cylinder() {
    
    x = new float[resolution + 1];
    y = new float[resolution + 1];
  
    float angle;
    for(int i = 0; i < x.length; i++) {
      angle = (TWO_PI / resolution) * i;
      x[i] = sin(angle) * baseSize;
      y[i] = cos(angle) * baseSize;
    } 
  }
  
  // Retourne le cylindre créé à partir des 3 composantes body, top, bottom
  private PShape get() {
    body = createShape();
    body.beginShape(QUAD_STRIP); 
    
    top = createShape();
    top.beginShape(TRIANGLE_FAN);
    
    bottom = createShape();
    bottom.beginShape(TRIANGLE_FAN);
    
    // Dessine les bords du cyclindre
    for(int i = 0; i < x.length; i++) {
      body.vertex(x[i], 0, y[i]);
      body.vertex(x[i], -height, y[i]);
      
      top.vertex(x[i], -height, y[i]);   
      
      bottom.vertex(x[i], 0, y[i]);
    }
    
    body.endShape(CLOSE);
    top.endShape(CLOSE);
    bottom.endShape(CLOSE);

    cylinder = createShape(GROUP);
    cylinder.addChild(top);
    cylinder.addChild(bottom);
    cylinder.addChild(body);
    cylinder.setFill(bg);
     
    return cylinder;
  }


}