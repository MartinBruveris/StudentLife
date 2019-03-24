class CaPoints extends GameObject implements CaScore
{
  int randomCell, randomRow, temp;
  color caCol, tvCol, lazyCol;
  float offset;
  AudioPlayer caInc;
  AudioPlayer caDec;
  AudioPlayer slow;
  
  CaPoints()
  {
    this(0.0, 0.0, 1);
  }

  CaPoints(float positionX, float positionY, float level)
  {
    super(positionX, positionY, level);
    caInc = minim.loadFile("ca.wav");
    caDec = minim.loadFile("tv.wav");
    slow = minim.loadFile("lazy.wav");
    initializePowerUps();
    obstW = width/cols;
    offset = 8;
    powerUpH = 30;
    position.y = -(powerUpH*rows+(obstH*2));
    caCol = color(0, 255, 0);
    tvCol = color(255, 204, 0);
    lazyCol = color(255, 0, 0);
    if (level == 1)
    {
      this.speed = level * 2.3 ;
    } 
    else if(level == 4)
    {
      this.speed = level * 1.5 ;
    }
    else
    {
      this.speed = level * 1.7;
    }
  }


  void addTo(Player player)
  {
    player.caScore++;
    caInc.rewind();
    caInc.play();
  }


  void removeFrom(Player player)
  {
    if (player.caScore > 0.0)
    {
      player.caScore = player.caScore - 0.5;
      caDec.rewind();
      caDec.play();
    }
  }


  void slowDown(Player player)
  {
    if (player.speed > 0.5)
    {
      player.speed = player.speed-0.3;
      slow.rewind();
      slow.play();
    }
  }


  void update()
  {
    if (position.y > height && weeksPerLevel-1 > player.termScore)
    {
      position.y = -(powerUpH*rows+(obstH*2));
      initializePowerUps();
    }
    position.y = position.y+speed;
  }


  void display()
  { 
    //draws ca powerups
    for (int i = 0; i < rows; i++)
    {
      for (int j = 0; j < cols; j++)
      {
        if (caPointsRows[i][j] == 0)
        {
          noStroke();
          noFill();
        }
        if (caPointsRows[i][j] == 1)
        {
          stroke(0);
          fill(caCol);
          rect(obstW*j, (powerUpH*i)+position.y, obstW, powerUpH, 10);
          fill(0);
          textAlign(CENTER);
          text("CA", (obstW*j)+(obstW/2), (powerUpH*i)+position.y+(powerUpH/2)+offset);
        }
        if (caPointsRows[i][j] == 2)
        {
          stroke(0);
          fill(tvCol);
          rect(obstW*j, (powerUpH*i)+position.y, obstW, powerUpH, 10);
          fill(0);
          textAlign(CENTER);
          text("TV", (obstW*j)+(obstW/2), (powerUpH*i)+position.y+(powerUpH/2)+offset);
        }
        if (caPointsRows[i][j] == 3)
        {
          stroke(0);
          fill(lazyCol);
          rect(obstW*j, (powerUpH*i)+position.y, obstW, powerUpH, 10);
          fill(0);
          textAlign(CENTER);
          text("Lazy", (obstW*j)+(obstW/2), (powerUpH*i)+position.y+(powerUpH/2)+offset);
        }
        noFill();
      }
    }
  }


  void initializePowerUps()
  {
    numOfCa = 4;
    numOfDistr = 3;
    numOfProcast = 3;
    
    //fill the powerup array with 0
    for (int i = 0; i < cols; i++)
    {
      for (int j = 0; j < rows; j++)
      {
        caPointsRows[j][i] = 0;
      }
    }

    //generate specified amount of powerups and try to distribute them so tht they are no right besides each other 
    //should really put more thought into this to probably space the obstacles evenly 
    while (numOfCa > 0)
    {
      randomCell = (int)random(0, cols - 1);
      randomRow = (int)random(0, rows - 1);
      if (caPointsRows[randomRow][randomCell] == 0)
      {
        if (randomCell < cols-1)
        {
          randomCell++;
          if (caPointsRows[randomRow][randomCell] == 0)
          {
            caPointsRows[randomRow][randomCell] = 1;
            numOfCa--;
          }
        }
      } 
      else
      {
        randomCell = (int)random(0, cols - 1);
        randomRow = (int)random(0, rows - 1);
      }
    }

    while (numOfDistr > 0)
    {
      randomCell = (int)random(0, cols - 1);
      randomRow = (int)random(0, rows - 1);
      if (caPointsRows[randomRow][randomCell] == 0)
      {
        if (randomCell < cols-1)
        {
          randomCell++;
          if (caPointsRows[randomRow][randomCell] == 0)
          {
            caPointsRows[randomRow][randomCell] = 2;
            numOfDistr--;
          }
        }
      } 
      else
      {
        randomCell = (int)random(0, cols - 1);
        randomRow = (int)random(0, rows - 1);
      }
    }

    while (numOfProcast > 0)
    {
      randomCell = (int)random(0, cols - 1);
      randomRow = (int)random(0, rows - 1);
      if (caPointsRows[randomRow][randomCell] == 0)
      {
        if (randomCell < cols-1)
        {
          randomCell++;
          if (caPointsRows[randomRow][randomCell] == 0)
          {
            caPointsRows[randomRow][randomCell] = 3;
            numOfProcast--;
          }
        }
      } 
      else
      {
        randomCell = (int)random(0, cols - 1);
        randomRow = (int)random(0, rows - 1);
      }
    }
  }
}