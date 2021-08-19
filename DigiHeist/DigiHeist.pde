//IMPORTS
import java.util.*;

//this is the main file. it handles everything running
player player;

mapHandler mapHandler;

bulletHandler bulletHandler;

boolean debug = true;
boolean godMode = false;
boolean postGame = false;

boolean isMenu = true;

boolean dialogue = false;

boolean displayBossHealth = false;

boolean victory = false;

boolean gameOver = false;

GUI gui = new GUI();

BossHandler bossHandler;

PFont dialogueFont;

PFont gameFont;

int count = 0;

void setup()
{
  size(720, 640);
  player = new player(400, 400);
  mapHandler = new mapHandler();
  bulletHandler = new bulletHandler();
  bossHandler = new BossHandler();
  noCursor();
  gameFont = createFont("../assets/fonts/ARCADECLASSIC.TTF", 32);
  textFont(gameFont);
  
  dialogueFont = createFont("../assets/fonts/Roboto-Black.ttf", 20);
  print(Float.intBitsToFloat(0x7f800000));
}

void draw()
{
  background(0);
  strokeWeight(2);
  noFill();
  
  mapHandler.run();
  
  if(!player.dead)
  {
    drawCrossHair();
    player.movement();
    player.display();
  }
  if(postGame)
  {
     cursor();
  }
  if(!dialogue && !isMenu && !postGame)
  {
    gui.displayStats();
  }
  if(dialogue)
  {
    bossHandler.talk();
  }
  if(gameOver)
  {
    gui.displayGameOver();
    if(count > 500)
    {
      resetEverything();
    }
    else
      count++;
  }
  bulletHandler.run();
  
}

void drawCrossHair()
{
  image(loadImage("../assets/crossHair.png"), mouseX - 5, mouseY - 5, 20, 20);
}

void keyPressed()
{
  if(isMenu)
  {
    mapHandler.currentMap.mainMenuControl();
  }
  else
  {
    player.keyDown();
  }
}

void keyReleased()
{
  player.keyUp();
}

void mousePressed()
{
  if(dialogue)
  {
    bossHandler.nextLine();
  }
  else if(postGame)
  {
    resetEverything(); //reset's victory, which actually disables victory dialogue. gotta fix later.
    //mapHandler.changeMap();
  }
  else
  {
    player.shoot();
  }
}

void resetEverything()
{
  postGame = false;
  hostiles.clear();
  bullets.clear();
  fill(255);
  isMenu = true;
  dialogue = false;
  displayBossHealth = false;
  victory = false;
  gameOver = false;
  
  player = new player(400, 400);
  mapHandler = new mapHandler();
  bulletHandler = new bulletHandler();
  bossHandler = new BossHandler();
  noCursor();
  gameFont = createFont("../assets/fonts/ARCADECLASSIC.TTF", 32);
  textFont(gameFont);
  
  dialogueFont = createFont("../assets/fonts/Roboto-Black.ttf", 20);
}
