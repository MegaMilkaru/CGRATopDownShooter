/**
 *  This contains everything to do with the player.
 *  Including IMAGES, CONTROLS, INVENTORY and WEAPONS
 */
class player
{
  ///////////////////VARIABLES///////////////////
  PImage sprite;
  
  int score = 0;
  int graze = 0;

  //location tracker
  float x;
  float y;
  
  float hitX;
  float hitY;
  float hitDiameter = 6;
  boolean showHitBox = true;
  boolean dead = false; //makes the player invisible.
  
  //velocity
  float xVel = 0;
  float yVel = 0;
  
  //size
  float xSize = 30;
  float ySize = 36;
  
  //lives
  float lives; //these lives behave more like respawn tokens.
  
  //=================CONTROLS=================//
  boolean up, down, left, right, focus;
  
  //collision
  boolean insideX; //if it's inside x boundaries
  boolean insideY; //if it's inside y boundaries
  
  boolean touchingX;
  boolean touchingY;
  
  boolean inside; //if both are inside
  
  boolean touching; //if both are touching
  
  boolean touchDown = false, touchUp = false, touchLeft = false, touchRight = false;
  
  //=================MOVEMENT FACTORS=================//
  float velocityConstant = 5; //press a button and it moves at this speed.
  
  //=================AIMING=================//
  float lookAngle;
  boolean posX;
  boolean posY;
  
  
  ///////////////////CONSTRUCTOR AND FUNCTIONS///////////////////
  player(float xSpawn, float ySpawn)
  {
    //sprite = loadImage(Location);
    x = xSpawn;
    y = ySpawn;
    lives = 4;
    enemyHoldFire = false;
  }

  //draws
  void display()
  {
    if(!dead)
    {
      player.look();
      image(sprite, x, y, xSize, ySize);
      if(showHitBox)
      {
        noStroke();
        fill(255, 155, 155);
        ellipse(hitX, hitY, hitDiameter, hitDiameter);
      }
    }
  }

  ///////////////////MOVEMENT///////////////////
  void movement()
  {
    
    //---momentum sliding mechanic---//
    if(xVel > 0) //momentum going right
    {
      if(touchRight) xVel = 0;
      else xVel -= 1;
    }
    if(xVel < 0) //momentum going left
    {
      if(touchLeft) xVel = 0;
      else xVel += 1;
    }
    if(yVel < 0) //mometum going up
    {
      if(touchUp) yVel = 0;
      else yVel += 1;
    }
    if(yVel > 0) //momentum going down
    {
      if(touchDown) yVel = 0;
      else yVel -= 1;
    }
    
    //---ordering basic movement---//
    if(left && !touchLeft)
    {
      xVel = -velocityConstant;
    }
      
    if(right && !touchRight)
    {
      xVel = velocityConstant;
    }
    
    if(up && !touchUp)
    {
      yVel = -velocityConstant;
    }
      
    if(down && !touchDown)
    {
      yVel = velocityConstant;
    }
    
    //register momentum
    x += xVel;
    y += yVel;
    
    //register movement of the hitbox
    hitX = x + (xSize/2);
    hitY = y + (ySize/2);
    
    resetCollisions();
  }
  
  void keyDown()
  {
    if(key == 'a') left = true;
    if(key == 'd') right = true;
    if(key == 'w') up = true;
    if(key == 's') down = true;
    if(key == 'f') System.out.println("x: " + x/32 + " y: " + y/32);
  }
  
  void keyUp()
  {
    if(key == 'a') left = false;
    if(key == 'd') right = false;
    if(key == 'w') up = false;
    if(key == 's') down = false;
  }
  ///////////////////FIRE///////////////////
  //This is called when the player clicks on the screen 
  void shoot()
  {
    if(!dead)
    {
      Bullet newPlayerBullet = new Bullet(0, hitX, hitY, posX, posY, lookAngle, false);
      bulletHandler.addToArray(newPlayerBullet);
    }
  }
  
