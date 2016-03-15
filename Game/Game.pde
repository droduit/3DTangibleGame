
Plate plate; // === PLATEAU
final PVector size = new PVector(500, 20, 500); // Position du plateau
final PVector plateRotation = new PVector(0F, 0, 0F); // Rotation du plateau

BallMover ballMover; // === BALLE

void settings() {
  //fullScreen(P3D);
  size(1000, 1000, P3D);
}

void setup() {
  noStroke();
  plate = new Plate(size, plateRotation);
  ballMover = new BallMover(plate);
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