void settings() {
  fullScreen(P3D);
  
  //size(1000,1000,P3D);
}

void setup() {
  noStroke();
}

final int PLATE_X = 500;
final int PLATE_Y = 20;
final int PLATE_Z = 500;

final float MIN_SPEED = 0.2;
final float MAX_SPEED = 1.5;

final float minAngle = -PI/3;
final float maxAngle = PI/3;
final float movingVelocity = 4*(PI/180);
final float SPEED_STEP = 0.1;


float rotateX = 0;
float rotateZ = 0;
float speed = 1.0; 

void draw() {
    background(255);
    
    displayInfo();
    //noFill();
    fill(125, 125, 125);
    
    lights();
    //directionalLight(50, 100, 125, 0, -1, 0);
    //ambientLight(102, 102, 102);
    
    // camera(eyeX, eyeY, eyeZ, centerX, centerY, centerZ, upX, upY, upZ)
    camera();
    
    translate(width/2, height/2, 0);
    
    rotateX(rotateX);
    rotateZ(rotateZ);
    box(PLATE_X, PLATE_Y, PLATE_Z);
}

void displayInfo() {
  textSize(12);
  fill(0, 0, 0);
  text("RotationX : "+nf(degrees(rotateX), 0, 1), 0, 15, 0);
  text("RotationZ : "+nf(degrees(rotateZ),0,1), 130, 15, 0);
  text("Speed : "+nf(speed,0,1), 250, 15, 0);
}

void mouseWheel(MouseEvent event) {
   float e = event.getCount();
   // e = 1 roulette en bas, -1 en haut
   if(e > 0) { // Roulette vers le bas
     if(speed < MAX_SPEED) {
       speed += SPEED_STEP;
     }
   } else { // Roulette vers le haut
     if(speed >= MIN_SPEED) {
      speed -= SPEED_STEP;
     }
   }
}

void mouseDragged() {
     
    if(mouseY - pmouseY > 0) {
       if(rotateX>minAngle) rotateX -= movingVelocity* speed; else rotateX = minAngle;
     } else {
       if(rotateX<maxAngle) rotateX += movingVelocity* speed; else rotateX = maxAngle;
     }
    
     if(mouseX - pmouseX > 0) {
       if(rotateZ < maxAngle) rotateZ += movingVelocity * speed; else rotateZ = maxAngle;
     } else {
       if(rotateZ > minAngle) rotateZ -= movingVelocity * speed; else rotateZ = minAngle;
     }
     
}