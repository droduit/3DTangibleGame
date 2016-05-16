import processing.video.*;
Capture cam;
PImage raw_img;
PImage filtered_img;
PImage gauss_img;
PImage sobel_img;

float BRIGHTNESS_LOWER_BOUND =  30.0f;
float BRIGHTNESS_UPPER_BOUND = 200.0f;

float SATURATION_LOWER_BOUND = 125.0f;
float SATURATION_UPPER_BOUND = 255.0f;

float GREEN_HUE_LOWER_BOUND = 100.0f;
float GREEN_HUE_UPPER_BOUND = 139.0f;

int CAM_WIDTH = 640;
int CAM_HEIGHT = 480;
int CAM_FPS = 30;

void settings() {
  size(2*CAM_WIDTH, 2*CAM_HEIGHT);
}
void setup() {
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    cam = new Capture(this, CAM_WIDTH, CAM_HEIGHT, CAM_FPS);
    cam.start();
  }
  
  do {
    cam.read();
    raw_img = cam.get();
  } while (raw_img.width == 0 || raw_img.height == 0);
  
  println(raw_img.width, raw_img.height);
  filtered_img = createImage(raw_img.width, raw_img.height, ALPHA);
  gauss_img = createImage(raw_img.width, raw_img.height, ALPHA);
  sobel_img = createImage(raw_img.width, raw_img.height, ALPHA);
}

void hough(PImage edgeImg) {
    float discretizationStepsPhi = 0.06f;
    float discretizationStepsR = 2.5f;
  
    //==============================================================================
    // dimensions of the accumulator
    int phiDim = (int) (Math.PI / discretizationStepsPhi);
    int rDim = (int) (((edgeImg.width + edgeImg.height) * 2 + 1) / discretizationStepsR);
    // our accumulator (with a 1 pix margin around)
    int[] accumulator = new int[(phiDim + 2) * (rDim + 2)];
    // Fill the accumulator: on edge points (ie, white pixels of the edge // image), store all possible (r, phi) pairs describing lines going // through the point.
    for (int y = 0; y < edgeImg.height; y++) {
        for (int x = 0; x < edgeImg.width; x++) {
            // Are we on an edge?
            if (brightness(edgeImg.pixels[y * edgeImg.width + x]) != 0) {
                // ...determine here all the lines (r, phi) passing through
                // pixel (x,y), convert (r,phi) to coordinates in the
                // accumulator, and increment accordingly the accumulator.
                // Be careful: r may be negative, so you may want to center onto
                // the accumulator with something like: r += (rDim - 1) / 2
                for (float phi = 0; phi < Math.PI; phi += discretizationStepsPhi) {
                  float r = x * cos(phi) + y * sin(phi);
                  r = r / discretizationStepsR;
                  r += (rDim - 1)/2;
                  accumulator[(int)((1+phi/discretizationStepsPhi)*(rDim + 2) + (r + 1))]++;
                }
            } 
        }
    }
}

PImage filter_threshold(PImage img, float lbBright, float upBright, float lbSat, float upSat, float lbHue, float upHue) {
  PImage result = filtered_img;
  color black = color(0, 0, 0);
  
  result.loadPixels();
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
  
  result.updatePixels();
  return result;
}

PImage gaussian(PImage img) {
  float[][] kernel = { { 9, 12, 9 },
                       { 12, 15, 12 },
                       { 9, 12, 9 }};
                       
  float weight = 99.f;
  // create a greyscale image (type: ALPHA) for output
  PImage result = gauss_img;
  result.loadPixels();
  
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

  result.updatePixels();
  return result;
}

PImage sobel(PImage img) {
    float[][] hKernel = { { 0, 1, 0 },
                          { 0, 0, 0 },
                          { 0, -1, 0 } };
    float[][] vKernel = { { 0, 0, 0 },
                          { 1, 0, -1 },
                          { 0, 0, 0 } };
    PImage result = sobel_img;
    result.loadPixels();
    
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
    
    result.updatePixels();
    return result;
}

void draw() {
  background(color(0,0,0));
  if (cam.available() == true) {
    cam.read();
  }
  raw_img = cam.get();
  
  sobel(
    filter_threshold(raw_img, 
    BRIGHTNESS_LOWER_BOUND, BRIGHTNESS_UPPER_BOUND, // Brightness
    SATURATION_LOWER_BOUND, SATURATION_UPPER_BOUND, // Saturation
    GREEN_HUE_LOWER_BOUND, GREEN_HUE_UPPER_BOUND)   // Hue
  );
  
  image(raw_img, 0, 0);
  image(filtered_img, CAM_WIDTH, 0);
  image(sobel_img, CAM_WIDTH/2, CAM_HEIGHT);
}