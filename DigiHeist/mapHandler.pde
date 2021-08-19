/**
 *  The job of a map handler is to keep a map loaded at all times.
 *  It also Reads, loads, changes and saves maps.
 *  Oh, and it also does stuff like NPCs n... stuff.
 */
ArrayList<Hostile> hostiles = new ArrayList<Hostile>();

class mapHandler
{
  //the currently active map
  map currentMap;
  
  String hostileFile;
  
  //every single map in existance
  map mainMenu = new map("/../maps/mainMenu.txt", 500, 500, loadImage("../maps/bg_menu.png"));
  map WH1 = new map("/../maps/warehousePack/WH_map1.txt", 17, 8, loadImage("../maps/warehousePack/bg/WH1.png"));
  map WH2 = new map("/../maps/warehousePack/WH_map2.txt", 3, 15, loadImage("../maps/bg_menu.png"));
  map WH3 = new map("/../maps/warehousePack/WH_map3.txt", 20, 15, loadImage("../maps/bg_menu.png"));
  map WH4 = new map("/../maps/warehousePack/WH_map4.txt", 20, 15, loadImage("../maps/bg_menu.png"));
  map WH5 = new map("/../maps/warehousePack/WH_map5.txt", 20, 9, loadImage("../maps/bg_menu.png"));
  map gameOverScreen = new map("/../maps/victoryScreen.txt", 500, 500, loadImage("../maps/bg_menu.png"));
  
  mapHandler()
  {
    //in the constructor, it automatically loads and preps the map.
    currentMap = mainMenu;
    currentMap.loadMap();
  }
  
  //=====HANDLING MAP CHANGES=====//
  //Stage 1
  void saveCurrentMap() //MIGHT BE scrapped...
  {
    //save the current map into a "savedMaps" folder
    //set the new map as the global variable
    //use loadMap to read the map file n shit
  }
  
  //saves the map first,
  //then reconstructs the currentMap object.
  //then loads it again.
  void changeMap()
  {
    bullets.clear();
    if(currentMap == mainMenu)
    {
      currentMap = WH1;
      
      hostileFile = ("/../maps/warehousePack/WH_NPC1.txt");
    }
    else if(currentMap == WH1)
    {
      currentMap = WH2;
      
      hostileFile = ("/../maps/warehousePack/WH_NPC2.txt");
    }
    else if(currentMap == WH2)
    {
      currentMap = WH3;
      
      hostileFile = ("/../maps/warehousePack/WH_NPC3.txt");
    }
    else if(currentMap == WH3)
    {
      currentMap = WH4;
      
      hostileFile = ("/../maps/warehousePack/WH_NPC4.txt");
    }
    else if(currentMap == WH4)
    {
      currentMap = WH5;
      
      hostileFile = ("/../maps/warehousePack/WH_NPC5.txt");
      bossHandler.openDialogue();
    }
    else if(currentMap == WH5)
    {
      currentMap = gameOverScreen;
      
      hostileFile = ("/../maps/victoryScreen.txt");
    }
    else if(currentMap == gameOverScreen)
    {
      currentMap = mainMenu;
      
      hostileFile = ("/../maps/mainMenu.txt");
    }
    hostiles.clear();
    currentMap.loadMap();
    loadNPC();
  }
  
  void loadNPC()
  {
    try
    {
      Scanner read = new Scanner(new File(sketchPath() + hostileFile));
      while(read.hasNextLine())
      {
        Hostile newEnemy = new Hostile(read.nextInt(), read.nextInt(), read.nextInt());
        hostiles.add(newEnemy);
      }
      read.close();
    }
    catch(IOException e)
    {
      System.out.print("Can't find the NPC file: " + e);
    }
  }
  
  //=====RUN=====//
  void run() //just to save confusion...
  {
    currentMap.runMap();
    
    //run hostiles
    for (int i = 0; i < hostiles.size(); i++)
    {
      hostiles.get(i).run();
      if(hostiles.get(i).death)
        hostiles.remove(i);
    }
  }
}
