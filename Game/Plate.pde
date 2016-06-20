class Plate {
  private PVector pos; // Position
  private PVector size; // Taille
  private PVector rot; // Rotation
  
  private float va = PI /  144f; // Vitesse de rotation
  private float da = PI / 1440f; // Accélération de rotation
  private final float MIN_ANGLE = -PI / 3f; // Angle minimum
  private final float MAX_ANGLE =  PI / 3f; // Angle maximum
  private final float MIN_SPEED = PI / 720f;
  private final float MED_SPEED = PI / 144f;
  private final float MAX_SPEED = PI /  96f;
  private float speed = 0F; // Vitesse affichée
  
  // Positions des bords du plateau
  private float plateXMin = 0f;
  private float plateXMax = 0f;
  private float plateYMin = 0f;
  private float plateYMax = 0f;
  
  private boolean isShiftMode = false; // true : Mode Shift activé
  private ArrayList<PVector> obstacles; // Obstacles sur le plateau

  public Plate() {
    this(new PVector(500f, 20f, 500f));
  }
  public Plate(PVector size) {
    this(size, new PVector(0f, 0f, 0f), new PVector(width/2f, height/2f, 0f) );
  }
  private Plate(PVector size, PVector rot, PVector pos) {
    this.pos = pos;
    this.size = size;
    this.rot = rot;
    this.obstacles = new ArrayList();
    
    plateXMin = pos.x - size.x/2;
    plateXMax = pos.x + size.x/2;
    plateYMin = pos.y - size.z/2;
    plateYMax = pos.y + size.z/2;
  }
  
  public PVector position() { return this.pos; }
  public void position(PVector pos) { this.pos = pos; }
  public PVector size() { return this.size; }
  public void size(PVector size) { this.size = size; }
  public PVector rotation() { return this.rot; }
  public void rotation(PVector rot) { this.rot = rot; }
  
  public void display() {
    fill(200, 200, 255);
   
    translate(pos.x, pos.y, pos.z);
    rotateX(rot.x);
    rotateZ(rot.z);
    box(size.x, size.y, size.z);
    
    for(PVector cPos : obstacles) {
      pushMatrix();
      translate(cPos.x, 0f, cPos.y);
      shape(CYLINDER.getShape());
      popMatrix();
    }
    
    speed = va / MED_SPEED;
  }
  
  // Affiche les informations speed, rotationX,Y en haut de la fenetre
  public void displayInfo() {
    fill(0, 0, 0);
    textSize(12);
    
    text("RotationX : "+nf(degrees(rot.x), 0, 1), 0, 15, 0);
    text("RotationZ : "+nf(degrees(rot.z),0,1), 130, 15, 0);
    text("Speed : "+nf(speed,0,1), 250, 15, 0);
  }
  
  public void mouseWheelEvent(float e) {
    this.va = Utils.clamp(va - e * da, MIN_SPEED, MAX_SPEED);
  }

  public void mouseDraggedEvent() {
    if (!isShiftMode && !isMouseOverScrollBar()) {
      float dy = -Utils.clamp(mouseY - pmouseY, -1, 1);
      float dx =  Utils.clamp(mouseX - pmouseX, -1, 1);

      rot.x += dy * va;
      rot.z += dx * va;
      
      this.clampRotation();
    }
  }

  public void clampRotation() {
    rot.x = Utils.clamp(rot.x, MIN_ANGLE, MAX_ANGLE);
    rot.z = Utils.clamp(rot.z, MIN_ANGLE, MAX_ANGLE);
  }
  
  // Ajoute un obstacle sur le plateau
  public void addObstacle() {
      if (isValidObstaclePosition(mouseX, mouseY))
        this.obstacles.add(
          new PVector(mouseX - this.pos.x, mouseY - this.pos.y));
  }
  
  // Indique si la position (x,y) est a l'intérieur du plateau
  public boolean isInPlate(float x, float y) {
    return (x >= plateXMin && x <= plateXMax && y >= plateYMin && y <= plateYMax); 
  }

  public boolean isBusyPosition(float x, float y) {
    float busyRadius = 4 * CYLINDER.radius * CYLINDER.radius;
    
    /*
    PVector ballPos = ballMover.getPosition();
    if(pow(ballPos.x - x + pos.x,2) + pow(ballPos.y - y + pos.y, 2) <= busyRadius)
      return true;
    */
    
    for (PVector obstacle : obstacles) {
      float dx = obstacle.x - x + pos.x,
            dy = obstacle.y - y + pos.y;

      if (dx * dx + dy * dy <= busyRadius)
        return true;
    }

    return false;
  }

  public boolean isValidObstaclePosition(float x, float y) {
    return isInPlate(x, y) && !isBusyPosition(x, y);
  }
  
  public boolean isMouseOverScrollBar() {
    return (mouseY > height-(StatsView.HEIGHT/4));
  }
  
  
  // Retourne les obstacles du plateau
  public ArrayList<PVector> getObstacles() {
    return obstacles;
  }
  
  // Retourne la vitesse de la balle
  public float getSpeed() {
    return speed; 
  }
}
