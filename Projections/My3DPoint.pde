class My3DPoint {
   float x;
   float y;
   float z;
   My3DPoint(float x, float y, float z) {
     this.x = x;
     this.y = y;
     this.z = z;
  } 
}

float[] homogeneous3DPoint (My3DPoint p) {
  float[] result = {p.x, p.y, p.z , 1};
  return result;
}

 My3DPoint euclidian3DPoint (float[] a) {
      My3DPoint result = new My3DPoint(a[0]/a[3], a[1]/a[3], a[2]/a[3]);
      return result;
}