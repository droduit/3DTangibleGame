import processing.video.*;

class PlayState extends State {
  private final String name = "PlayState";
  private final boolean isPopup = false;

  private Movie cam;
  private TwoDThreeD transCoord;

  @Override
  public void onLoad() {
    cam = new Movie(app, "/home/thierry/epfl/visprog/InfoVisuel/Game/data/testvideo.mp4");
    cam.loop();
  }

  @Override
  public void onUpdate(float dt) {
      println(cam.time());
      println(cam.duration());
    if (cam.available())
        println("Yay!");
    else
        println("Nope!");

    ballMover.update(dt);
  }
  
  @Override
  public void onDraw() {
    cursor(ARROW);
    
    defaultCamera();
    plate.displayInfo();
    
    pushMatrix();
      noLights();
      statsView.drawAll();
    popMatrix();
    
    lights();
    
    if (keyPressed && keyCode == CONTROL)
      aboveCamera();
      
    plate.display();
    ballMover.display();

    image(cam, 0, 0);
  }

  @Override
  public void onLoseFocus() {
    cam.pause();
  }

  @Override
  public void onFocus() {
    cam.loop();
  }
  
  @Override
  public void mouseDragged() {
    plate.mouseDraggedEvent();
  }
  
  @Override
  public void mouseWheel(MouseEvent event) {
    plate.mouseWheelEvent(event.getCount());
  }
  
  @Override
  public void keyPressed() {
    if (key == CODED && keyCode == SHIFT)
      stateManager.push(new BuildState());
  }

  @Override
  public void onMovieRead(Movie m) {
    if (transCoord == null)
        transCoord = new TwoDThreeD(m.width, m.height);

    m.read();
    m.loadPixels();

    println("on movie read");
    List<PVector> corners = detectCorners(m);
    if (!corners.isEmpty())
      plate.rot = transCoord.get3DRotations(corners);
  }
}
