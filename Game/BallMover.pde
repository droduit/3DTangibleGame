class BallMover {
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
  
  public void update() {
    PVector gf = new PVector(sin(plate.rot.z), 0f, -sin(plate.rot.x)); // Force de gravité
    PVector ff = v.copy(); // Force de frottement
    ff.mult(-1); // Multiplie le vecteur par le scalaire -1
    ff.normalize(); 
    ff.mult(fm);
    
    PVector a = gf.add(ff); // Accélération = Force de gravité + frottement
    this.v.add(a); // On ajoute l'accélération au vecteur vitesse
    
    this.checkEdges(); 
    this.p.add(v); // On ajoute la vitesse au vecteur position
  }
  
  public void display() {
     translate(p.x, p.y, p.z); 
     sphere(25);
  }
  
  private void checkEdges() {
    float ax = e * abs(this.v.x), az = e * abs(this.v.z);
    float maxX = plate.size.x / 2f, maxZ = plate.size.z / 2f;
    
    if (p.x >  maxX) this.v.x = -1f * ax;
    if (p.x < -maxX) this.v.x =  1f * ax;
    
    if (p.z >  maxZ) this.v.z = -1f * az;
    if (p.z < -maxZ) this.v.z =  1f * az;
  }
  
  private void checkObstacles() {
    // TODO
  }
  
}