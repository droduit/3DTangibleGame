import processing.video.*;

final int SCREEN_WIDTH = 1580;
final int SCREEN_HEIGHT = 950;

StateManager stateManager = new StateManager();

// Settings doit avoir été exécuté avant d'instancer plate et ballMover
Plate plate = null;
BallMover ballMover = null;
StatsView statsView = null;

Movie mov;

int lastTick = 0;

void settings() {
  size(SCREEN_WIDTH, SCREEN_HEIGHT, P3D);
}

void setup() {
  noStroke();
  plate = new Plate(
    new PVector(450f, 20f, 450f),
    new PVector(0f, 0f, 0f),
    new PVector(SCREEN_WIDTH / 2.0, SCREEN_HEIGHT / 2.0, 0f)
  );
  ballMover = new BallMover(plate);
  stateManager.push(new PlayState());
  statsView = new StatsView();
  
  /*
  mov = new Movie(this, "video.mp4");
  mov.loop();
  */
}

void draw() {
    /*
    mov.read();
    mov.updatePixels();
    
    PImage resized = mov.get();
    resized.resize(0,200);
    image(resized, 0,0);
    
    
    PImage sob = ...;
  
    // A faire :
    ArrayList<PVector> lines = hough(sob, nLines);
    List<PVector> corners = quads(lines);
    
    if(!corners.isEmpty()) {
      rot = d.get3DRotations(corners);
    }
    */
    
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