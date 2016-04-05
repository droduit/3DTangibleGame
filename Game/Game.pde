StateManager stateManager = new StateManager();

// Settings doit avoir été exécuté avant d'instancer plate et ballMover
Plate plate = null;
BallMover ballMover = null;

int lastTick = 0;

void settings() {
  size(1000, 1000, P3D);
}

void setup() {
  noStroke();
  plate = new Plate(
    new PVector(500f, 20f, 500f),
    new PVector(0f, 0f, 0f),
    new PVector(1000/2f, 1000/2f, 0f)
  );
  ballMover = new BallMover(plate);
  stateManager.push(new PlayState());
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