  ///////////////////SPRITECHANGES///////////////////
  //calculate's where the mouse is relative to the hitbox, and changes the sprite.
  void look()
  {
    //FIRST, check if the player is looking left or right
    posX = false;  //DEFAULT: looking left
    float xDiff = mouseX - hitX;
    if(xDiff > 0)
      posX = true;  //looking right
    else
      posX = false; //looking left
      
    //SECOND, check if the player is looking up or down.
    float yDiff = mouseY - hitY;
    if(yDiff > 0)
      posY = true;  //looking Down
    else
      posY = false; //looking Up
    
    //THIRD, calculating the angle. X is adjacent and Y is the opposite
    lookAngle = atan(yDiff / xDiff);
    lookAngle = lookAngle * 180/PI; //convert to degrees.
    
    //NOW, SET THE SPRITE!!!
    if(posX) //posX is looking east
    {
      if(lookAngle < -75)
        sprite = loadImage("../assets/player/playerN.png");
      else if (-75 < lookAngle && lookAngle < -45)
        sprite = loadImage("../assets/player/playerNR.png");
      else if (-45 < lookAngle && lookAngle < -15)
        sprite = loadImage("../assets/player/playerEL.png");
      else if(-15 < lookAngle && lookAngle < 15)
        sprite = loadImage("../assets/player/playerE.png");
      else if(15 < lookAngle && lookAngle < 45)
        sprite = loadImage("../assets/player/playerER.png");
      else if(45 < lookAngle && lookAngle < 75)
        sprite = loadImage("../assets/player/playerSL.png");
      else if(75 < lookAngle)
        sprite = loadImage("../assets/player/playerS.png");
    }
    else //posX is looking west
    {
      if(lookAngle < -75)
        sprite = loadImage("../assets/player/playerS.png");
      else if (-75 < lookAngle && lookAngle < -45)
        sprite = loadImage("../assets/player/playerSR.png");
      else if (-45 < lookAngle && lookAngle < -15)
        sprite = loadImage("../assets/player/playerWL.png");
      else if(-15 < lookAngle && lookAngle < 15)
        sprite = loadImage("../assets/player/playerW.png");
      else if(15 < lookAngle && lookAngle < 45)
        sprite = loadImage("../assets/player/playerWR.png");
      else if(45 < lookAngle && lookAngle < 75)
        sprite = loadImage("../assets/player/playerNL.png");
      else if(75 < lookAngle)
        sprite = loadImage("../assets/player/playerN.png");
    }
  }
  ///////////////////SCORES///////////////////
  void die() //This is only called when the player hitbox collides with an enemy bullet.
  {
    dead = true;
    delay(1000);
    //teleport player to respawn place.
    teleport(mapHandler.currentMap.spawnX, mapHandler.currentMap.spawnY);
    if(lives > 0)
    {
      lives -= 1;
      dead = false;
      bullets.clear();
    }
    else
    {
      gameOver = true;
      x = -500;
      y = -500;
    }
  }
  
