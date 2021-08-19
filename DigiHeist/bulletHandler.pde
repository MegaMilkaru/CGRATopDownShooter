ArrayList<Bullet> bullets = new ArrayList<Bullet>();

class bulletHandler
{
  bulletHandler()
  {
    bullets.clear();
  }
  
  //adds to the global array of bullets that exist
  void addToArray(Bullet newBullet)
  {
    bullets.add(newBullet);
  }
  //function that deletes bullets that are flagged for destruction
  
  //goes through the array of bullets and runs EVERYTHING
  void run()
  {
    for(int i = 0; i < bullets.size(); i++)
    {
      //ready bullets that arent ready.
      if(!bullets.get(i).checkStatus())
      {
        bullets.get(i).ready();
      }
      //checks bullet collisions with any blocks
      if(!bullets.get(i).isLaser())
      {
        for(Block b : map)
        {
          if(b.isWall())
            bullets.get(i).wallContact(b);
        }
      }
      
      if(bullets.get(i).destruction) //delete bullets that have been flagged for destruction.
      {
        bullets.remove(i);
      }
      else //runs the rest
      {
        bullets.get(i).process();
      }
    }
  }
}
