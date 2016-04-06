class BallMover {
  private final float BALL_RADIUS = 25F;
  
  // Physic
  private final float g = 9.81F;
  private final float normalForce = 1F;
  private final float mu = 0.01F;
  private final float e = 0.6F;
  private final float fm = normalForce * mu; // Friction magnitude
  
  private PVector p; // Position de la balle
  private PVector v; // Vitesse de la balle
  
  private final Plate plate; // Plateau qui contient la balle
  
  public BallMover(Plate plate) {
    this.plate = plate;
    this.p = new PVector(0f, -plate.size.y / 2F  - BALL_RADIUS, 0f);
    this.v = new PVector(0f, 0f, 0f);
  }
  
  // Mise à jour de la position de la balle
  public void update(float dt) {
    PVector gf = new PVector(g * sin(plate.rot.z), 0f, g * -sin(plate.rot.x)); // Force de gravité
    PVector ff = v.copy(); // Force de frottement
    ff.normalize().mult(-1F * fm); 
    
    PVector a = gf.add(ff).mult(dt); // Accélération = Force de gravité + frottement
    this.v.add(a); // On ajoute l'accélération au vecteur vitesse
    
    this.checkCylinderCollision();
    this.checkEdges();
    
    this.p.add(v); // On ajoute la vitesse au vecteur position
  }
  
  // Affichage de la balle
  public void display() {
     translate(p.x, p.y, p.z); 
     sphere(BALL_RADIUS);
  }
  
  // Vérification des collisions avec les bords du plateau
  private void checkEdges() {
    float ax = e * abs(this.v.x), az = e * abs(this.v.z);
    float maxX = (plate.size.x - BALL_RADIUS) / 2f, maxZ = (plate.size.z - BALL_RADIUS) / 2f;
    
    if (p.x >  maxX) this.v.x = -1f * ax;
    if (p.x < -maxX) this.v.x =  1f * ax;
    
    if (p.z >  maxZ) this.v.z = -1f * az;
    if (p.z < -maxZ) this.v.z =  1f * az;
    
    this.p.x = Utils.clamp(this.p.x, -maxX, maxX);
    this.p.z = Utils.clamp(this.p.z, -maxZ, maxZ);
  }
  
  // Vérification des collisions avec les obstacles
  private void checkCylinderCollision() {
    ArrayList<PVector> obstacles = plate.getObstacles();
    PVector v1 = new PVector(v.x, v.z);
    PVector p2D = new PVector(p.x, p.z);
    
    for(PVector o : obstacles) {
      if(o.dist(p2D) <= BALL_RADIUS + Cylinder.baseSize) {
        // On met à jour la vitesse
        PVector n = p2D.copy().sub(o);
        n.normalize();
        
        PVector v2 = PVector.sub(v1, n.mult(2 * v1.copy().dot(n)));
        this.v = new PVector(v2.x, 0, v2.y);
        this.v.mult(e);
        
        // On empêche la balle de traverser l'obstacle
        PVector p2Dupd = o.copy();
        n = p2D.copy().sub(o);
        n.normalize();
        p2Dupd.add(n.mult(BALL_RADIUS + Cylinder.baseSize));
        this.p = new PVector(p2Dupd.x, p.y, p2Dupd.y);
      }
    }
  }
  
  // Retourne la position de la balle
  public PVector getPosition() {
     return p; 
  }
}