// ==== PLATEAU
final PVector P_LOCATION = new PVector(500, 20, 500); // Position du plateau
final PVector P_ROTATE = new PVector(0F, 0, 0F); // Rotation du plateau

final float minAngle = -PI/3; // Angle minimum du plateau
final float maxAngle = PI/3; // Angle maximum du plateau
final float movingVelocity = 2*(PI/180); // Vitesse de mouvement du plateau

float speed = 1.0; // Vitesse affichée au départ
final float MIN_SPEED = 0.2; // Vitesse min de mouvement du plateau
final float MAX_SPEED = 1.5; // Vitesse max de mouvement du plateau
final float SPEED_STEP = 0.1; // Increase step de la vitesse de mouvement

// === BALLE
final PVector B_LOCATION = new PVector(0, 0, 0); // Position de la balle 
final PVector B_VELOCITY = new PVector(2.5, 5, 0); // Vitesse de la balle

void settings() {
  fullScreen(P3D);
}

void setup() {
  noStroke();
}

void draw() {
    background(255);
    
    displayInfo();

    fill(125, 125, 125);
    
    lights();
    //directionalLight(50, 100, 125, 0, -1, 0);
    ambientLight(120, 102, 102);
    
    // camera(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ)
    camera();
    
    translate(width/2, height/2, 0);
    
    rotateX(P_ROTATE.x);
    rotateZ(P_ROTATE.z);
    box(P_LOCATION.x, P_LOCATION.y, P_LOCATION.z);
    
    /*
    translate(0, 0, PLATE_Z);
    sphere(20);
    */
}

/**
  Affiche les informations speed, rotationX,Y en haut de la fenetre
*/
void displayInfo() {
  textSize(12);
  fill(0, 0, 0);
  text("RotationX : "+nf(degrees(P_ROTATE.x), 0, 1), 0, 15, 0);
  text("RotationZ : "+nf(degrees(P_ROTATE.z),0,1), 130, 15, 0);
  text("Speed : "+nf(speed,0,1), 250, 15, 0);
}

void mouseWheel(MouseEvent event) {
   float e = event.getCount();
   // e = 1 roulette en bas, -1 en haut
   if(e > 0) { // Roulette vers le bas
     if(speed < MAX_SPEED) speed += SPEED_STEP;
   } else { // Roulette vers le haut
     if(speed >= MIN_SPEED) speed -= SPEED_STEP;
   }
}

void mouseDragged() {
     
    if(mouseY - pmouseY > 0) {
       if(P_ROTATE.x>minAngle) P_ROTATE.x -= movingVelocity* speed; else P_ROTATE.x = minAngle;
     } else {
       if(P_ROTATE.x<maxAngle) P_ROTATE.x += movingVelocity* speed; else P_ROTATE.x = maxAngle;
     }
    
     if(mouseX - pmouseX > 0) {
       if(P_ROTATE.z < maxAngle) P_ROTATE.z += movingVelocity * speed; else P_ROTATE.z = maxAngle;
     } else {
       if(P_ROTATE.z > minAngle) P_ROTATE.z -= movingVelocity * speed; else P_ROTATE.z = minAngle;
     }
     
}