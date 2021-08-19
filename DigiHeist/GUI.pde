class GUI
{
  String aaa;
  GUI()
  {
    
  }
  void displayStats() //call this if the boss isnt in a dialogue, if the map isnt the menu
  {
    strokeWeight(5);
    stroke(0, 200, 200);
    fill(0, 100, 100, 200);
    rect(0, 512, 720, 128);
    
    //displaying player's lives
    for(int i = 0; i < player.lives; i++)
    {
      fill(255);
      ellipse(170 + (i * 30), 570, 20, 20);
    }
    fill(255);
    text("Player ", 50, 580);
    
    //displaying score points
    text("Score " + player.score, 300, 580);
    text("Graze " + player.graze, 500, 580);
    
    //display boss's health points
    if(displayBossHealth)
    {
      fill(255, 200, 200);
      stroke(255, 100, 100);
      text("Firewall", 10, 30);
      rect(160, 2, bossHandler.bossHP() * 5, 26);
    }
  }
  
  void nextLine(String text)
  {
    aaa = text;
  }
  
  void displayDialogue()
  {
    strokeWeight(5);
    stroke(0, 200, 200);
    fill(0, 100, 100, 200);
    rect(0, 512, 720, 128);
    fill(255);
    text(aaa, 50, 600);
  }
  
  void displayGameOver()
  {
    text("Failed!", 340, 270);
  }
}
