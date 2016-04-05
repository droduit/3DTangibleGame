void settings() {
   size(1000,1000,P3D); 
}
void setup() {

}

int rectWidth = 100;
int rectHeight = 150;
float scalVal = 1F;
float XAngle = 0;
float YAngle = 0;

void draw() {
  background(255,255,255);
   My3DPoint eye = new My3DPoint(0,0,-2000);
   My3DPoint origin = new My3DPoint(width/2-rectWidth/2,height/2,0-rectHeight/2);
   My3DBox input3DBox = new My3DBox(origin, rectWidth, rectHeight, 300);
  
  float[][] scale = scaleMatrix(scalVal,scalVal,scalVal);
  float[][] translate = translationMatrix(200,200,0);
  float[][] rotateX = rotateXMatrix(XAngle);
  float[][] rotateY = rotateYMatrix(YAngle);
  
  input3DBox = transformBox(input3DBox, scale);
  input3DBox = transformBox(input3DBox, rotateX);
  input3DBox = transformBox(input3DBox, rotateY);
  input3DBox = transformBox(input3DBox, translate);
  projectBox(eye, input3DBox).render();
  
  /*
  // rotated around x
  float[][] transform1 = rotateXMatrix(PI/8);
  input3DBox = transformBox(input3DBox, transform1);
  projectBox(eye, input3DBox).render();
  
  // rotated and translated
  float[][] transform2 = translationMatrix(200,200,0);
  input3DBox = transformBox(input3DBox, transform2);
  projectBox(eye, input3DBox).render();
  
  // rotated, translated, and scaled
  float[][] transform3 = scaleMatrix(2,2,2);
  input3DBox = transformBox(input3DBox, transform3);
  projectBox(eye, input3DBox).render();
  */
}

void mouseDragged() {
    scalVal += (pmouseY<mouseY) ? 0.01 : -0.01;
}

void keyPressed() {
   if(key == CODED) {
      switch(keyCode) {
         case UP: XAngle += PI/12; break;
         case DOWN : XAngle -= PI/12; break;
         
         case RIGHT : YAngle += PI/12; break;
         case LEFT : YAngle -= PI/12; break;
         
         default:
      }
   }
}

My2DPoint projectPoint(My3DPoint eye, My3DPoint p) {
    float d = (-p.z/eye.z) + 1;
    return new My2DPoint((p.x-eye.x)/d, (p.y-eye.y)/d);
}

My2DBox projectBox(My3DPoint eye, My3DBox box) {
    My2DPoint[] points = new My2DPoint[8];
    
    for(int i=0; i<box.p.length; i++) {
      points[i] = projectPoint(eye, box.p[i]);
    }
    
    return new My2DBox(points);
}

float[] homogeneous3DPoint(My3DPoint p) {
   float[] result = {p.x, p.y, p.z, 1};
   return result;
}

float[][] rotateXMatrix(float angle) {
   return (new float[][] {
     {1,0,0,0},
     {0, cos(angle), sin(angle), 0},
     {0, -sin(angle), cos(angle), 0},
     {0,0,0,1}
   });
}

float[][] rotateYMatrix(float angle) {
     return (new float[][] {
     {cos(angle), 0, sin(angle), 0},
     {0,1,0,0},
     {-sin(angle), 0, cos(angle), 0},
     {0,0,0,1}
   });
}

float[][] rotateZMatrix(float angle) {
     return (new float[][] {
     {cos(angle), -sin(angle), 0,0},
     {sin(angle), cos(angle), 0,0},
     {0,0,1,0},
     {0,0,0,1}
   });
}

float[][] scaleMatrix(float x, float y, float z) {
     return (new float[][] {
     {x,0,0,0},
     {0,y,0,0},
     {0,0,z,0},
     {0,0,0,1}
   });
}

float[][] translationMatrix(float x, float y, float z) {
     return (new float[][] {
     {1,0,0,x},
     {0,1,0,y},
     {0,0,1,z},
     {0,0,0,1}
   });
}

float[] matrixProduct(float[][] a, float[] b) {
   float[] product = new float[b.length];
   for(int i=0; i<a.length; i++) {
      for(int j=0; j<a[i].length; j++) {
         product[i] += a[i][j]*b[j]; 
      }
   }
   return product;
}


My3DBox transformBox(My3DBox box, float[][] transformMatrix) {
    My3DPoint[] p = new My3DPoint[box.p.length];
    for(int i=0; i<box.p.length; i++) {
        p[i] = euclidian3DPoint(matrixProduct(transformMatrix, homogeneous3DPoint(box.p[i]) ));
    }
    return new My3DBox(p);
}

My3DPoint euclidian3DPoint(float[] a) {
   My3DPoint result = new My3DPoint(a[0]/a[3], a[1]/a[3], a[2]/a[3]);
   return result;
}