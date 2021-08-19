//size 23 x 16 (+ 1 to y for wall.)
ArrayList<Block> map = new ArrayList<Block>();
int[][] terrain;

class map
{
  //this array holds all info on the location and type of block
  
  String file;
  float spawnX;
  float spawnY;
  PImage bg;
  
  map(String fileLocation, float playerStartX, float playerStartY, PImage background)
  {
    file = fileLocation;
    spawnX = playerStartX;
    spawnY = playerStartY;
    bg = background;
  }
  
  //loadMap() has two stages.
  //First, it reads the map, creates all the blocks, and then puts it in the global array;
  //then, it prepares all the individual blocks in the map.
  void loadMap()
  {
    map.clear();
    if(file == "/../maps/mainMenu.txt")
    {
      mainMenu();
    }
    else if(file == "/../maps/victoryScreen.txt")
    {
      postGame();
    }
    else
    {
      try
      {
        Scanner read = new Scanner(new File(sketchPath() + file));
        for(int y = 0; y < 17; y++)
        {
          for(int x = 0; x < 23; x++)
          {
            int block = read.nextInt();
            Block newBlock = new Block(x, y, block);
            map.add(newBlock);
          }
        }
        read.close();
      }
      catch(IOException e)
      {
        System.out.print("Can't find the map file: " + e);
      }
      
      //prepare all the blocks
      for(int i = 0; i < map.size(); i++)
      {
        map.get(i).prep();
      }
      
      player.teleport(spawnX, spawnY);
    }
  }
  
  //this loads in the hostiles
  
  //run the map
  void runMap()
  {
    
    if(isMenu)
    {
      image(bg, 0, 0, 720, 640);
      mainMenuSelection();
    }
    else if(postGame)
      postGame();
    else
    {
      //draw everything
      for(int i = 0; i < map.size(); i++)
      {
        map.get(i).run();
      }
    }
  }
  
  //-----SPECIAL FUNCTIONS convert this game's map into a main menu!-----//
  String selected;
  void mainMenu()
  {
    player.dead = true;
    isMenu = true;
    selected = "Game Start";
  }
  
  void mainMenuSelection()
  {
    PImage selector = loadImage("../maps/selector.png");
    
    if(selected.equals("Game Start"))
    {
      image(selector, 368, 280);
    }
    else if(selected.equals("Quit"))
    {
      image(selector, 368, 330);
    }
    text("Game Start", 400, 300);
    text("Quit", 400, 350);
  }
  
  void mainMenuControl()
  {
    if(key == ENTER)
    {
      if(selected.equals("Game Start"))
      {
        isMenu = false;
        player.dead = false;
        mapHandler.changeMap();
      }
      else if(selected.equals("Quit"))
      {
        exit();
      }
    }
    if(key == 's')
    {
      selected = "Quit";
    }
    if(key == 'w')
    {
      selected = "Game Start";
    }
  }
  //-----SPECIAL FUNCTIONS convert this map into a victory screen-----//
  void postGame()
  {
    player.dead = true;
    postGame = true;
    text("Game Over", 200, 300);
    text("Final Score   " + player.score, 200, 350);
    textFont(gameFont);
  }
}
