import java.text.DecimalFormat;

class StatsView {
  private final Plate plate; 
  BallMover ballMover;
  
  private float ratio = 0f; 
  
  // Ruban d'affichage
  private PGraphics bg; 
  private int bgPosY = height-HEIGHT;
  private color bgColor = color(230,226,175,100);
  public static final int HEIGHT = 250; // Hauteur de la zone d'affichage. Toutes les autres tailles s'adaptent

  // Zone d'affichage de la vue de dessus
  private PGraphics topView; 
  private final color topViewColor = color(6,101,130,100);
  private final int topViewPadding = 30; // Marge entre la surface de la vue de dessus et le ruban d'affichage
  private final int topViewSize = HEIGHT-topViewPadding; // Taille de la zone d'affiche de la vue de dessus
  private final color ballColor = color(220, 20, 20,100);
  private final color obstaclesColor = color(255,255,255, 100);
  
  // Score Board
  private PGraphics scoreBoard;
  private final int sbWidth = 150;
  private final int sbMargin = 20;
  private final color sbColor = color(255,255,255, 100);
  private final PVector sbPos;
  private final int textSize = 14;
  DecimalFormat numberFormat = new DecimalFormat("#0.000");
  
  
  private float lastScore = 0f;
  private float totalScore = 0f;
  
  
  
  public StatsView(Plate plate, BallMover ballMover) {
    
     this.plate = plate;
     this.ballMover = ballMover;
     
     bg = createGraphics(width, HEIGHT, P2D);
     drawBg();
     
     sbPos = new PVector(topViewPadding/2+topViewSize+sbMargin, sbMargin/2);
     scoreBoard = createGraphics(sbWidth, HEIGHT-sbMargin, P2D);
     
     topView = createGraphics(topViewSize, topViewSize, P2D);
     
     ratio = HEIGHT / plate.size.x;
  }
  
  // Surface : Ruban ---------------------------------------
  void drawBg() {
     bg.beginDraw();
     bg.background(bgColor);
     bg.endDraw();
  }
  
  // Surface : Vue de dessus ------------------------------------
  void drawTopView() {  
    topView.beginDraw();
    topView.background(topViewColor);
    topView.noStroke();
    
    // Balle
    topView.fill(ballColor);
    PVector ballPos = ballMover.getPosition().copy();
    float ballRadius = BALL_RADIUS * ratio;
    float posX = mapFromPlateToTopView(ballPos.x, 0, 'x');
    float posZ = mapFromPlateToTopView(ballPos.z, 0, 'z');
    topView.ellipse(posX, posZ, ballRadius, ballRadius);
    
    // Obstacles
    topView.fill(obstaclesColor);
    float oPosX, oPosY, oSize;
    oSize = CYLINDER.radius*2 * ratio;
    for(PVector o : plate.getObstacles()) {
      oPosX = mapFromPlateToTopView(o.x, oSize, 'x'); 
      oPosY = mapFromPlateToTopView(o.y, oSize, 'z');
    
      topView.ellipse(oPosX, oPosY, oSize, oSize);
    }
    topView.endDraw();
  }
  
  public float mapFromPlate(float value, float min, float max, char coord) {
    float size = (coord=='x') ? plate.size.x : plate.size.z;
    return map(value, -size/2F, size/2F, min, max);
  }
  
  public float mapFromPlateToTopView(float pos, float size, char coord) {
     return mapFromPlate(pos, size/2F, topViewSize-size/2F, coord);
  }
  
  // Surface : Score Board ---------------------------------
  private void drawScore() {
     pushStyle();
       scoreBoard.textSize(textSize);
       scoreBoard.textAlign(LEFT);
       pushMatrix();
         translate(sbPos.x + sbMargin, bgPosY + sbPos.y + textSize + sbMargin);
         scoreBoard.beginDraw();
         scoreBoard.background(sbColor);
         scoreBoard.fill(color(0,0,0));
         text(
            "Total score :\n" + numberFormat.format(totalScore) + "\n\n" +
            "Velocity :\n" + numberFormat.format(ballMover.getVelocity().mag()) + "\n\n" +
            "Last score :\n" + numberFormat.format(lastScore)
         , 0, 0);
         scoreBoard.endDraw();
       popMatrix();
     popStyle();
  }
  
  public void drawAll() {
     pushMatrix();
       drawScore();
       drawTopView();
       
       image(bg, 0, bgPosY);
       image(topView, topViewPadding/2, bgPosY+topViewPadding/2);
       image(scoreBoard, sbPos.x, bgPosY+sbPos.y);
     popMatrix();
  }
  
  
  public void addScore(float v) {
    this.lastScore = v;
    this.totalScore += max(0, lastScore);
  }
  
}