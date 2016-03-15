class BallMover {
  PVector location; // Position de la balle 
  PVector velocity; // Vitesse de la balle
  
  PVector plateSize;
  PVector plateRotation;
  
  BallMover(PVector plateSize, PVector plateRotation) {
    this.plateSize = plateSize;
    this.plateRotation = plateRotation;
    
    location = new PVector(0, -plateSize.y - 16, 0);
    velocity = new PVector(2.5, 0, 3);
  }
  
  void update() {
     location.add(velocity); 
  }
  
  void display() {
     fill(127);
     translate(location.x, location.y, 0);
     sphere(25);
  }
  
  void checkEdges() {
    if (location.x >= ( (width/2.0) + (plateSize.x/2.0) ) || location.x <= ( (width/2.0) - (plateSize.x/2.0) ) ) {
      velocity.x *= -1;
    }

    if (location.y >= height || location.y <= 0) {
      velocity.y *= (-1);
    }
  }
  
}