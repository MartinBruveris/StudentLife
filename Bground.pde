class Bground extends GameObject
{
  PImage bgd;
  float level;
  
  Bground()
  {
    super(0.0, 0.0, 1);
  }

  Bground(float positionX, float positionY, float level)
  {
    super(positionX, positionY, level);
    if (level == 1)
    {
      this.speed = level * 2.0;
    } 
    else
    {
      this.speed = level * 1.5;
    }
  }


  void update()
  {
    if (position.y - bgd.height >= 0)
    {
      position.y = 0.0;
    }
    position.add(0, speed);
  }


  void display()
  {
    imageMode(CORNER);
    image(bgd, position.x, position.y);
    image(bgd, position.x, position.y - bgd.height);
  }


  void loadGraphics()
  {
    bgd = loadImage("background.jpg");
    bgd.resize(width, height);
  }
}