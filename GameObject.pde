abstract class GameObject
{
  PVector position;
  int[] obstRow = {0, 1, 0, 1, 1}; //change this to change amount and layout of obstacles
  float obstW, obstH, powerUpH, level, speed, caScore, obstCount, caConvertedToPercent;
  int rows, cols, playerW, playerH, termScore, numOfCa, numOfDistr, numOfProcast;
  int[][]caPointsRows;
  
  GameObject()
  {
    this(0.0, 0.0, 1);
  }

  GameObject(float positionX, float positionY, float level)
  {
    this.position = new PVector(positionX, positionY);
    this.level = level;
    rows = 8;
    cols = 12;
    this.caPointsRows = new int[rows][cols];
    obstH = 70.0;
    termScore = 0;
    caScore = 0.0;
    
    //number of caPoints instances that are appearing after obstacles per week
    numOfCa = 4;
    numOfDistr = 3;
    numOfProcast = 3;
    loadGraphics();
  }


  abstract void update();
  abstract void display();
  void loadGraphics()
  {
  }
}