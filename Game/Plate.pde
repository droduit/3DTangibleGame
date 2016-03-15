class Plate {
  // ==== PLATEAU
  PVector size; // Position du plateau
  PVector rot; // Rotation du plateau
  
  final float minAngle = -PI/3; // Angle minimum du plateau
  final float maxAngle = PI/3; // Angle maximum du plateau
  final float movingVelocity = 2*(PI/180); // Vitesse de mouvement du plateau
  
  float speed = 1.0; // Vitesse affichée au départ
  final float MIN_SPEED = 0.2; // Vitesse min de mouvement du plateau
  final float MAX_SPEED = 1.5; // Vitesse max de mouvement du plateau
  final float SPEED_STEP = 0.1; // Increase step de la vitesse de mouvement


  Plate(PVector size, PVector rot) {
    this.size = size;
    this.rot = rot;
  }
  
  void display() {
    fill(125, 125, 125);
    
    lights();
    //directionalLight(50, 100, 125, 0, -1, 0);
    ambientLight(120, 102, 102);
    
    // camera(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ)
    camera();
    
    translate(width/2, height/2, 0);
    
    rotateX(rot.x);
    rotateZ(rot.z);
    box(size.x, size.y, size.z);
  }
  
  /**
  Affiche les informations speed, rotationX,Y en haut de la fenetre
  */
  void displayInfo() {
    textSize(12);
    fill(0, 0, 0);
    text("RotationX : "+nf(degrees(rot.x), 0, 1), 0, 15, 0);
    text("RotationZ : "+nf(degrees(rot.z),0,1), 130, 15, 0);
    text("Speed : "+nf(speed,0,1), 250, 15, 0);
  }
  
  void mouseWheelEvent(float e) {
     // e = 1 roulette en bas, -1 en haut
     if(e > 0) { // Roulette vers le bas
       if(speed < MAX_SPEED) speed += SPEED_STEP;
     } else { // Roulette vers le haut
       if(speed >= MIN_SPEED) speed -= SPEED_STEP;
     }
  }

  void mouseDraggedEvent() {
    int dy = -Utils.clamp(mouseY - pmouseY, -1, 1);
    int dx =  Utils.clamp(mouseX - pmouseX, -1, 1);
    
    rot.x = Utils.clamp(
      rot.x + dy * movingVelocity * speed,
      minAngle, maxAngle
    );
    
    rot.z = Utils.clamp(
      rot.z + dx * movingVelocity * speed,
      minAngle, maxAngle
    );
  }

}