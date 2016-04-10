class BallMover {
  private final float BALL_RADIUS = 25F;
  
  // Physic
  private final float g = 9.81F;
  private final float normalForce = 1F;
  private final float mu = 0.03F;
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
    PVector ff = v.copy();
    ff.normalize().mult(-1F * fm); 
    
    this.checkCylinderCollision();
    this.checkEdges();
    
    PVector a = gf.add(ff).mult(dt); // Accélération = Force de gravité + frottement
    this.v.add(a); // On ajoute l'accélération au vecteur vitesse
    
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
  private boolean checkCylinderCollision() {
    ArrayList<PVector> newPositions = new ArrayList<PVector>();
    ArrayList<PVector> obstacles = plate.getObstacles();
    PVector v1 = new PVector(v.x, v.z);
    PVector p2D = new PVector(p.x, p.z);
    
    boolean collision = false;
    for(PVector o : obstacles) {
      if(o.dist(p2D) <= BALL_RADIUS + CYLINDER.radius) {
        // On met à jour la vitesse
        PVector n = p2D.copy().sub(o).normalize();

        v1.sub(n.mult(2 * v1.copy().dot(n)));
        this.v = new PVector(v1.x, 0, v1.y);
        // this.v.mult(e);
        
        // On empêche la balle de traverser l'obstacle
        PVector p2Dupd = o.copy();
        n = p2D.copy().sub(o).normalize();
        p2Dupd.add(n.mult(BALL_RADIUS + CYLINDER.radius));
        newPositions.add(new PVector(p2Dupd.x, this.p.y, p2Dupd.y));
        
        collision = true;
      }
    }
    
    if (collision) {
      PVector finalVector = new PVector();
      
      for (PVector pos : newPositions)
        finalVector.add(pos);
        
      this.p = finalVector.mult(1f / newPositions.size());
    }
    
    return collision;
  }
  
  // Retourne la position de la balle
  public PVector getPosition() {
     return p; 
  }
}
