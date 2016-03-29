class BallMover {
  private final float BALL_RADIUS = 25;
  
  // Physic
  private final float normalForce = 1;
  private final float mu = 0.01;
  private final float e = 0.6;
  private final float fm = normalForce * mu;
  
  private PVector p; // Position de la balle
  private PVector v; // Vitesse de la balle
  
  private final Plate plate; // Plateau qui contient la balle
  
  public BallMover(Plate plate) {
    this.plate = plate;
    this.p = new PVector(0f, -plate.size.y - 16f, 0f);
    this.v = new PVector(0f, 0f, 0f);
  }
  
  // Mise à jour de la position de la balle
  public void update() {
    PVector gf = new PVector(sin(plate.rot.z), 0f, -sin(plate.rot.x)); // Force de gravité
    PVector ff = v.copy(); // Force de frottement
    ff.mult(-1); // Multiplie le vecteur par le scalaire -1
    ff.normalize(); 
    ff.mult(fm);
    
    PVector a = gf.add(ff); // Accélération = Force de gravité + frottement
    this.v.add(a); // On ajoute l'accélération au vecteur vitesse
    
    this.checkEdges(); 
    this.checkCylinderCollision();
    
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
    float maxX = plate.size.x / 2f, maxZ = plate.size.z / 2f;
    
    if (p.x >  maxX) this.v.x = -1f * ax;
    if (p.x < -maxX) this.v.x =  1f * ax;
    
    if (p.z >  maxZ) this.v.z = -1f * az;
    if (p.z < -maxZ) this.v.z =  1f * az;
  }
  
  // Vérification des collisions avec les obstacles
  private void checkCylinderCollision() {
    ArrayList<PVector> obstacles = plate.getObstacles();
    for(PVector o : obstacles) {
      PVector n = o.copy().mult(-1).add(p).normalize(); // n = -cylindreCenter + BallCenter
      PVector v1 = v.copy();
      PVector v2 = PVector.sub(v1, n.mult(-2).mult(v1.dot(n)));
      
      if(p.x == o.x && p.y == o.y) this.v = v2.copy();
    }
  }
  
}