class ObstacleRow extends GameObject implements WeekCount
{
  int randomPos, temp, obstCount;
  color fillColor;
  AudioPlayer wall;
  
  ObstacleRow()
  {
    this(0.0, 0.0, 1);
  }

  ObstacleRow(float positionX, float positionY, float level)
  {
    super(positionX, positionY, level);
    wall = minim.loadFile("wall.wav");
    obstCount = obstRow.length;
    position.y = - obstH;
    obstW = (float)(width/obstCount);
    fillColor = color(204, 122, 0);
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
    player.termScore++;
  }


  void update()
  {
    if (position.y-obstH > height && caPoints.position.y > height)
    {
      position.y = -obstH;
      reShuffle();
    }
    position.y = position.y+speed;
  }


  void display()
  {
    for (int i = 0; i < obstCount; i++)
    {
      if (obstRow[i] == 1)
      {
        stroke(0);
        fill(fillColor);
        rect(i*obstW, position.y, obstW, obstH, 4);
      }
    }
  }


  void reShuffle()
  {
    for (int i = 0; i < obstRow.length; i++)
    {
      randomPos = (int)random(0, obstRow.length-1);
      temp = obstRow[i];
      obstRow[i] = obstRow[randomPos];
      obstRow[randomPos] = temp;
    }
  }
  
  void play()
  {
     wall.rewind();
     wall.play(); 
  }
}