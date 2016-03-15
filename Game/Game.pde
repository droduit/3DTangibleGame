Plate plate;
BallMover ballMover;

void settings() {
  size(1000, 1000, P3D);
}

void setup() {
  noStroke();
  plate = new Plate();
  ballMover = new BallMover(plate);
}

void draw() {
    background(255);
    
    //camera(width/2.0, -height/4.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
    lights();
    
    plate.displayInfo();
    plate.display();
    
    ballMover.update();
    ballMover.display();
}

void mouseWheel(MouseEvent event) {
    float e = event.getCount();
    plate.mouseWheelEvent(e);
}

void mouseDragged() {
    plate.mouseDraggedEvent();
}