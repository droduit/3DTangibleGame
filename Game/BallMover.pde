class BallMover {
  PVector location; // Position de la balle 
  PVector velocity; // Vitesse de la balle
  
  PVector plateSize;
  PVector plateRotate;
  
  BallMover(PVector plateSize, PVector plateRotate) {
    this.plateSize = plateSize;
    this.plateRotate = plateRotate;
    
    location = new PVector(0, 0, 0);
    velocity = new PVector(2.5, 5, 0);
  }
  
  void update() {
     location.add(velocity); 
  }
  
  void display() {
     stroke(0);
     fill(127);
     translate(location.x, location.y, 0);
     sphere(25);
  }
  
  void checkEdges() {
    
  }
  
}