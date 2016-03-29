class Plate {
  PVector pos;
  PVector size; // Taille
  PVector rot; // Rotation
  
  float va = PI /  144f; // Vitesse de rotation
  float da = PI / 1440f; // Accélération de rotation
  final float MIN_ANGLE = -PI / 3f; // Angle minimum
  final float MAX_ANGLE =  PI / 3f; // Angle maximum
  final float MIN_SPEED = PI / 720f;
  final float MED_SPEED = PI / 144f;
  final float MAX_SPEED = PI /  96f;
  
  float plateXMin = 0f;
  float plateXMax = 0f;
  float plateYMin = 0f;
  float plateYMax = 0f;
  
  boolean isShiftMode = false;
  PVector tmpRot = new PVector(0f, 0f, 0f); // Stoque le vecteur de rotation lors du SHIFT appuyé
  ArrayList<PVector> obstacles;

  Plate() {
    this(new PVector(500f, 20f, 500f), new PVector(0f, 0f, 0f), new PVector(width/2f, height/2f, 0f) );
  }

  Plate(PVector size, PVector rot, PVector pos) {
    this.pos = pos;
    this.size = size;
    this.rot = rot;
    this.obstacles = new ArrayList();
    
    plateXMin = pos.x - size.x/2;
    plateXMax = pos.x + size.x/2;
    plateYMin = pos.y - size.z/2;
    plateYMax = pos.y + size.z/2;
    
    System.out.println("plate : x : "+pos.x+" - y : "+pos.y);
  }
  
  void display() {
    fill(200, 200, 255);
   
    translate(pos.x, pos.y, pos.z);
    rotateX(rot.x);
    rotateZ(rot.z);
    box(size.x, size.y, size.z);
    
    for(PVector cPos : obstacles) {
      pushMatrix();
      Cylinder c = new Cylinder();
      translate(cPos.x, 0, cPos.y);
      shape(c.get());
      popMatrix();
    }
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
  }
  
  void mouseWheelEvent(float e) {
    this.va = Utils.clamp(va - e * da, MIN_SPEED, MAX_SPEED);
  }

  void mouseDraggedEvent() {
    if(!isShiftMode) {
      float dy = -Utils.clamp(mouseY - pmouseY, -1, 1);
      float dx =  Utils.clamp(mouseX - pmouseX, -1, 1);
      
      rot.x = Utils.clamp(rot.x + dy * va, MIN_ANGLE, MAX_ANGLE);
      rot.z = Utils.clamp(rot.z + dx * va, MIN_ANGLE, MAX_ANGLE);
    }
  }
  
  // Active le mode d'ajout d'obtacles
  void shiftMode() {
      isShiftMode = true;
      tmpRot = new PVector(rot.x, rot.y, rot.z);
      rot = new PVector(-PI/2f, 0f, 0f);
  }
  
  // Désactive le mode d'ajout d'obstacles
  void releaseShiftMode() {
    isShiftMode = false;
    rot = new PVector(tmpRot.x, tmpRot.y, tmpRot.z);
  }
  
  // Ajoute un obstacle sur le plateau
  void addObstacle() {
      if(isInPlate(mouseX, mouseY)) {
        PVector position = new PVector(mouseX-this.size.x, mouseY-this.size.z);
        this.obstacles.add(position);
      }
  }
  
  // Indique si la position (x,y) est a l'intérieur du plateau
  boolean isInPlate(float x, float y) {
    return (x >= plateXMin && x <= plateXMax && y >= plateYMin && y <= plateYMax); 
  }
}