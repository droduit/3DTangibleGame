
Plate plate; // === PLATEAU
final PVector plateSize = new PVector(500, 20, 500); // Position du plateau
final PVector plateRotation = new PVector(0F, 0, 0F); // Rotation du plateau

BallMover ballMover; // === BALLE

void settings() {
  fullScreen(P3D);
}

void setup() {
  noStroke();
  ballMover = new BallMover(plateSize, plateRotation);
  plate = new Plate(plateSize, plateRotation);
}

void draw() {
    background(255);
    
    plate.displayInfo();
    plate.display();
    
    ballMover.update();
    ballMover.checkEdges();
    ballMover.display();
}

void mouseWheel(MouseEvent event) {
    float e = event.getCount();
    plate.mouseWheelEvent(e);
}

void mouseDragged() {
    plate.mouseDraggedEvent();
}