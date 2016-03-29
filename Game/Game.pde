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
    lights();
    
    plate.displayInfo();
    plate.display();
    
    if(!plate.isShiftMode()) {
      ballMover.update();
      cursor(ARROW);
    } else {
        cursor(plate.isInPlate(mouseX, mouseY) ? CROSS : ARROW);
    }
    
    ballMover.display();
}

void mouseWheel(MouseEvent event) {
    float e = event.getCount();
    plate.mouseWheelEvent(e);
}

void mouseDragged() {
  plate.mouseDraggedEvent();
}

void mousePressed() {
  if(mouseButton == LEFT) {
    if(plate.isShiftMode())
      plate.addObstacle();
  }
}

void keyPressed() {
  if(key == CODED) {
    if(keyCode == SHIFT) 
       plate.shiftMode(true);
  }
}

void keyReleased() {
  if(key == CODED) {
     if(keyCode == SHIFT)
        plate.shiftMode(false);
  }
}