  ///////////////////COLLISION///////////////////
  void checkCollision(Block foreign)
  {
    float foreignXPos = foreign.xDeploy;
    float foreignYPos = foreign.yDeploy;
    
    //FIRST, find the block's centre
    float foreignCentreXPos = foreign.WIDTH/2 + foreignXPos;
    float foreignCentreYPos = foreign.HEIGHT/2 + foreignYPos;
    
    //---SECOND, see if they're INSIDE---//
    //see if its inside x
    if(foreignXPos < x+xSize + 2 && x - 2 < foreignXPos + foreign.WIDTH)
      insideX = true; //check if its touching x
    else 
      insideX = false;
    //see if its inside y
    if(foreignYPos < y+ySize + 2 && y - 2 < foreignYPos + foreign.HEIGHT)  
      insideY = true;
    else 
      insideY = false;
      
    if(insideX && insideY)
      inside = true;
    else
      inside = false;
      
    //---THIRD, see if they're ABOUT to TOUCH (SO THAT IT ONLY DISABLES MOVEMENT INTO THAT DIRECTION)---//
    //TOUCH
    if(foreignXPos <= x+xSize + 2 && x - 2 <= foreignXPos + foreign.WIDTH)
      touchingX = true; //check if its touching x
    else 
      touchingX = false;
    //see if its inside y
    if(foreignYPos <= y+ySize + 2 && y - 2 <= foreignYPos + foreign.HEIGHT)  
      touchingY = true;
    else 
      touchingY = false;
    
    if(touchingX && touchingY) 
      touching = true;
    else
      touching = false;
    
    //FOURTH, compare the centre of the block with the circle
    //but first, real quick, reset everything to prevent bugs.
    if(touching)
    {
      stroke(230, 77,77);
      rect(foreignXPos, foreignYPos, foreign.WIDTH, foreign.HEIGHT);
      
      //calulcate distance from hitbox to the centre of the box
      float xDist = foreignCentreXPos - hitX;  //pos = right, neg = left
      float yDist = foreignCentreYPos - hitY;  //pos = below, neg = above
      
      if(yDist > 0) yDist -= 3; //compensate for size differences
      if(yDist < 0) yDist += 3; //on the y axis of the sprite
      
      //comparing
      if(Math.abs(xDist) < Math.abs(yDist))
      {
        //y is greater distance, but its touching, so its the y axis that are touching each other.
        //find if above or below
        if(yDist < 0)
          touchUp = true;
          
        if(yDist > 0)
          touchDown = true;
      }
      if(Math.abs(xDist) > Math.abs(yDist))
      {
        //likewise
        if(xDist < 0)
          touchLeft = true;
          
        if(xDist > 0)
          touchRight = true;
      }
      
    }
    
    if(inside)
    {
      stroke(255, 0, 0);
      rect(foreignXPos, foreignYPos, foreign.WIDTH, foreign.HEIGHT);
      
      //calulcate distance from hitbox to the centre of the box
      float xDist = foreignCentreXPos - hitX;  //pos = right, neg = left
      float yDist = foreignCentreYPos - hitY;  //pos = below, neg = above
      
      if(yDist > 0) yDist -= 3; //compensate for size differences
      if(yDist < 0) yDist += 3; //on the y axis of the sprite
      
      //reposition the player so it's JUST outside the wall if its inside [WARNING: VERY BRUTE FORCE]
      if(Math.abs(xDist) < Math.abs(yDist))
      {
        if(yDist > 0)
        {
          y = foreignYPos - ySize - 2;
        }
          
        if(yDist < 0)
        {
          y = foreignYPos + foreign.HEIGHT + 2;
        }
      }
      if(Math.abs(xDist) > Math.abs(yDist))
      {
        if(xDist > 0)
        {
          x = foreignXPos - xSize - 2;
        }
          
        if(xDist < 0)
        {
          x = foreignXPos + foreign.WIDTH + 2;
        }
      }
    }
    
  }
  
  void resetCollisions()
  {
    if(!touching)
    {
      touchLeft = false;
      touchRight = false;
      touchUp = false;
      touchDown = false;
    }
  }
  
  //CHECK ACCESS
  void checkAccess(Block foreign)
  {
    float foreignXPos = foreign.xDeploy;
    float foreignYPos = foreign.yDeploy;
    
    //---FIRST, see if they're INSIDE---//
    //see if its inside x
    if(foreignXPos < x+xSize + 2 && x - 2 < foreignXPos + foreign.WIDTH)
      insideX = true; //check if its touching x
    else 
      insideX = false;
    //see if its inside y
    if(foreignYPos < y+ySize + 2 && y - 2 < foreignYPos + foreign.HEIGHT)  
      insideY = true;
    else 
      insideY = false;
      
    if(insideX && insideY)
      inside = true;
    else
      inside = false;
      
    //---THIRD, see if they're ABOUT to TOUCH (SO THAT IT ONLY DISABLES MOVEMENT INTO THAT DIRECTION)---//
    //TOUCH
    if(foreignXPos <= x+xSize && x <= foreignXPos + foreign.WIDTH && foreignYPos <= y+ySize + 2 && y - 2 <= foreignYPos + foreign.HEIGHT)
    {
      if(hostiles.size() == 0)
        mapHandler.changeMap();
    }
  }
  
  //helper methods for other classes
  void teleport(float xTele, float yTele)
  {
    float xLocation = xTele * 32 + 16;
    float yLocation = yTele * 32 + 16;
    x = xLocation - xSize/2;
    y = yLocation - ySize/2;
  }
  
  float reportX()
  {
    return x;
  }
  
  float reportY()
  {
    return y;
  }
}
