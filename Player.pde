class Player extends GameObject
{
  AudioPlayer audio;
  ArrayList<PImage>moves;
  char moveL, moveR;
  PImage move;
  int currentMove, frameC;
  PVector right, left;
  float scoreBoardH, scoreBoardW, speed, caScore;
  color scoreBoardFill, textColor;
  String trimmedScore;
  
  Player()
  {
    super(0.0, 0.0, 1);
  }

  Player(char moveL, char moveR, float positionX, float positionY, float level)
  {
    super(positionX, positionY, level);
    this.moveL = moveL;
    this.moveR = moveR;
    this.caScore = 0.0;
    if (level == 1)
    {
      this.speed = level * 3.0;
    } 
    else if (level == 2)
    {
      this.speed = level * 1.7;
    } 
    else if (level == 3)
    {
      this.speed = level * 1.3;
    } 
    else
    {
      this.speed = level;
    }
    right = new PVector(speed, 0.0);
    left = new PVector(-speed, 0.0);
    right.mult(speed);
    left.mult(speed);
    scoreBoardFill = color(224, 224, 235);
    textColor = color(102, 61, 0);
    scoreBoardW = 170;
    scoreBoardH = 70;
  }


  void update()
  {
    right.x = speed;
    left.x = -speed;
    right.mult(speed);
    left.mult(speed);
    if (keys[moveL])
    {
      if (position.x > 0)
      {
        position.add(left);
      }
      if (position.x < 0)
      {
        position.x = 0.0;
      }
    }
    if (keys[moveR])
    {
      if (position.x < width-playerW)
      {
        position.add(right);
      } 
      if (position.x > width-playerW)
      {
        position.x = width-playerW;
      }
    }
    //change player move sprite every sixt of the second
    if (frameCount % 10 == 0)
    {
      if (currentMove == 1)
      {
        currentMove = 2;
      } 
      else
      {
        currentMove = 1;
      }
    }
  }


  void display()
  {
    imageMode(CORNERS);
    image(moves.get(currentMove-1), position.x, position.y);
    showScore();
  }


  void loadGraphics()
  {
    playerW = 30;
    playerH = 40;
    frameC = 2;
    currentMove = 1;
    //load all player sprite frames in the array
    moves = new ArrayList<PImage>();
    for (int i = 1; i <= frameC; i++)
    {
      move = loadImage("move"+i+".png");
      move.resize(playerW, playerH);
      moves.add(move);
    }
  }


  void showScore()
  {
    caConvertedToPercent = (float)(caScore*100.0)/(weeksPerLevel * (numOfCa-1));
    if (caConvertedToPercent > 100)
    {
      caConvertedToPercent = 100.0;
    }
    trimmedScore = nf(caConvertedToPercent, 1, 2);
    stroke(textColor);
    fill(scoreBoardFill);
    rect(0, 0, scoreBoardW, scoreBoardH, 5);
    fill(textColor);
    textSize(20);
    textAlign(LEFT);
    text("Week:", 15, 30);
    text(termScore, 100, 30);
    text("CA %:", 15, 50);
    text(trimmedScore, 100, 50);
    noFill();
  }
}