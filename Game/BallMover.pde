class BallMover {
  // Physic
  final float g = 9.81;
  final float normalForce = 1;
  final float mu = 0.01;
  final float e = 0.6;
  final float fm = normalForce * mu;
  
  PVector p; // Position de la balle
  PVector v; // Vitesse de la balle
  
  final Plate plate;
  
  BallMover(Plate plate) {
    this.plate = plate;
    this.p = new PVector(0, -plate.size.y - 16, 0);
    this.v = new PVector(0, 0, 0);
  }
  
  void update() {
    PVector gf = new PVector(sin(plate.rot.z), 0, -sin(plate.rot.x));
    PVector ff = v.get();
    
    ff.mult(-1);
    ff.normalize();
    ff.mult(fm);
    
    PVector a = gf.add(ff);
    this.v.add(a);
    
    this.checkEdges();
    this.p.add(v);
  }
  
  void display() {
     fill(127);
     translate(p.x, p.y, p.z);
     sphere(25);
  }
  
  void checkEdges() {
    float ax = e * abs(this.v.x), az = e * abs(this.v.z);
    float maxX = plate.size.x / 2, maxZ = plate.size.z / 2;
    
    if (p.x >  maxX) this.v.x = -1 * ax;
    if (p.x < -maxX) this.v.x =  1 * ax;
    
    if (p.z >  maxZ) this.v.z = -1 * az;
    if (p.z < -maxZ) this.v.z =  1 * az;
  }
  
}