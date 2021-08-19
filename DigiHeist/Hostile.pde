//the class for all hostiles in the game
boolean enemyHoldFire = false;
class Hostile
{
  ///////////////////VARIABLES///////////////////
  PImage sprite;
  int type = 0; //0 = shooter, 1 = Boss's minion, 2 = Boss
  boolean death;
  float HP = 1;

  //location tracker
  float x;
  float y;
    
  //size
  float xSize = 30;
  float ySize = 36;
  
  //shooting mechanics
  int coolDown = 10; //time inbetween shots
  int recoilCount = 0;
  
  //pathfinding mechanics
  boolean spotted = false; //has direct line of sight OR hears the player shoot.
  
  float angle = 0;
  
  boolean posX = false;
  boolean posY = false;
  
  Hostile(int t, int xSpawn, int ySpawn)
  {
    type = t;
    x = (xSpawn * xSize) - (xSize/2);
    y = (ySpawn * ySize) - (ySize/2);
    death = false;
    if(t == 0)
    {
      coolDown = 10;
      sprite = loadImage("../assets/hostile/hostileE.png");
    }
    if(t == 1)
    {
      coolDown = 6;
      
      sprite = loadImage("../assets/hostile/hostileE.png");
      HP = 2;
    }
    if(t == 2)
    {
      bossHandler = new BossHandler();
      sprite = loadImage("../assets/boss/bossE.png");
      HP = 100;
      coolDown = 9;
    }
  }
  
  void display()
  {
    image(sprite, x, y, xSize, ySize);
  }
  
  //FIRST, make enemy shoot things.
  void shoot()
  {
    calculateAngle();
    
    if(coolDown <= 0)
    {
      Bullet newBullet = new Bullet(0, (x + xSize/2), (y + ySize/2), posX, posY, angle, true);
      bulletHandler.addToArray(newBullet);
      recoilCount++;
      if(type == 0) coolDown = 10;
      if(type == 1) coolDown = 10;
    }
    else
      coolDown--;
    
    if(recoilCount > 5)
    {
      recoilCount = 5;
    }
  }
  
  void calculateAngle() // this function also doubles as a "look" function
  {
    //FIRST, calculate figure out location differences from them and the player.
    float diffXPos = (x + xSize/2) - player.hitX; //pos = right, neg = left.
    float diffYPos = (y + ySize/2) - player.hitY; //pos = above, neg = below.
    
    //see if its above or below.
    posX = (diffXPos <= 0);
    posY = (diffYPos <= 0);
    
    //calculate angle
    angle = atan(diffYPos / diffXPos);
    angle = angle * 180/PI + (random(-recoilCount * 2, recoilCount * 2)); //convert to degrees.
    
    //NOW, SET THE SPRITE!!!
    if(posX) //posX is looking east
    {
      if(angle < -75)
        sprite = loadImage("../assets/hostile/hostileN.png");
      else if (-75 < angle && angle < -45)
        sprite = loadImage("../assets/hostile/hostileNR.png");
      else if (-45 < angle && angle < -15)
        sprite = loadImage("../assets/hostile/hostileEL.png");
      else if(-15 < angle && angle < 15)
        sprite = loadImage("../assets/hostile/hostileE.png");
      else if(15 < angle && angle < 45)
        sprite = loadImage("../assets/hostile/hostileER.png");
      else if(45 < angle && angle < 75)
        sprite = loadImage("../assets/hostile/hostileSL.png");
      else if(75 < angle)
        sprite = loadImage("../assets/hostile/hostileS.png");
    }
    else //posX is looking west
    {
      if(angle < -75)
        sprite = loadImage("../assets/hostile/hostileS.png");
      else if (-75 < angle && angle < -45)
        sprite = loadImage("../assets/hostile/hostileSR.png");
      else if (-45 < angle && angle < -15)
        sprite = loadImage("../assets/hostile/hostileWL.png");
      else if(-15 < angle && angle < 15)
        sprite = loadImage("../assets/hostile/hostileW.png");
      else if(15 < angle && angle < 45)
        sprite = loadImage("../assets/hostile/hostileWR.png");
      else if(45 < angle && angle < 75)
        sprite = loadImage("../assets/hostile/hostileNL.png");
      else if(75 < angle)
        sprite = loadImage("../assets/hostile/hostileN.png");
    }
  }
  
  void run()
  {
    if(type == 0 || type == 1)
    {
      display();
      if(!player.dead)
        shoot();
    }
    if(type == 2)
    {
      display();
      if(!player.dead && !dialogue)
      {
        sprite = bossHandler.lookAngle(x, y, xSize, ySize);
        //combat phase 1
        if(bossHandler.combatPhase == 1)
        {
          bossHandler.combat1(x, y);
        }
        //combat phase 2
        if(bossHandler.combatPhase == 2)
        {
          if(!bossHandler.combat2Ready)
            bossHandler.combat2Prep();
          else
            bossHandler.combat2(x, y);
        }
        //combat phase 3
        if(bossHandler.combatPhase == 3)
        {
          if(!bossHandler.combat3Ready)
            bossHandler.combat3Prep();
          else
            bossHandler.combat3(x, y);
        }
      }
    }
  }
  
}
