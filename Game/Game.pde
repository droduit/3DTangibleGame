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
  noStroke();
  plate = new Plate(
    new PVector(500f, 20f, 500f),
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