import processing.video.*;
import java.util.*;

Capture cam;

Filter filter;
QuadGraph graph;

PImage raw_img;
PImage hough_img;

int CAM_WIDTH = 640;
int CAM_HEIGHT = 360;
int CAM_FPS = 30;

float discretizationStepsPhi = 0.06f;
float discretizationStepsR = 2.5f;
    
int[] accumulator;
int phiDim = 0;
int rDim = 0;

void settings() {
noLoop();
    raw_img = loadImage("board4.jpg");

    size(2 * raw_img.width + raw_img.height, raw_img.height, P2D);
}
void setup() {
    filter = new Filter(raw_img); 
    
     //==============================================================================
    // dimensions of the accumulator
    phiDim = (int) (Math.PI / discretizationStepsPhi);
    rDim = (int) (((raw_img.width + raw_img.height) * 2 + 1) / discretizationStepsR);
    
    // our accumulator (with a 1 pix margin around)
    accumulator = new int[(phiDim + 2) * (rDim + 2)];
    hough_img = createImage(rDim + 2, phiDim + 2, ALPHA);
    
    graph = new QuadGraph();
}
 
int[] hough(PImage edgeImg) {
    for(int i = 0, l = accumulator.length; i < l; ++i)
        accumulator[i] = 0;  

    float[] tabSin = new float[phiDim];
    float[] tabCos = new float[phiDim];
    float ang = 0;
    float inverseR = 1.f / discretizationStepsR;
    
    for (int accPhi = 0; accPhi < phiDim; ang += discretizationStepsPhi, accPhi++) {
      // we can also pre-multiply by (1/discretizationStepsR) since we need it in the Hough loop
      tabSin[accPhi] = (float) (Math.sin(ang) * inverseR);
      tabCos[accPhi] = (float) (Math.cos(ang) * inverseR);
    }
    
    edgeImg.loadPixels();
    for (int y = 0; y < edgeImg.height; y++) {
        for (int x = 0; x < edgeImg.width; x++) {
            if (brightness(edgeImg.pixels[y * edgeImg.width + x]) != 0) {
                for (float phi = 0; phi < Math.PI; phi += discretizationStepsPhi) {
                    float r = x*cos(phi) + y*sin(phi);
                    r = r / discretizationStepsR;
                    r += (rDim-1) / 2;

                    accumulator[(int)((1+phi/discretizationStepsPhi)*(rDim + 2) + (r + 1))]++;
                }
            } 
        }
    }
    
    return accumulator;
}


void displayLines(PImage edgeImg, ArrayList<PVector> bestCandidates) {
  for (PVector v : bestCandidates) {
    //if (accumulator[idx] > 200) {
        // first, compute back the (r, phi) polar coordinates:
        float r = v.x;
        float phi = v.y;
  
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
   // }
  }
}

ArrayList<PVector> getBestCandidates(int[] accumulator) {
  ArrayList<Integer> bestCandidates = new ArrayList();

  // only search around lines with more than this amount of votes // (to be adapted to your image)
  int minVotes = 200;
  
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
  
  // On a besoin d'une liste de vecteurs pour les intersections
  ArrayList<PVector> accBest = new ArrayList();
  
  for(int i = 0; i< min(6, bestCandidates.size()); i++) {
    int idx = bestCandidates.get(i);
    
    int accPhi = (int) (idx / (rDim + 2)) - 1;
    int accR = idx - (accPhi + 1) * (rDim + 2) - 1;
    float r = (accR - (rDim - 1) * 0.5f) * discretizationStepsR;
    float phi = accPhi * discretizationStepsPhi;
        
    accBest.add(new PVector(r, phi));
  }
  
  return accBest;
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

PImage displayAccumulator(int[] accumulator) {
    for (int i = 0, l = accumulator.length; i < l; i++)
      hough_img.pixels[i] = color(min(255, accumulator[i]), 255);

    hough_img.updatePixels();

    return hough_img;
}

PVector intersection(PVector v1, PVector v2) {
  float d = cos(v2.y)*sin(v1.y) - cos(v1.y)*sin(v2.y);
  float x = ( v2.x*sin(v1.y) - v1.x*sin(v2.y))/d;
  float y = (-v2.x*cos(v1.y) + v1.x*cos(v2.y))/d; 
  return new PVector(x,y);
}

ArrayList<PVector> getIntersections(List<PVector> lines) {
  ArrayList<PVector> intersections = new ArrayList<PVector>();
  
  for (int i = 0; i < lines.size() - 1; i++) {
    PVector line1 = lines.get(i);
    
    for (int j = i + 1; j < lines.size(); j++) {
      PVector line2 = lines.get(j);
      
      // calcul l'intersection et l'ajoute aux "intersections"
      PVector v = intersection(line1, line2);
      intersections.add(v);
      
      fill(255, 128, 0);
      ellipse(v.x, v.y, 10, 10);
    }
  }
  return intersections;
}

void displayQuads(ArrayList<PVector> lines, List<int[]> quads) {
  for (int[] quad : quads) {
    PVector l1 = lines.get(quad[0]);
    PVector l2 = lines.get(quad[1]);
    PVector l3 = lines.get(quad[2]);
    PVector l4 = lines.get(quad[3]);
    // (intersection() is a simplified version of the
    // intersections() method you wrote last week, that simply
    // return the coordinates of the intersection between 2 lines)
    PVector c12 = intersection(l1, l2);
    PVector c23 = intersection(l2, l3);
    PVector c34 = intersection(l3, l4);
    PVector c41 = intersection(l4, l1);
    // Choose a random, semi-transparent colour
    Random random = new Random();
    fill(color(min(255, random.nextInt(300)),
    min(255, random.nextInt(300)),
    min(255, random.nextInt(300)), 50));
    quad(c12.x,c12.y,c23.x,c23.y,c34.x,c34.y,c41.x,c41.y);
  }  
}

void draw() {
    background(color(0,0,0));
    
    /*
    if(cam.available() == true) {
      cam.read();
    }
    
    raw_img = cam.get();
    */
    
    filter.threshold(raw_img);
    filter.gaussian(filter.getFilteredImg());
    filter.sobel(filter.getGaussImg());

    // image(filter.getFilteredImg(), CAM_WIDTH, 0, CAM_WIDTH, CAM_HEIGHT);
    // image(filter.getGaussImg(), 0, CAM_HEIGHT, CAM_WIDTH, CAM_HEIGHT);

    PImage edgeImg = filter.getSobelImg();
    int[] accumulator = hough(edgeImg);
    displayAccumulator(accumulator);
    
    ArrayList<PVector> lines = getBestCandidates(accumulator);
    // displayLines(edgeImg, lines);
    // getIntersections(lines);
    
    graph.build(lines, width, height);
    List<int[]> quads = graph.filter(graph.findCycles());
    ArrayList<PVector> selectedLines = new ArrayList<PVector>();
    for (int lineIndex : quads.get(0))
        selectedLines.add(lines.get(lineIndex));

    image(raw_img, 0, 0);
    displayQuads(lines, quads);
    // displayLines(edgeImg, selectedLines);
    // getIntersections(selectedLines);

    noStroke();
    fill(color(0));
    rect(raw_img.width, 0, raw_img.width + raw_img.height, raw_img.height);
    
    image(hough_img, raw_img.width, 0, raw_img.height, raw_img.height);
    image(filter.getSobelImg(), raw_img.width + raw_img.height, 0);
    println(frameRate);
}
