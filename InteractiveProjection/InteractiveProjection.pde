float scale = 1.0f;
float angleX = 0;
float angleY = 0;
float rotationFactor = PI/48;

void settings() {
  size(1000, 1000, P2D);
}

void setup() {}

void draw() { 
  background(255, 255, 255);
  My3DPoint eye = new My3DPoint(0, 0, -5000);
  My3DPoint origin = new My3DPoint(0, 0, 0);
  My3DBox input3DBox = new My3DBox(origin, 100, 150, 300);
 
   // scale
  float[][] scaleM = scaleMatrix(scale, scale, scale);
  input3DBox = transformBox(input3DBox, scaleM);
  
  // rotation
  float[][] rotX = rotateXMatrix(angleX);
  float[][] rotY = rotateYMatrix(angleY);
  input3DBox = transformBox(input3DBox, rotX);
  input3DBox = transformBox(input3DBox, rotY);
  
  //translation
  float[][] translation = translationMatrix(200, 200, 0);
  input3DBox = transformBox(input3DBox, translation);
 
  projectBox(eye, input3DBox).render();
}

void mouseDragged() {
  if (pmouseY < mouseY) {
    scale *= 1.10;
  } else {
    scale /= 1.10;
  }
}

void keyPressed() {
  if (key == CODED) { // Special keys
     switch (keyCode) {
       case UP:
         angleX -= rotationFactor;
         break;
       case DOWN:
         angleX += rotationFactor;
         break;
       case LEFT:
         angleY += rotationFactor;
         break;
       case RIGHT:
         angleY -= rotationFactor;
         break;
       default: break;
     }
  }
}

My2DPoint projectPoint(My3DPoint eye, My3DPoint p) {
  float d = -p.z/eye.z + 1;
  return new My2DPoint((p.x-eye.x)/d, (p.y-eye.y)/d);
}

My2DBox projectBox (My3DPoint eye, My3DBox box) { 
  My2DPoint[] p = new My2DPoint[8];
  for (int i=0; i<8; ++i)
    p[i] = projectPoint(eye, box.p[i]);
  
  return new My2DBox(p);
}