//contains bullet types. constructed.
//regular
//frag
//splash
//laser
class Bullet
{
  //=================LOCATION AND MOVEMENT=================//
  float x = 0; //where the bullet currently is
  float y = 0;
  
  float xVelo;  //speed AND direction, to be calculated in ready()
  float yVelo;
  
  float velocityConstant; //different for each bullet type
  
  float angle;
  boolean posX;
  boolean posY;
  
  //=================BULLET TYPES=================//
  boolean conventional = false;
  boolean frag = false;
  boolean splash = false;
  boolean laser = false;
  
  PImage sprite;
  boolean enemy; //if its a bullet fired from the enemy
  
  float xSize;
  float ySize;
  
  //=================HELPER METHOD=================//
  boolean readyStatus = false;
  boolean destruction = false;
  int animationStage = 0;
  
  Bullet(int t, float xSpawn, float ySpawn, boolean px, boolean py, float ang, boolean hostile)
  {
    x = xSpawn;
    y = ySpawn;
    posX = px;
    posY = py;
    angle = ang;
    enemy = hostile;
    
    //determine the type of bullet
    //0 = conventional, 1 = frag, 2 = splash, 3 = laser
    if(t == 0)
      conventional = true;
    else if(t == 1)
      frag = true;
    else if(t == 2)
      splash = true; //(splash) does "splash damage",    "HOLY HELL! GREAT BALLS o' FIRE!!!!~~~"
    else if(t == 3)
      laser = true;
  }
  
  ///////////////////BULLET BEHAVIOUR///////////////////
  void ready()  //every bullet must call this ATLEAST once
  {
    destruction = false;
    //SET THE VELOCITY CONSTANT (based on bullet type)
    
    //make the enemy's bullet slower, to level game difficulty.
    if(enemy)
    {
      if(conventional)
      {
        velocityConstant = 7;
      }
      if(frag)
      {
        velocityConstant = 5;
      }
      if(splash)
      {
        velocityConstant = 5;
      }
    }
    else
    {
      if(conventional)
      {
        velocityConstant = 10;
      }
      if(frag)
      {
        velocityConstant = 7;
      }
      if(splash)
      {
        velocityConstant = 7;
      }
    }
    //lasers dont have velocity constants
    
    if(!laser)    //CALCULATE THE factors of x and y for THE VELOCITY.
    {
      //angle = abs(angle);
      if(posX) //X SHOULD BE GOING RIGHT xVelo, yVelo,
      {
        xVelo = cos(radians(angle)) * velocityConstant;
        xVelo = abs(xVelo);
        
        yVelo = sin(radians(angle)) * velocityConstant;
        if(posY) //Y SHOULD BE GOING DOWN
          yVelo = abs(yVelo);
        else
          yVelo = -abs(yVelo);
      }
      else if(!posX) //X SHOULD BE GOING LEFT
      {
        xVelo = cos(radians(angle)) * velocityConstant;
        xVelo = -abs(xVelo);
        
        yVelo = sin(radians(angle)) * velocityConstant;
        if(posY)
          yVelo = abs(yVelo);
        else
          yVelo = -abs(yVelo);
      }
    }
    
    if(conventional)    //READY THE SPRITES FOR THE DISPLAY LOOP
    {
      sprite = loadImage("../assets/bullet/conventional/projectile.png");
      xSize = 8;
      ySize = 8;
    }
    readyStatus = true;
  }
  
  boolean checkStatus()
  {
    return readyStatus;
  }
  
  //every bullet should be constantly calling this.
  void move()
  {
    x += xVelo;
    y += yVelo;
  }
  
