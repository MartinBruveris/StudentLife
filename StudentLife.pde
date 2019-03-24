import ddf.minim.*;
Minim minim;
AudioPlayer mainTrack;
AudioPlayer levelComplete;
ArrayList<GameObject>gameObjects = new ArrayList<GameObject>();
float [] levelScores;
float x, y, caScore;
boolean[] keys = new boolean[512];
boolean collision, crossed, blink;
int currentLevel, amountOfLevels, gameState, counter, weeksPerLevel, amountOfWeeks;
String msg, failMsg;
PFont font;
char right, left, confirm, playAgain;

LoadControls loadControls;
Bground bground;
Player player;
ObstacleRow obstacleRow;
CaPoints caPoints;

void setup()
{
  smooth();
  size(500, 600, P2D);
  minim = new Minim(this);
  mainTrack = minim.loadFile("02 Underclocked (underunderclocked mix).mp3");
  levelComplete = minim.loadFile("levelComplete.wav");
  font = createFont("FjallaOne-Regular.ttf", 30);
  textFont(font);
  loadControls();
  amountOfLevels = 4; // amount of total levels
  amountOfWeeks = 12; // amount of weeks per level
  levelScores = new float[amountOfLevels];
  gameState = 0;
  currentLevel = 1;
}

void draw()
{
  if(frameCount % 20 == 0)
  {
    blink = !blink;
  }
  collision = false;
  switch(gameState)
  {
    
    case 0:
      {
        mainTrack.rewind();
        background(127);
        fill(255);
        textSize(30);
        textAlign(CENTER);
        if (currentLevel <= amountOfLevels)
        {
          if (currentLevel == 1)
          {
            textSize(90);
            text("STUDENT LIFE", width/2, height/2 - 100);
            textSize(30);

            if(blink)
            {
               text("Press spacebar to begin", width/2, height/2);
            }
          
          }
          if (currentLevel > 1)
          {
            text("CONGRATULATION,\n YOU JUST COMPLETED YEAR "+(currentLevel-1), width/2, height/2);
            if(blink)
            {
              textSize(20);
              text("\n PRESS SPACEBAR TO CONTINUE", width/2, height/2+50);
              textSize(30);
            }
          }
          if (keys[confirm])
          {
            initializeGame();
            gameState = 1;
            mainTrack.rewind();
          }
        } 
        else
        {
          gameState = 6;
        }
        break;
      }

    case 1:
      {
        mainTrack.rewind();
        background(127);
        fill(255);
        textSize(30);
        textAlign(CENTER);
        if (counter <= 1)
        {
          msg = "GO!";
        }
        
        text("WELCOME TO YEAR "+currentLevel+"\nIn:\n"+msg, width/2, height/2);
        
        if (counter >= 1)
        {
          if (frameCount % 30 == 0)
          {
            counter--;
            msg = String.valueOf(counter-1);
          }
        } 
        else
        {
          gameState = 2;
        }
        break;
      }

    case 2:
      {
        mainTrack.play();
        for (int i = gameObjects.size()-1; i >= 0; i--)
        {
          GameObject game = gameObjects.get(i);
          checkCollisions();
          game.update();
          game.display();
          if (obstacleRow.position.y < 0.0 && crossed)
          {
            crossed = false;
          }
          getScore();
        }
  
        if (collision)
        {
          gameState = 3;
          mainTrack.rewind();
        }
        break;
      }
      
    case 3:
      {
        textAlign(CENTER);
        textSize(30);
        fill(127);
        rect(0, height/2 - 100, width, 200);
        fill(255, 150, 0);
        text(failMsg, width/2, height/2);
        if(blink)
        {
          textSize(20);
          text("\nPRESS SPACEBAR TO REPEAT THE YEAR", width/2, height/2);
          textSize(30);
        }
        mainTrack.rewind();
        if (keys[confirm])
        {
          gameState = 4;
        }
        break;
      }
  
    case 4:
      {
        gameObjects.clear();
        gameState = 0;
        break;
      }
  
    case 5:
      {
        for (int i = gameObjects.size()-1; i >= 0; i--)
        {
          GameObject p = gameObjects.get(i);
          if (p instanceof Player)
          {
            //at the end of each level walk the player of the screen
            if (p.position.y > -p.playerH)
            {
              p.position.y -= 5;
              p.update();
            } 
            else
            {
              levelComplete.rewind();
              levelComplete.play();
              currentLevel++;
              counter = 5;
              gameObjects.clear();
              gameState = 0;
            }
          }
          p.display();
        }
        break;
      }
      
    case 6:
      {
        background(127);

        text("Well Done, You Graduated!", width/2, height/2);
        if(blink)
        {
          textSize(20);
          text("\nPress spacebar to view your scores", width/2, height/2);
          textSize(30);
        }

        if (keys[confirm])
        {
          gameState = 7;
        }
        break;
      }
      
    case 7:
      {
        background(127);
        textAlign(CENTER);
        text("HERE ARE YOUR STATS",width/2, 50);  
        if(blink)
        {
          textSize(20);
          text("\npress G to play again",width/2, 50);  
          textSize(30);
        }
        float sum = 0.0;
        for(int i = 0; i < levelScores.length; i++ )
        {
          textAlign(LEFT);
          text("Year "+(i+1), 150, 200+(i*60));
          text(nf(levelScores[i], 1, 2), 300, 200+(i*60));
          sum += levelScores[i];
        }
        text("Average: ", 150, 450);
        text(nf(sum/levelScores.length, 1, 2), 300, 450);
        if (keys[playAgain])
        {
          mainTrack.rewind();
          gameState = 0;
          currentLevel = 1;
        }
        textAlign(CENTER);
      }
      break;
   }
}


