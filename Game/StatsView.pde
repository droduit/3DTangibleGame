import java.text.DecimalFormat;

class StatsView {
  private final Plate plate; 
  BallMover ballMover;
  
  private float ratio = 0f; 
  private final int margin = 15; // Marge entre l'extrémité du ruban et des éléments
  
  // Ruban d'affichage
  private PGraphics bg; 
  private int bgPosY = height-HEIGHT;
  private color bgColor = color(230,226,175,100);
  public static final int HEIGHT = 250; // Hauteur de la zone d'affichage. Toutes les autres tailles s'adaptent

  // Zone d'affichage de la vue de dessus
  private PGraphics topView; 
  private final color topViewColor = color(6,101,130,100);
  private final int topViewSize = HEIGHT-margin; // Taille de la zone d'affiche de la vue de dessus
  private final color ballColor = color(220, 20, 20,100);
  private final color obstaclesColor = color(255,255,255, 100);
  
  // Score Board
  private PGraphics scoreBoard;
  private final int sbWidth = 150;
  private final color sbColor = color(255,255,255, 100);
  private final PVector sbPos;
  private final int textSize = 14;
  private final DecimalFormat numberFormat = new DecimalFormat("#0.000");
  private float lastScore = 0f;
  private float totalScore = 0f;
  
  // Bar Chart
  private PGraphics barChart;
  private final HScrollbar objScrollBar;
  private PGraphics scrollBar;
  private final int scrollBarHeight = 20;
  private final PVector bcPos;
  private final PVector bcSize;
  private final color bgBarChart = color(255,255,255,80);
  
  
  public StatsView(Plate plate, BallMover ballMover) {
    
     this.plate = plate;
     this.ballMover = ballMover;
     
     bg = createGraphics(width, HEIGHT, P2D);
     drawBg();
     
     sbPos = new PVector(margin/2+topViewSize+margin, margin/2);
     scoreBoard = createGraphics(sbWidth, HEIGHT-margin, P2D);
     
     topView = createGraphics(topViewSize, topViewSize, P2D);
     
     bcSize = new PVector(width-(3*margin+sbWidth+topViewSize), HEIGHT-margin-scrollBarHeight);
     bcPos = new PVector(sbPos.x+sbWidth+margin, bgPosY+margin/2);
     barChart = createGraphics((int)bcSize.x, (int)bcSize.y, P2D);
     objScrollBar = new HScrollbar(bcSize.x, scrollBarHeight);
     scrollBar = objScrollBar.getGraphics();
     
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
    float ballRadius = BALL_RADIUS * ratio ;
    float posX = mapFromPlateToTopView(ballPos.x, 0, 'x');
    float posZ = mapFromPlateToTopView(ballPos.z, 0, 'z');
    topView.ellipse(posX, posZ, ballRadius, ballRadius);
    
    // Obstacles
    topView.fill(obstaclesColor);
    float oPosX, oPosY, oSize;
    oSize = CYLINDER.radius * ratio * 2f;
    for(PVector o : plate.getObstacles()) {
      oPosX = mapFromPlateToTopView(o.x, 0, 'x'); 
      oPosY = mapFromPlateToTopView(o.y, 0, 'z');
    
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
         translate(sbPos.x + margin, bgPosY + sbPos.y + textSize + margin);
         scoreBoard.beginDraw();
         scoreBoard.background(sbColor);
         scoreBoard.fill(color(0,0,0));
         text(
            "Total score :\n" + numberFormat.format(totalScore) + "\n\n" +
            "Velocity :\n" + numberFormat.format(ballVelocity().mag()) + "\n\n" +
            "Last score :\n" + numberFormat.format(lastScore)
         , 0, 0);
         scoreBoard.endDraw();
       popMatrix();
     popStyle();
  }
  
  private void drawBarChart() {
     barChart.beginDraw();
     barChart.background(bgBarChart);
     barChart.endDraw();
  }
  
  private void drawScrollBar() {
    objScrollBar.update();
    scrollBar = objScrollBar.getGraphics(); 
  }
  
  public void drawAll() {
     pushMatrix();
       drawScore();
       drawTopView();
       drawBarChart();
       drawScrollBar();
       
       image(bg, 0, bgPosY);
       image(topView, margin/2, bgPosY+margin/2);
       image(scoreBoard, sbPos.x, bgPosY+sbPos.y);
       image(barChart, bcPos.x, bcPos.y);
       image(scrollBar, bcPos.x, bcPos.y+bcSize.y);
     popMatrix();
  }
  
  /**
  * @param type Type de score (e = edge, o = obstacle)
  **/
  public void addScore(char type) {
    float v = ballVelocity().mag();
    this.lastScore = (type=='e') ? -v : v;
    this.totalScore += lastScore;
    this.totalScore = max(0, totalScore);
  }
  
  public PVector ballVelocity() {
     PVector v = ballMover.getVelocity();
     PVector formattedVelocity = v.copy();
     if(v.mag() < 0.32f)
       formattedVelocity = new PVector(0f, 0f, 0f);
       
     return formattedVelocity; 
  }
  
}