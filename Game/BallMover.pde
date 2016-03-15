class BallMover {
  // Physic
  final float g = 9.81;
  final float normalForce = 1;
  final float mu = 0.01;
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
    PVector gf = new PVector(-sin(plate.rot.z), 0, -sin(plate.rot.x));
    PVector ff = v.get();
    
    ff.mult(-1);
    ff.normalize();
    ff.mult(fm);
    
    PVector a = gf.add(ff);
    this.v.add(a);
    
    this.p.add(v);
  }
  
  void display() {
     fill(127);
     translate(p.x, p.y, p.z);
     sphere(25);
  }
  
  void checkEdges() {
     /*
    if (location.x >= ( (width/2.0) + (size.x/2.0) ) || location.x <= ( (width/2.0) - (size.x/2.0) ) ) {
      velocity.x *= -1;
    }

    if (location.y >= height || location.y <= 0) {
      velocity.y *= (-1);
    }
    */
  }
  
}