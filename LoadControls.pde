class LoadControls
{
  XML xml;
  XML []keys;
  String left, right, confirm, playAgain, action, value;
  
  LoadControls()
  {
    xml = loadXML("controls.xml");
    keys = xml.getChildren("key");
  }
  
  
  char getRight()
  {
    for (int i = 0; i < keys.length; i++)
    {
      action = keys[i].getString("action");
      value = keys[i].getContent();
      if (action.equals("right"))
      {
        right = value;
      }
    }
    return right.charAt(0);
  }


  char getLeft()
  {
    for (int i = 0; i < keys.length; i++)
    {
      action = keys[i].getString("action");
      value = keys[i].getContent();
      if (action.equals("left"))
      {
        left = value;
      }
    }
    return left.charAt(0);
  }


  char getConfirm()
  {
    for (int i = 0; i < keys.length; i++)
    {
      action = keys[i].getString("action");
      value = keys[i].getContent();
      if (action.equals("spaceBar"))
      {
        confirm = value;
      }
    }
    return ' ';
  }


  char getPlayAgain()
  {
    for (int i = 0; i < keys.length; i++)
    {
      action = keys[i].getString("action");
      value = keys[i].getContent();
      if (action.equals("playAgain"))
      {
        playAgain = value;
      }
    }
    return playAgain.charAt(0);
  }
}