void keyPressed()
{
  keys[keyCode] = true;
}


void keyReleased()
{
  keys[keyCode] = false;
}


void checkCollisions()
{
  for (int i = gameObjects.size()-1; i >= 0; i--)
  {
    GameObject p = gameObjects.get(i);
    if (p instanceof Player)
    {
      for (int x = gameObjects.size()-1; x >= 0; x--)
      {
        GameObject ob = gameObjects.get(x);
        if (ob instanceof ObstacleRow)
        {
          for (int a = 0; a < ob.obstRow.length; a++)
          {
            if (ob.obstRow[a] == 1 && collision == false)
            {
               //box bounding collision detection
              if (p.position.x < ((a*ob.obstW) + ob.obstW) &&
                (p.position.x + p.playerW) > (a*ob.obstW) &&
                p.position.y < ob.position.y + ob.obstH &&
                (p.playerH + p.position.y) > ob.position.y)
              {
                //after first occurance of collision stop checking for further overlaps
                collision = true;
                failMsg = "YOU DIDN'T MAKE IT THROUGH!";
                obstacleRow.play();
              }
            }
          }
        }
        if (ob instanceof CaPoints)
        {
          for (int a = 0; a < ob.caPointsRows.length; a++)
          {
            for (int b = 0; b < ob.caPointsRows[0].length; b++)
            {
              //box bounding collision detection
              if (p.position.x < (b*ob.obstW)+ob.obstW &&
                p.position.x + p.playerW > b*ob.obstW &&
                p.position.y < (a*ob.powerUpH)+ob.position.y+ob.powerUpH &&
                p.playerH + p.position.y > a*ob.powerUpH+ob.position.y
                )
              {
                if (ob.caPointsRows[a][b] == 1)
                {
                  ob.caPointsRows[a][b] = 0;
                  ((CaPoints)ob).addTo((Player)p);
                }
                if (ob.caPointsRows[a][b] == 2)
                {
                  ob.caPointsRows[a][b] = 0;
                  ((CaPoints)ob).removeFrom((Player)p);
                }
                if (ob.caPointsRows[a][b] == 3)
                {
                  ob.caPointsRows[a][b] = 0;
                  ((CaPoints)ob).slowDown((Player)p);
                }
              }
            }
          }
        }
      }
    }
  }
}


void getScore()
{
  for (int i = gameObjects.size()-1; i >= 0; i--)
  {
    GameObject p = gameObjects.get(i);
    if (p instanceof Player)
    {
      for (int x = gameObjects.size()-1; x >= 0; x--)
      {
        GameObject ob = gameObjects.get(x);
        if (ob instanceof ObstacleRow)
        {
          if (p.position.y < ob.position.y - p.playerH && crossed == false)
          {
            //add week count when user crosses the obstacle not when obstacle goes of screen
            ((ObstacleRow)ob).addTo((Player)p);
            crossed = true;
          }
        }
      }
      if (p.termScore == weeksPerLevel)
      {
        levelScores[currentLevel-1] = player.caConvertedToPercent;
        if (levelScores[currentLevel-1] < 40.0)
        {
          gameState = 3;
          failMsg = "SCORE AT LEAST 40% IN CA!";
        } 
        else
        {
          gameState = 5;
        }
      }
    }
  }
}


void loadControls()
{
  loadControls = new LoadControls();
  right = loadControls.getRight();
  left = loadControls.getLeft();
  confirm = loadControls.getConfirm();
  playAgain = loadControls.getPlayAgain();
}


void initializeGame()
{
  crossed = false;
  failMsg = msg = "";
  counter = 5;
  weeksPerLevel = amountOfWeeks;
  x = 0.0;
  y = 0.0;
  
  player = new Player(left, right, width/2, height-75, currentLevel);
  gameObjects.add(player);
  obstacleRow = new ObstacleRow(x, y, currentLevel);
  gameObjects.add(obstacleRow);
  caPoints = new CaPoints(x, y, currentLevel);
  gameObjects.add(caPoints);
  bground = new Bground(x, y, currentLevel);
  gameObjects.add(bground);
}