class BallMover {
  PVector location; // Position de la balle 
  PVector velocity; // Vitesse de la balle
  PVector gravity; 
  
  PVector plateSize;
  PVector plateRotation;
  
  // Physic
  final float g = 9.81;
  float normalForce = 1;
  float mu = 0.01;
  float frictionMagnitude = normalForce * mu;
  PVector friction;
  
  boolean moving = false;
  float xVelocity = 1.5;
  float zVelocity = 1.5;
  
  BallMover(PVector plateSize, PVector plateRotation) {
    this.plateSize = plateSize;
    this.plateRotation = plateRotation;
    
    location = new PVector(0, -plateSize.y - 16, 0);
    velocity = new PVector(xVelocity, 0, zVelocity);
    
    gravity = new PVector( sin(plateRotation.z) * g , 0F , cos(plateRotation.x) * g);
    
    friction = velocity.get();
    friction.mult(-1);
    friction.normalize();
    friction.mult(frictionMagnitude);
  }
  
  void trigger() {
      moving = true;
  }
  
  void update() {
     if(moving) {
       if(plateRotation.x > 0)
         velocity.x = -xVelocity;
       else if(plateRotation.x < 0) 
         velocity.x = xVelocity;
       
       
       if(plateRotation.z < 0)
         velocity.z = -zVelocity;
       else if(plateRotation.z > 0) 
         velocity.z = zVelocity;
       
       
       location.add(velocity);
       //velocity.add(gravity);
     }
  }
  
  void display() {
     fill(127);
     translate(location.x, location.y, location.z);
     sphere(25);
  }
  
  void checkEdges() {
     /*
    if (location.x >= ( (width/2.0) + (plateSize.x/2.0) ) || location.x <= ( (width/2.0) - (plateSize.x/2.0) ) ) {
      velocity.x *= -1;
    }

    if (location.y >= height || location.y <= 0) {
      velocity.y *= (-1);
    }
    */
  }
  
}