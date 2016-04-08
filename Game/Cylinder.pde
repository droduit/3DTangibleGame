final Cylinder CYLINDER = new Cylinder();

class Cylinder {
  private PShape shape = null;

  final float radius;
  final float height;
  final int resolution;
  final color fillColor;

  Cylinder() { this(25, 80, 40, color(146, 154, 204)); }
  Cylinder(float radius, float height, int resolution, color fillColor) {
    this.radius = radius;
    this.height = height;
    this.resolution = resolution;
    this.fillColor = fillColor;
  }
  
  PShape getShape() {
    if (shape == null) {
        PShape body = createShape();
        body.beginShape(QUAD_STRIP);
        
        PShape top = createShape();
        top.beginShape(TRIANGLE_FAN);
        top.vertex(0, -height, 0);
        
        PShape bottom = createShape();
        bottom.beginShape(TRIANGLE_FAN);
        bottom.vertex(0,0,0);

        // Dessine les bords du cyclindre
        float da = TWO_PI / resolution;
        for (int i = 0; i <= resolution; i++) {
          float angle = i * da;
          float x = cos(angle) * radius,
                y = sin(angle) * radius;

          body.vertex(x, 0, y);
          body.vertex(x, -height, y);
          
          top.vertex(x, -height, y);
          
          bottom.vertex(x, 0, y);
        }
        
        bottom.endShape(CLOSE);
        top.endShape(CLOSE);
        body.endShape(CLOSE);

        shape = createShape(GROUP);
        shape.addChild(top);
        shape.addChild(bottom);
        shape.addChild(body);
        shape.setFill(fillColor);
    }
     
    return shape;
  }
}
