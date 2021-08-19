//all blocks
//interactable(?), accessPoints, barrier, wall.  will ALWAYS BE TRANSPARENT
class Block
{
  //size and location specfics
  float xDeploy, yDeploy;
  float WIDTH = 32;
  float HEIGHT = 32;
  
  //FOR DEBUGGING, DELETE AFTERWARDS
  color strokeColor = color(0, 0, 0, 255);
  
  //constructor stuff
  int xPlace, yPlace, type;
  
  //boolean for what type it is
  boolean interactable, access, barrier, wall;
  
  //boolean for collisions
  boolean blockChar = false, blockBullet = false;
  
  Block(int x, int y, int t) //0 = nothing, 1 = interactable, 2 = access, 3 = barrier, 4 = wall
  {
    xPlace = x;
    yPlace = y;
    type = t;
  }
  
  //=====PREPARE THE BLOCK=====//
  //this ready's the block's placement and engages what type it is.
  void prep()
  {
    //-----CHECK IF PLACEMENT LOCATION IS VALID-----//
    if(xPlace < 23 || xPlace > 0)
    {
      xDeploy = 32 * xPlace; //also calculate the actual placement location
    }
    if(yPlace < 23 || yPlace > 0)
    {
      yDeploy = 32 * yPlace;
    }
    
    //-----SET THE TYPE-----//
    interactable = false;
    access = false;
    barrier = false;
    wall = false;
    
    if(type == 0)  strokeColor = color(0, 0, 0, 255);
    if(type == 1)  wall = true;
    if(type == 2)  barrier = true;
    if(type == 3)  access = true;
    if(type == 4)  interactable = true; //(?)
    
    if(interactable)
    {
      strokeColor = color(100, 100, 255);
    }
    else if(access)
    {
      strokeColor = color(100, 255, 100);
    }
    else if(barrier)
    {
      strokeColor = color(150, 150, 150);
      blockChar = true;
    }
    else if(wall)
    {
      strokeColor = color(255, 255, 255);
      blockBullet = true;
      blockChar = true;
    }
  }
  
  //helper method for bullet collisions (bulletContact)
  boolean isWall()
  {
    return wall;
  }
  
  //=====MAKE IT ALLIIIIIIIVE=====//
  void run()
  {
    //=====DRAW IT=====// (DEBUG ONLY)
    if(debug)
    {
      stroke(strokeColor);
      rect(xDeploy, yDeploy, WIDTH, HEIGHT);
    }
    
    //=====COLLISION CHECK=====//
    if(wall || barrier)
    {
      player.checkCollision(this); //a method in player.
    }
    
    //=====ACCESSPOINT CHECK=====//
    if(access)
      player.checkAccess(this);
  }
}
