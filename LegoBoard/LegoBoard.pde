import processing.video.*;
import java.util.*;

Capture cam;

Filter filter;

PImage raw_img;
PGraphics filtered_img;
PGraphics gauss_img;
PGraphics sobel_img;
PGraphics sobel_threshold_img;
PImage houghImg;

int CAM_WIDTH = 640;
int CAM_HEIGHT = 480;
int CAM_FPS = 30;

float discretizationStepsPhi = 0.06f;
float discretizationStepsR = 2.5f;
    
int[] accumulator;
int phiDim = 0;
int rDim = 0;

void settings() {
    size(2*CAM_WIDTH, 2*CAM_HEIGHT, P2D);
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
  
    //raw_img = loadImage("data/board1.jpg");
    filter = new Filter(raw_img); 
    
     //==============================================================================
    // dimensions of the accumulator
    phiDim = (int) (Math.PI / discretizationStepsPhi);
    rDim = (int) (((raw_img.width + raw_img.height) * 2 + 1) / discretizationStepsR);
    
    // our accumulator (with a 1 pix margin around)
    accumulator = new int[(phiDim + 2) * (rDim + 2)];
}
 
void hough(PImage edgeImg) {
    
    for(int i = 0; i < accumulator.length; ++i) {
      accumulator[i] = 0;  
    }
    
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
                  float r = x*cos(phi) + y*sin(phi);
                  r = r / discretizationStepsR;
                  r += (rDim-1) / 2;
                  accumulator[(int)((1+phi/discretizationStepsPhi)*(rDim + 2) + (r + 1))]++;
                }
            } 
        }
    }
    
    houghImg = createImage(rDim + 2, phiDim + 2, ALPHA);
    for (int i = 0; i < accumulator.length; i++) {
      houghImg.pixels[i] = color(min(255, accumulator[i]));
    }
    // You may want to resize the accumulator to make it easier to see:
    houghImg.resize(400, 400);
    houghImg.updatePixels(); 
    
    for (int idx = 0; idx < accumulator.length; idx++) {
      if (accumulator[idx] > 200) {
        // first, compute back the (r, phi) polar coordinates:
        int accPhi = (int) (idx / (rDim + 2)) - 1;
        int accR = idx - (accPhi + 1) * (rDim + 2) - 1;
        float r = (accR - (rDim - 1) * 0.5f) * discretizationStepsR;
        float phi = accPhi * discretizationStepsPhi;
        
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
          if (x1 > 0)  line(x0, y0, x1, y1);
          else if (y2 > 0)  line(x0, y0, x2, y2);
          else line(x0, y0, x3, y3);
        } else {
          if (x1 > 0) {
            if (y2 > 0) line(x1, y1, x2, y2);
            else line(x1, y1, x3, y3);
          } else
            line(x2, y2, x3, y3);
        }
      }
    }
    
    
    ArrayList<Integer> bestCandidates = new ArrayList();
    
    // only search around lines with more than this amount of votes // (to be adapted to your image)
    int minVotes = 200;
    
    for(int i=0; i<accumulator.length; ++i) {
      if(accumulator[i] > minVotes) 
        bestCandidates.add(i);
    }
    
    // Taille de la région ou l'on cherche un maximum local
    int neighbourhood = 10;
    
     for(int accR = 0; accR < rDim; accR++) {
    
    for(int accPhi = 0; accPhi < phiDim; accPhi++) {
      // Calcul l'index courant dans l'accumulateur
      int idx = (accPhi + 1) * (rDim + 2) + accR + 1;
      
      if(accumulator[idx] > minVotes) {
        boolean bestCandidate=true;
        
        for(int dPhi=-neighbourhood/2; dPhi < neighbourhood/2+1; dPhi++) {
          if(accPhi+dPhi < 0 || accPhi+dPhi >= phiDim)
            continue;
          
          for(int dR=-neighbourhood/2; dR < neighbourhood/2 +1; dR++) {
            // Si on est pas en dehors de l'image
            if (accR+dR < 0 || accR+dR >= rDim)
              continue;
              
            int neighbourIdx = (accPhi + dPhi + 1) * (rDim + 2) + accR + dR + 1;
            
            // l'idx actuel n'est pas un maximum local bestCandidate=false;
            if(accumulator[idx] < accumulator[neighbourIdx])
              break;
            
          }
          
          if(!bestCandidate) break;
        }
        
        // l'idx actuel est un maximum local
        if(bestCandidate)
          bestCandidates.add(idx);

      }
    }
  }
  
  Collections.sort(bestCandidates, new HoughComparator(accumulator));
}

class HoughComparator implements java.util.Comparator<Integer> {
  int[] accumulator;
  
  public HoughComparator(int[] accumulator) {
    this.accumulator = accumulator;
  }
  
  public int compare(Integer l1, Integer l2) {
    if (accumulator[l1] > accumulator[l2] || (accumulator[l1] == accumulator[l2] && l1 < l2)) 
      return -1;
    
    return 1;
  }
}

PImage displayAccumulator(int[] accumulator, int rDim, int phiDim) {
    PImage houghImg = createImage(rDim + 2, phiDim + 2, ALPHA);
    for (int i = 0; i < accumulator.length; i++) {
      houghImg.pixels[i] = color(min(255, accumulator[i]));
    }
    // You may want to resize the accumulator to make it easier to see:
    houghImg.resize(400, 400);
    houghImg.updatePixels(); 
    return houghImg;
}


ArrayList<PVector> getIntersections(List<PVector> lines) {
  ArrayList<PVector> intersections = new ArrayList<PVector>();
  
  for (int i = 0; i < lines.size() - 1; i++) {
    PVector line1 = lines.get(i);
    
    for (int j = i + 1; j < lines.size(); j++) {
      PVector line2 = lines.get(j);
      
      // calcul l'intersection et l'ajoute aux "intersections"
      float d = cos(line2.y)*sin(line1.y) - cos(line1.y)*sin(line2.y);
      float x = ( line2.x*sin(line1.y) - line1.x*sin(line2.y))/d;
      float y = (-line2.x*cos(line1.y) + line1.x*cos(line2.y))/d;

      fill(255, 128, 0);
      ellipse(x, y, 10, 10);
    }
  }
  return intersections;
}


void draw() {
    background(color(0,0,0));
    
    if(cam.available() == true) {
      cam.read();
    }
    
    raw_img = cam.get();
    
    filter.threshold(raw_img);
    filter.gaussian(filter.getFilteredImg());
    filter.sobel(filter.getGaussImg());

    image(filter.getRawImg(), 0, 0, CAM_WIDTH, CAM_HEIGHT);
    image(filter.getFilteredImg(), CAM_WIDTH, 0, CAM_WIDTH, CAM_HEIGHT);
    image(filter.getGaussImg(), 0, CAM_HEIGHT, CAM_WIDTH, CAM_HEIGHT);
    image(filter.getSobelThresholdImg(), CAM_WIDTH, CAM_HEIGHT, CAM_WIDTH, CAM_HEIGHT);

    
    hough(filter.getSobelImg().copy());
    image(houghImg, 0,0,CAM_WIDTH, CAM_HEIGHT);

    
    println(frameRate);
}