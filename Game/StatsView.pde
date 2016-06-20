import java.text.DecimalFormat;

class StatsView {
  private final int margin = 15; // Marge entre l'extrémité du ruban et des éléments
  
  // Ruban d'affichage
  private PGraphics bg; 
  private int bgPosY = height-HEIGHT;
  private color bgColor = color(230,226,175);
  public static final int HEIGHT = 250; // Hauteur de la zone d'affichage. Toutes les autres tailles s'adaptent

  // Zone d'affichage de la vue de dessus
  private PGraphics topView; 
  private final color topViewColor = color(6,101,130);
  private final int topViewSize = HEIGHT-margin; // Taille de la zone d'affiche de la vue de dessus
  private float ratio = HEIGHT / plate.size.x;
  private final color ballColor = color(220, 20, 20);
  private final float ballRadius = BALL_RADIUS * ratio;
  private final color obstaclesColor = color(255,255,255);
  private final float obstaclesRadius = 2 * CYLINDER.radius * ratio;
  
  // Score Board
  private PGraphics scoreBoard;
  private final int sbWidth = 150;
  private final color sbColor = color(255,255,255);
  private final PVector sbPos;
  private final int textSize = 14;
  private final DecimalFormat numberFormat = new DecimalFormat("#0.000");
  private float lastScore = 0f;
  private float totalScore = 0f;
  private float maxScore = 0;
  
  // Bar Chart
  private PGraphics barChart;
  private final HScrollbar objScrollBar;
  private PGraphics scrollBar;
  private final PVector scrollBarPos;
  private final PVector scrollBarSize;
  private final int scrollBarHeight = 20;
  private final PVector bcPos;
  private final PVector bcSize;
  private final color bgBarChart = color(255,255,255);
  private final ArrayList<Float> scores = new ArrayList();
  private final color bcSqColor = color(220,20,20);
  private final int sqDefaultSize = 15; // Taille par défaut d'un carré de la bar chart
  private final int rateSavingScore = 10; // Frequence a laquelle on ajoute un score dans la bar chart
  private float sqWidth = sqDefaultSize;
  private float sqHeight = sqDefaultSize;
  private final int maxNbSquares;


  public StatsView() {
     bg = createGraphics(width, HEIGHT, P3D);
     drawBg();

     sbPos = new PVector(margin/2+topViewSize+margin, margin/2);
     scoreBoard = createGraphics(sbWidth, HEIGHT-margin, P2D);

     topView = createGraphics(topViewSize, topViewSize, P2D);

     bcSize = new PVector(width-(3*margin+sbWidth+topViewSize), HEIGHT-margin-scrollBarHeight);
     bcPos = new PVector(sbPos.x+sbWidth+margin, bgPosY+margin/2);
     barChart = createGraphics((int)bcSize.x, (int)bcSize.y, P2D);

     scrollBarPos = new PVector(bcPos.x, bcPos.y+bcSize.y);
     scrollBarSize = new PVector(bcSize.x, scrollBarHeight);
     objScrollBar = new HScrollbar(scrollBarPos.x, scrollBarPos.y, scrollBarSize.x, scrollBarSize.y);
     scrollBar = objScrollBar.getGraphics();

     maxNbSquares = (int)bcSize.y / (int)sqHeight;
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
    PVector ballPos = mapFromPlate(ballMover.getPosition());
    topView.ellipse(ballPos.x, ballPos.z, ballRadius, ballRadius);

    // Obstacles
    topView.fill(obstaclesColor);
    for(PVector obstacle : plate.getObstacles()) {
      PVector obstaclePos = mapFromPlate(new PVector(obstacle.x, 0, obstacle.y));

      topView.ellipse(obstaclePos.x, obstaclePos.z, obstaclesRadius, obstaclesRadius);
    }
    topView.endDraw();
  }

  private PVector mapFromPlate(PVector plateCoord) {
    return new PVector(
      map(plateCoord.x, -plate.size.x / 2f, plate.size.x / 2f, 0, topViewSize),
      map(plateCoord.y, -plate.size.y / 2f, plate.size.y / 2f, 0, topViewSize),
      map(plateCoord.z, -plate.size.z / 2f, plate.size.z / 2f, 0, topViewSize)
    );
  }
  
  // Surface : Score Board ---------------------------------
  private void drawScore() {
     pushStyle();
       scoreBoard.textSize(textSize);
       scoreBoard.textAlign(LEFT);
       pushMatrix();
         //translate(sbPos.x + margin, bgPosY + sbPos.y + textSize + margin);
         scoreBoard.beginDraw();
         scoreBoard.background(sbColor);
         scoreBoard.fill(0);
         scoreBoard.text(
            "Total score\n" + numberFormat.format(totalScore) + "\n\n" +
            "Velocity\n" + numberFormat.format(ballVelocity().mag()) + "\n\n" +
            "Last score\n" + numberFormat.format(lastScore).replaceAll("-", "")
         , margin, textSize + margin);
         scoreBoard.endDraw();
       popMatrix();
     popStyle();
  }
 
  
  // Surface : Bar Chart ---------------------------------
  int addScoreCounter = 0; 
  private void drawBarChart() {
    if(addScoreCounter < rateSavingScore){
      addScoreCounter++;
    } else {
      scores.add(totalScore);
      maxScore = max(maxScore, (int)totalScore);
      addScoreCounter = 0;
    }
      
     barChart.beginDraw();
     barChart.background(bgBarChart);
     barChart.stroke(255);
     barChart.fill(bcSqColor);
     
     // Largeur d'un carré de la bar char
     sqWidth = sqDefaultSize * (0.5 + objScrollBar.getPos());

      
    
     // Si le total des bars peut etre entierement contenu dans la zone dédiée à la bar chart
     if ( floor(scores.size() * sqWidth) <= bcSize.x) {
       
        // On affiche les scores du plus ancien au plus actuel
        for (int i = 0; i < floor(bcSize.x/sqWidth) + 1; i++) {
          for (int j = 0; j <= bcSize.y/sqHeight; j++) {
            if (i < scores.size() && j < scores.get(i) * maxNbSquares/maxScore)
              barChart.rect(i*sqWidth, bcSize.y - (j * sqHeight), sqWidth, sqHeight);
          }
        }

      } else { // Si les bar prennent plus d'espace que la largeur de la surface dédiée à la bar chart
        // On affiche les scores du plus actuel au plus ancien
        for (int i = 0; i < floor(bcSize.x/sqWidth) + 1; i++) {
          for (int j = 0; j*sqHeight <= bcSize.y; j++) {
            if (j < scores.get(scores.size() - (i+1)) * maxNbSquares/maxScore)
              barChart.rect(bcSize.x - ceil(sqWidth * (i+1)), bcSize.y - (j * sqHeight), sqWidth, sqHeight);
          }
        }

      }

      
      barChart.endDraw(); //<>//
  }
  
  // Surface : Scrollbar ---------------------------------
  private void drawScrollBar() {
    scrollBar = objScrollBar.getGraphics(); 
  }
  
  public void drawAll() {
       drawScore();
       drawTopView();
       drawBarChart();
       drawScrollBar();
       
       image(bg, 0, bgPosY);
       image(topView, margin/2, bgPosY+margin/2);
       image(scoreBoard, sbPos.x, bgPosY+sbPos.y);
       image(barChart, bcPos.x, bcPos.y);
       image(scrollBar, bcPos.x, bcPos.y+bcSize.y); 
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
