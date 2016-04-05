
float[][]  rotateXMatrix(float angle) {
  return(new float[][] {{1, 0 , 0 , 0},
                        {0, cos(angle), sin(angle) , 0},
                        {0, -sin(angle) , cos(angle) , 0},
                        {0, 0 , 0 , 1}});
}
float[][] rotateYMatrix(float angle) {
  return(new float[][] {{cos(angle), 0, -sin(angle) , 0},
                        {0, 1 , 0 , 0},
                        {sin(angle), 0 , cos(angle) , 0},
                        {0, 0 , 0 , 1}});
}
float[][] rotateZMatrix(float angle) {  
  return(new float[][] {{cos(angle), sin(angle), 0, 0},
                        {-sin(angle) , cos(angle), 0, 0},
                        {0, 0 , 1 , 0},
                        {0, 0 , 0 , 1}});

}
float[][] scaleMatrix(float x, float y, float z) {
  return(new float[][] {{x, 0, 0, 0},
                        {0, y, 0, 0},
                        {0, 0, z, 0},
                        {0, 0, 0, 1}});
}
float[][] translationMatrix(float x, float y, float z) {
  return(new float[][] {{1, 0, 0, x},
                        {0, 1, 0, y},
                        {0, 0, 1, z},
                        {0, 0, 0, 1}});
}

float[] matrixProduct(float[][] a, float[] b) {
  float[] p = new float[4];
  
  for (int i = 0; i < 4; ++i)
     p[i] = a[i][0]*b[0] 
          + a[i][1]*b[1] 
          + a[i][2]*b[2]
          + a[i][3]*b[3];
  
   return(p);
}