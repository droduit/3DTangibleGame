import processing.video.*;

float BRIGHTNESS_LOWER_BOUND =  30.0f;
float BRIGHTNESS_UPPER_BOUND = 200.0f;

float SATURATION_LOWER_BOUND = 125.0f;
float SATURATION_UPPER_BOUND = 255.0f;

float GREEN_HUE_LOWER_BOUND = 110.0f;
float GREEN_HUE_UPPER_BOUND = 139.0f;

Capture cam;
PImage img;

void settings() {
  size(800, 600);
}
void setup() {
  // noLoop(); // no interactive behaviour: draw() will be called only once.
  
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    cam = new Capture(this, cameras[0]);
    cam.start();
  }
}

PImage filter_threshold(PImage img, float lbBright, float upBright, float lbSat, float upSat, float lbHue, float upHue) {
  PImage result = createImage(width, height, ALPHA); // create a new, initially transparent, ’result’ image
  color black = color(0, 0, 0);
  
  for(int i = 0; i < img.width * img.height; i++) {
    float b = brightness(img.pixels[i]);
    float s = saturation(img.pixels[i]);
    float h = hue(img.pixels[i]);
    if (b < lbBright || b > upBright ||
        s < lbSat || s > upSat ||
        h < lbHue || h > upHue) {
      result.pixels[i] = black;
    } else {
      result.pixels[i] = img.pixels[i];
    }
  }
  
  return result;
}

PImage gaussian(PImage img) {
  float[][] kernel = { { 9, 12, 9 },
                       { 12, 15, 12 },
                       { 9, 12, 9 }};
                       
  float weight = 99.f;
  // create a greyscale image (type: ALPHA) for output
  PImage result = createImage(img.width, img.height, ALPHA);
  // kernel size N = 3
  int N = 3;
    
  for (int y = N/2; y < img.height - N/2; ++y) {
    for (int x = N/2; x < img.width - N/2; ++x) {
      float sum = 0;
      for (int dy = -N/2; dy <= N/2; ++dy) {
        for (int dx = -N/2; dx <= N/2; ++dx) {
          sum += brightness(img.pixels[(x+dx) + (y+dy)*img.width]) * kernel[N/2+dx][N/2+dy]/weight; 
        }
      }
      result.pixels[y*img.width + x] = color(sum);
    }
  }

  return result;
}

PImage sobel(PImage img) {
    float[][] hKernel = { { 0, 1, 0 },
                          { 0, 0, 0 },
                          { 0, -1, 0 } };
    float[][] vKernel = { { 0, 0, 0 },
                          { 1, 0, -1 },
                          { 0, 0, 0 } };
    PImage result = createImage(img.width, img.height, ALPHA);
    // clear the image
    for (int i = 0; i < img.width * img.height; i++) {
        result.pixels[i] = color(0);
    }
    float max=0;
    float[] buffer = new float[img.width * img.height];
        
    int N = 3;
    for (int y = N/2; y < img.height - N/2; ++y) {
        for (int x = N/2; x < img.width - N/2; ++x) {
            float sum_v = 0;
            float sum_h = 0;
            for (int dy = -N/2; dy <= N/2; ++dy) {
                for (int dx = -N/2; dx <= N/2; ++dx) {
                    float brightness = brightness(img.pixels[(x+dx) + (y+dy)*img.width]);
                    sum_v += brightness * vKernel[N/2+dx][N/2+dy];
                    sum_h += brightness * hKernel[N/2+dx][N/2+dy];
                }
            }
            float sum = sqrt(pow(sum_h, 2) + pow(sum_v, 2));
            buffer[y*img.width + x] = sum;
            max = max(max, sum);
        }
    }
    
    for (int y = 2; y < img.height - 2; y++) { // Skip top and bottom edges
        for (int x = 2; x < img.width - 2; x++) { // Skip left and right
            if (buffer[y * img.width + x] > (int)(max * 0.3f)) { // 30% of the max
                result.pixels[y * img.width + x] = color(255);
            } else {
                result.pixels[y * img.width + x] = color(0);
            }
        }
    }
    return result;
}



