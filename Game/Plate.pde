class Plate {
  PVector size; // Taille
  PVector rot; // Rotation
  
  float va = PI /  144f; // Vitesse de rotation
  float da = PI / 1440f; // Accélération de rotation
  final float MIN_ANGLE = -PI / 3f; // Angle minimum
  final float MAX_ANGLE =  PI / 3f; // Angle maximum
  final float MIN_SPEED = PI / 720f;
  final float MED_SPEED = PI / 144f;
  final float MAX_SPEED = PI /  96f;

  Plate() {
    this(new PVector(500f, 20f, 500f), new PVector(0f, 0f, 0f));
  }

  Plate(PVector size, PVector rot) {
    this.size = size;
    this.rot = rot;
  }
  
  void display() {
    // fill(125, 125, 125);
    
    translate(width / 2f, height / 2f, 0f);
    rotateX(rot.x);
    rotateZ(rot.z);
    
    box(size.x, size.y, size.z);
  }
  
  /**
  Affiche les informations speed, rotationX,Y en haut de la fenetre
  */
  void displayInfo() {
    fill(0, 0, 0);
    textSize(12);
    
    float speed = va / MED_SPEED;
    text("RotationX : "+nf(degrees(rot.x), 0, 1), 0, 15, 0);
    text("RotationZ : "+nf(degrees(rot.z),0,1), 130, 15, 0);
    text("Speed : "+nf(speed,0,1), 250, 15, 0);
    
    fill(200, 200, 255);
  }
  
  void mouseWheelEvent(float e) {
    this.va = Utils.clamp(va - e * da, MIN_SPEED, MAX_SPEED);
  }

  void mouseDraggedEvent() {
    float dy = -Utils.clamp(mouseY - pmouseY, -1, 1);
    float dx =  Utils.clamp(mouseX - pmouseX, -1, 1);
    
    rot.x = Utils.clamp(rot.x + dy * va, MIN_ANGLE, MAX_ANGLE);
    rot.z = Utils.clamp(rot.z + dx * va, MIN_ANGLE, MAX_ANGLE);
  }
}