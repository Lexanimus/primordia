/* 
Art Game made for FACS 3930 "Screen-Based Fluid Interfaces"
Creative team: Alexander Moakler, Alexander Ornat, Ryan Chang

PRIMORDIA
*/
  
int screenX = 1024;
int screenY = 800;
int margin = 0;

int gatherX = screenX/2;
int gatherY = screenY/2;

int numCells = 100;

Cell[] cells;
RepulsionField[] repulsionFields;

PImage cellContour;
//PImage[] links;

PImage link;

int[] team;
int[] activeCells;


boolean isGestural, isLinking;
int linkID;

void setup () {
  size(screenX, screenY);
  colorMode(HSB);
  
  // load images
  cellContour = loadImage("cell.png");
//  links = new PImage[29];
  link = loadImage("p1_13.png");
  
  // initialize teams
  team = new int[2];
  team[0] = 80;
  team[1] = 200;
  activeCells = new int[2];
  
  // initialize cells
  cells = new Cell[numCells];
  for (int i = 0; i < numCells; i++) {
    int whichTeam = min(1, i);
//    int whichTeam = i%2;
    cells[i] = new Cell((int)random(screenX), (int)random(screenY), 15, team[whichTeam]);
    activeCells[whichTeam]++; 
  }
  
  // initialize gesture objects
  repulsionFields = new RepulsionField[1];
  for (int i = 0; i < repulsionFields.length; i++) {
    repulsionFields[i] = null;
  }
  
  // setup mode booleans
  isGestural = true;
  isLinking = false;
}

void mouseClicked() {
  if (isGestural) {
    // make repulsion field
    repulsionFields[0] = new RepulsionField(mouseX, mouseY, 100);
    
    // repulse cells
    for (int i = 0; i < cells.length; i++) {
      float distance = dist(cells[i].xPos, cells[i].yPos, mouseX, mouseY) - cells[i].radius; 
      if (distance < 100) {
        PVector repulsion = new PVector(cells[i].xPos - mouseX, cells[i].yPos - mouseY);
        repulsion.normalize();
        repulsion.mult((100 - distance) / 5);
        cells[i].addForce(repulsion);
      }
    }
  }
}

void sortCells() {
  java.util.Arrays.sort(cells);
}

void killCell(int hue) {
  int whichTeam;
  if (hue == team[0])
    whichTeam = 0;
  else
    whichTeam = 1;
  activeCells[whichTeam]--;
}

void draw () {
  // check number of cells
  int winningTeam = -1;
  if (activeCells[0] <= 0)
    winningTeam = 1;
  else if (activeCells[1] <= 0)
    winningTeam = 0;
  int totalCells = activeCells[0] + activeCells[1];
  
  // check win condition
  if (winningTeam != -1) {
    // disable user input
    isGestural = false;
    
    // move stuff to the center
    for (int i = 0; i < cells.length; i++) {
      if (cells[i].active) {
        PVector gatherForce = new PVector(gatherX - cells[i].xPos, gatherY - cells[i].yPos);
        if (gatherForce.mag() <= 3) {
          cells[i].xPos = gatherX;
          cells[i].yPos = gatherY;
        } else {
          gatherForce.setMag(0.5);
          cells[i].addForce(gatherForce);
        }
      }
    } 
    if (totalCells <= 1) {
      cells[cells.length-1].xPos = gatherX;
      cells[cells.length-1].yPos = gatherY;
      
      // randomly pick interface to link to
//      linkID = 13;
      isLinking = true;
    }
  }
  
  for (int i = 0; i < repulsionFields.length; i++) {
    if (repulsionFields[i] != null && repulsionFields[i].isDone())
      repulsionFields[i] = null;
  }
     
  for (int i = 0; i < cells.length; i++) {
    // physics stuff
    if (cells[i].active) {
      cells[i].update();
      cells[i].noms(cells);
    }
    // stay away from the edge!
    if (cells[i].xPos < -margin)
      cells[i].addForce(new PVector(5, 0));
    else if (cells[i].xPos > screenX + margin)
      cells[i].addForce(new PVector(-5, 0));
    if (cells[i].yPos < -margin)
      cells[i].addForce(new PVector(0, 5));
    else if (cells[i].yPos > screenY + margin)
      cells[i].addForce(new PVector(0, -5));
  }
  
  // smaller cells behind larger cells
  sortCells();
    
  // draw background
//  background(#424242);
//  for (int i = 0; i < 2; i++) {
//    fill(team[i], 240, 240);
//    text("Team " + team[i] + ": " + activeCells[i] + " cells", 20, 20 + i*30);
//  }
  background(#0A0A0A);
  
  // draw objects
  for (int i = 0; i < cells.length; i++) {
    cells[i].display(screenX, screenY);
  }
  
  if (isLinking) {
    cells[cells.length-1].setNucleus(link);
  } 
  
  for (int i = 0; i < repulsionFields.length; i++) {
    if (repulsionFields[i] != null)
      repulsionFields[i].display();
  }
}


