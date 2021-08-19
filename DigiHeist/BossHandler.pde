//handles the boss's extra things like special moves or battle phases
Queue<String> bossLines = new ArrayDeque<String>();

class BossHandler
{
  ///////////////////VARIABLES///////////////////
  
  //shooting mechanics
  float health = 100;
  int combatPhase = 1;
  boolean posX = false;
  boolean posY = false;
  float OGCoolDown = 8;
  float coolDown = 10;
  float angle = 0;
  int recoilCount = 0;
  
  float x = 0;
  float y = 0;
  
  float recoilConstant = 2;
  
  void openDialogue() //call this when the map first opens.
  {
    if(!victory)
    {
      dialogue = true;
      textFont(dialogueFont);
      try
      {
        Scanner read = new Scanner(new File(sketchPath() + "/../maps/warehousePack/FirewallDialogue.txt"));
        while(read.hasNextLine())
        {
          bossLines.add(read.nextLine());
        }
        read.close();
      }
      catch(IOException e)
      {
        System.out.println("cannot read dialogue: " + e);
      }
      gui.nextLine(bossLines.poll());
    }
    else
    {
      dialogue = true;
      textFont(dialogueFont);
      try
      {
        Scanner read = new Scanner(new File(sketchPath() + "/../maps/warehousePack/victoryDialogue.txt"));
        while(read.hasNextLine())
        {
          bossLines.add(read.nextLine());
        }
        read.close();
      }
      catch(IOException e)
      {
        System.out.println("cannot read dialogue: " + e);
      }
      gui.nextLine(bossLines.poll());
    }
  }
  
  void talk() //only call this when in dialogue. it prints out the next line in text
  {
    gui.displayDialogue();
  }
  
  void nextLine()
  {
   if(bossLines.peek() != null)
      gui.nextLine(bossLines.poll());
    else //begin boss fight
    {
      dialogue = false;
      textFont(gameFont);
      if(!victory)
        displayBossHealth = true;
      else
        displayBossHealth = false;
    }
  }
  
  PImage lookAngle(float x, float y, float xSize, float ySize)
  {
    PImage sprite = loadImage("../assets/boss/bossN.png");
    //FIRST, calculate figure out location differences from them and the player.
    float diffXPos = (x + xSize/2) - player.hitX; //pos = right, neg = left.
    float diffYPos = (y + ySize/2) - player.hitY; //pos = above, neg = below.
    
    //see if its above or below.
    posX = (diffXPos <= 0);
    posY = (diffYPos <= 0);
    
    //calculate angle
    angle = atan(diffYPos / diffXPos);
    angle = angle * 180/PI + random(-recoilCount * recoilConstant, recoilCount * recoilConstant);
    
    //NOW, SET THE SPRITE!!!
    if(posX) //posX is looking east
    {
      if(angle < -75)
        sprite = loadImage("../assets/boss/bossN.png");
      else if (-75 < angle && angle < -45)
        sprite = loadImage("../assets/boss/bossNR.png");
      else if (-45 < angle && angle < -15)
        sprite = loadImage("../assets/boss/bossEL.png");
      else if(-15 < angle && angle < 15)
        sprite = loadImage("../assets/boss/bossE.png");
      else if(15 < angle && angle < 45)
        sprite = loadImage("../assets/boss/bossER.png");
      else if(45 < angle && angle < 75)
        sprite = loadImage("../assets/boss/bossSL.png");
      else if(75 < angle)
        sprite = loadImage("../assets/boss/bossS.png");
    }
    else //posX is looking west
    {
      if(angle < -75)
        sprite = loadImage("../assets/boss/bossS.png");
      else if (-75 < angle && angle < -45)
        sprite = loadImage("../assets/boss/bossSR.png");
      else if (-45 < angle && angle < -15)
        sprite = loadImage("../assets/boss/bossWL.png");
      else if(-15 < angle && angle < 15)
        sprite = loadImage("../assets/boss/bossW.png");
      else if(15 < angle && angle < 45)
        sprite = loadImage("../assets/boss/bossWR.png");
      else if(45 < angle && angle < 75)
        sprite = loadImage("../assets/boss/bossNL.png");
      else if(75 < angle);
    }
    return sprite;
  }
  
  void shoot(float x, float y)
  {
    if(coolDown <= 0)
    {
      float xSize = 30;
      float ySize = 36;
      Bullet newPlayerBullet = new Bullet(0, (x + xSize/2), (y + ySize/2), posX, posY, angle, true);
      bulletHandler.addToArray(newPlayerBullet);
      recoilCount++;
      /*if(type == 1)*/ coolDown = OGCoolDown;
    }
    else
      coolDown--;
    
    if(recoilCount > 5)
    {
      recoilCount = 5;
    }
  }
  
  //battle helper methods
  void ceaseFire(float duration)
  {
    
  }
  
  void setOGCoolDown(float newNum)
  {
    OGCoolDown = newNum;
  }
  void setRecoilConstant(float newNum)
  {
    recoilConstant = newNum;
  }
  
  //phase 1
  void combat1(float x, float y)
  {
    shoot(x, y);
    if(bossHP() < 70)
    {
      //display picture in visual class (NOT IMPLIMENTED YET)
      combatPhase = 2;
    }
  }
  
  //phase 2
  boolean combat2Ready = false;
  void combat2Prep()
  {
    setOGCoolDown(2);
    setRecoilConstant(8);
    combat2Ready = true;
  }
  
  void combat2(float x, float y)
  {
    shoot(x, y);
    if(bossHP() < 40)
    {
      combatPhase = 3;
    }
  }
  
  //phase 3
  boolean combat3Ready = false;
  void combat3Prep()
  {
    setOGCoolDown(6);
    setRecoilConstant(4);
    
    hostiles.add(new Hostile(1, 8, 13));
    hostiles.add(new Hostile(1, 7, 10));
    hostiles.add(new Hostile(1, 7, 6));
    hostiles.add(new Hostile(1, 8, 3));
    combat3Ready = true;
  }
  
  void combat3(float x, float y)
  {
    shoot(x, y-10);
    shoot(x, y+10);
    shoot(x, y-70);
    shoot(x, y+70);
    shoot(x, y-120);
    shoot(x, y+120);
  }
  
 //helper method, return the boss's health
  int bossHP()
  {
    int bossHP = 0;
    for(Hostile h: hostiles)
    {
      if(h.HP > bossHP)
      {
        bossHP = (int)h.HP;
      }
    }
    return bossHP;
  }
}
