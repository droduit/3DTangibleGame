final PVector PLATE_LOCATION = new PVector(500, 20, 500);
final PVector PLATE_ROTATE = new PVector(0F, 0, 0F);

final float minAngle = -PI/3;
final float maxAngle = PI/3;
final float movingVelocity = 2*(PI/180);

float speed = 1.0; 
final float MIN_SPEED = 0.2;
final float MAX_SPEED = 1.5;
final float SPEED_STEP = 0.1;


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
    
    rotateX(PLATE_ROTATE.x);
    rotateZ(PLATE_ROTATE.z);
    box(PLATE_LOCATION.x, PLATE_LOCATION.y, PLATE_LOCATION.z);
    
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
  text("RotationX : "+nf(degrees(PLATE_ROTATE.x), 0, 1), 0, 15, 0);
  text("RotationZ : "+nf(degrees(PLATE_ROTATE.z),0,1), 130, 15, 0);
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
       if(PLATE_ROTATE.x>minAngle) PLATE_ROTATE.x -= movingVelocity* speed; else PLATE_ROTATE.x = minAngle;
     } else {
       if(PLATE_ROTATE.x<maxAngle) PLATE_ROTATE.x += movingVelocity* speed; else PLATE_ROTATE.x = maxAngle;
     }
    
     if(mouseX - pmouseX > 0) {
       if(PLATE_ROTATE.z < maxAngle) PLATE_ROTATE.z += movingVelocity * speed; else PLATE_ROTATE.z = maxAngle;
     } else {
       if(PLATE_ROTATE.z > minAngle) PLATE_ROTATE.z -= movingVelocity * speed; else PLATE_ROTATE.z = minAngle;
     }
     
}