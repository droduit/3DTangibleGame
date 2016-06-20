import processing.video.*;

PApplet app = this;

final int SCREEN_WIDTH = 1580;
final int SCREEN_HEIGHT = 950;

StateManager stateManager = new StateManager();

// Settings doit avoir été exécuté avant d'instancer plate et ballMover
Plate plate = null;
BallMover ballMover = null;
StatsView statsView = null;

int lastTick = 0;

void settings() {
  size(SCREEN_WIDTH, SCREEN_HEIGHT, P3D);
}

void setup() {
  app = this;
  noStroke();
  
  filter = new Filter(createImage(640,380, ARGB));
  
   //==============================================================================
 // dimensions of the accumulator
  phiDim = (int) (Math.PI / discretizationStepsPhi);
   rDim = (int) (((640 + 480) * 2 + 1) / discretizationStepsR);

 // our accumulator (with a 1 pix margin around)
   accumulator = new int[(phiDim + 2) * (rDim + 2)];
   hough_img = createImage(rDim + 2, phiDim + 2, ALPHA);
  
  graph = new QuadGraph();
  
  plate = new Plate(
    new PVector(450f, 20f, 450f),
    new PVector(0f, 0f, 0f),
    new PVector(SCREEN_WIDTH / 2.0, SCREEN_HEIGHT / 2.0, 0f)
  );
  ballMover = new BallMover(plate);
  stateManager.push(new PlayState());
  statsView = new StatsView();
}

void draw() {
    background(255);
    lights();
    
    int currentTick = millis();
    float dt = (currentTick - lastTick) / 1000.0;
    
    stateManager.update(dt);
    stateManager.draw();
    
    lastTick = currentTick;
}

void mouseWheel(MouseEvent event) { stateManager.mouseWheel(event); }
void mouseDragged() { stateManager.mouseDragged(); }
void mousePressed() { stateManager.mousePressed(); }

void keyPressed() { stateManager.keyPressed(); }
void keyReleased() { stateManager.keyReleased(); }