  //every bullet should be constantly calling this.
  //contact with the player or the enemy, or a block
  ///////////////////WALL COLLISION///////////////////
  void wallContact(Block foreign)
  {
    //FIRST check if it has made contact
    boolean contact = false;
    if(x >= foreign.xDeploy && x <= (foreign.xDeploy + foreign.WIDTH) && y >= foreign.yDeploy && y <= (foreign.yDeploy + foreign.HEIGHT))
    {
      contact = true;
    }
    
    //SECOND check where it made the impact on the wall.
    boolean impactUp = false;
    boolean impactDown = false;
    boolean impactLeft = false;
    boolean impactRight = false;  //impact right OF the bullet
    if(contact)
    {
      float xDiff = (foreign.xDeploy + foreign.WIDTH/2) - x - xSize/2;
      float yDiff = (foreign.yDeploy + foreign.HEIGHT/2) - y - ySize/2;
      
      if(abs(xDiff) > abs(yDiff))
      {
        if(xDiff > 0) impactRight = true;
        else          impactLeft  = true;
      }
      else if(abs(yDiff) > abs(xDiff))
      {
        if(yDiff < 0) impactUp = true;
        else          impactDown  = true;
      }
    }
    
    //THIRD animate the bullet impact.
    if(impactUp)
    {
      xVelo = 0;
      yVelo = 0;
      xSize = 20;
      ySize = 20;
      
      if(animationStage != 4)
      {
        animateBulletImpact(0, 0);
      }
      animationStage++;
    
      //FINALLY, flag for destruction
      if(animationStage >= 4)
      {
        sprite = loadImage("../assets/bullet/conventional/disappear.png");
        contact = false;
        destruction = true;
      }
    }
    if(impactDown)
    {
      xVelo = 0;
      yVelo = 0;
      xSize = 20;
      ySize = 20;
      
      if(animationStage != 4)
      {
        animateBulletImpact(0, 1);
      }
      animationStage++;
    
      //flag for destruction
      if(animationStage >= 4)
      {
        sprite = loadImage("../assets/bullet/conventional/disappear.png");
        contact = false;
        destruction = true;
      }
    }
    if(impactLeft)
    {
      xVelo = 0;
      yVelo = 0;
      xSize = 20;
      ySize = 20;
      
      if(animationStage != 4)
      {
        animateBulletImpact(0, 2);
      }
      animationStage++;
    
      //flag for destruction
      if(animationStage >= 4)
      {
        sprite = loadImage("../assets/bullet/conventional/disappear.png");
        contact = false;
        destruction = true;
      }
    }
    if(impactRight)
    {
      xVelo = 0;
      yVelo = 0;
      xSize = 20;
      ySize = 20;
      
      if(animationStage != 4)
      {
        animateBulletImpact(0, 3);
      }
      animationStage++;
    
      //flag for destruction
      if(animationStage >= 4)
      {
        sprite = loadImage("../assets/bullet/conventional/disappear.png");
        contact = false;
        destruction = true;
      }
    }
  }
  
  void animateBulletImpact(int type, int impactDir)
  {
    if(type == 0)
    {
      if(impactDir == 0)  sprite = loadImage("../assets/bullet/conventional/impactUp" + animationStage + ".png");
      if(impactDir == 1)  sprite = loadImage("../assets/bullet/conventional/impactDown" + animationStage + ".png");
      if(impactDir == 2)  sprite = loadImage("../assets/bullet/conventional/impactLeft" + animationStage + ".png");
      if(impactDir == 3)  sprite = loadImage("../assets/bullet/conventional/impactRight" + animationStage + ".png");
    }
  }
  
  ///////////////////COLLISION with PEOPLE///////////////////
  void checkPlayerHit() //checks if the player is hit, and then acts accordingly
  {
    if(enemy == true)
    {
      if(x + xSize > player.hitX - 0 && x < player.hitX + 0 && y + ySize > player.hitY - 0 && y < player.hitY + 0) //if the bullet hits the player's hitbox
      {
        if(!player.dead && !godMode)
          player.die();
      }
      if(x + xSize > player.x && x < player.x + player.xSize && y + ySize > player.y && y < player.y + player.ySize) //if the bullet only grazes the player
      {
        player.score += 2;
        player.graze++;
      }
    }
  }
  
  void checkEnemyHit()
  {
    if(enemy == false)
    {
      for(Hostile h : hostiles)
      {
        if(x + xSize > h.x && x < h.x + h.xSize && y + ySize > h.y && y < h.y + h.ySize) //if the bullet hits the player's hitbox
        {
          player.score += 200;
          h.HP -= 1;
          if(h.HP == 0)
          {
            h.death = true;
            if(h.type == 2)
            {
              delay(1000);
              victory = true;
              bossHandler.openDialogue();
              delay(1000);
            }
          }
          destruction = true;
        }
      }
      if(victory)
      {
        bullets.clear();
        hostiles.clear();
      }
    }
  }
  
  ///////////////////DISPLAY///////////////////
  void display()  //every bullet should be constantly calling this.
  {
    image(sprite, x, y, xSize, ySize);
  }
  
  //helper method
  boolean isLaser()
  {
    return laser;
  }
  
  ///////////////////THE THING THE GAME CALLS EVERY INTERATION///////////////////
  void process()//process every bullet, the movement and such
  {
    if(conventional)
    {
      move();
      display();
      checkPlayerHit();
      checkEnemyHit();
    }
    else if(frag)
    {
      
    }
    else if(splash)
    {
      
    }
    else if(laser)
    {
      
    }
  }
}