void hough(PImage edgeImg) {
  float discretizationStepsPhi = 0.06f;
  float discretizationStepsR = 2.5f;
  
  // dimensions of the accumulator
  int phiDim = (int) (Math.PI / discretizationStepsPhi);
  int rDim = (int) (((edgeImg.width + edgeImg.height) * 2 + 1) / discretizationStepsR);
  
  // our accumulator (with a 1 pix margin around)
  int[] accumulator = new int[(phiDim + 2) * (rDim + 2)];
  
  // Fill the accumulator: on edge points (ie, white pixels of the edge
  // image), store all possible (r, phi) pairs describing lines going
  // through the point.
  float r = 0, phi = 0;
  float rMax = MIN_INT;
  for (int y = 0; y < edgeImg.height; y++) {
    for (int x = 0; x < edgeImg.width; x++) {
      // Are we on an edge?
      if (brightness(edgeImg.pixels[y * edgeImg.width + x]) != 0) {
        // ...determine here all the lines (r, phi) passing through
        // pixel (x,y), convert (r,phi) to coordinates in the
        // accumulator, and increment accordingly the accumulator.
        // Be careful: r may be negative, so you may want to center onto
        // the accumulator with something like: r += (rDim - 1) / 2
        phi = phiDim;
        
        r = (int)(x*cos(phi)+y*sin(phi));
        r += (rDim - 1) / 2.0;
        rMax = max(rMax, r);
        
        accumulator[(int)(phi * rMax + r)] += 1;
      }
    }
  }
  
  for (int idx = 0; idx < accumulator.length; idx++) {
    if (accumulator[idx] > 200) {
      // first, compute back the (r, phi) polar coordinates:
      int accPhi = (int) (idx / (rDim + 2)) - 1;
      int accR = idx - (accPhi + 1) * (rDim + 2) - 1;
      r = (accR - (rDim - 1) * 0.5f) * discretizationStepsR;
      phi = accPhi * discretizationStepsPhi;
     
      // Cartesian equation of a line: y = ax + b
      // in polar, y = (-cos(phi)/sin(phi))x + (r/sin(phi))
      // => y = 0 : x = r / cos(phi)
      // => x = 0 : y = r / sin(phi)
      // compute the intersection of this line with the 4 borders of
      // the image
      int x0 = 0;
      int y0 = (int) (r / sin(phi));
      int x1 = (int) (r / cos(phi));
      int y1 = 0;
      int x2 = edgeImg.width;
      int y2 = (int) (-cos(phi) / sin(phi) * x2 + r / sin(phi));
      int y3 = edgeImg.width;
      int x3 = (int) (-(y3 - r / sin(phi)) * (sin(phi) / cos(phi)));
    
      // Finally, plot the lines
      stroke(204,102,0);
      if (y0 > 0) {
        if (x1 > 0)        line(x0, y0, x1, y1);
        else if (y2 > 0)   line(x0, y0, x2, y2);
        else               line(x0, y0, x3, y3);
      } else {
        if (x1 > 0) {
          if (y2 > 0)      line(x1, y1, x2, y2);
          else             line(x1, y1, x3, y3);
        } else {
          line(x2, y2, x3, y3);
        }
      }
    }
  }
  
  PImage houghImg = createImage(rDim + 2, phiDim + 2, ALPHA);
  for (int i = 0; i < accumulator.length; i++) {
    houghImg.pixels[i] = color(min(255, accumulator[i]));
  }
  // You may want to resize the accumulator to make it easier to see:
  houghImg.resize(400, 400);
  houghImg.updatePixels(); 
}


void draw() {
  
  if (cam.available() == true) {
  cam.read();
  }
  img = cam.get();
  image(img, 0, 0);
  
  /*
  background(color(0,0,0));
  image(sobel(
          gaussian(
            filter_threshold(loadImage("board2.jpg"), 
            BRIGHTNESS_LOWER_BOUND, BRIGHTNESS_UPPER_BOUND, // Brightness
            SATURATION_LOWER_BOUND, SATURATION_UPPER_BOUND, // Saturation
            GREEN_HUE_LOWER_BOUND, GREEN_HUE_UPPER_BOUND)   // Hue
          )
        ), 0, 0);
   */
}