/* 
Art Game made for FACS 3930 "Screen-Based Fluid Interfaces"
Creative team: Alexander Moakler, Alexander Ornat, Ryan Chang

PRIMORDIA
*/
  
int screenX = 1024;
int screenY = 800;
int margin = 0;

int numCells = 100;

Cell[] cells;
RepulsionField[] repulsionFields;

PImage cellContour;

void setup () {
  size(screenX, screenY);
  colorMode(HSB);
  
  // load images
  cellContour = loadImage("cell.png");
  
  // initialize cells
  cells = new Cell[numCells];
  for (int i = 0; i < numCells; i++) {
    cells[i] = new Cell((int)random(screenX), (int)random(screenY), (int)random(10)+10, (i%2 * 120) + 80);
  }
  
  // initialize gesture objects
  repulsionFields = new RepulsionField[1];
  for (int i = 0; i < repulsionFields.length; i++) {
    repulsionFields[i] = null;
  }
}

void mouseClicked() {
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

void sortCells() {
//  Cell[] tempCells = new Cell[cells.length];
//  cells = tempCells;

  java.util.Arrays.sort(cells);
}

void draw () {
  
    // update objects
  for (int i = 0; i < cells.length; i++) {
    
//    cells[i].addForce(new PVector((mouseX - cells[i].xPos) / 20, (mouseY - cells[i].yPos) / 20));  
    
    
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
  for (int i = 0; i < repulsionFields.length; i++) {
    if (repulsionFields[i] != null && repulsionFields[i].isDone())
      repulsionFields[i] = null;
  }
  
  // smaller cells behind larger cells
  sortCells();
  
  // draw background
  background(#424242);
  
  // draw objects
  for (int i = 0; i < cells.length; i++) {
    cells[i].display(screenX, screenY);
  }
  for (int i = 0; i < repulsionFields.length; i++) {
    if (repulsionFields[i] != null)
      repulsionFields[i].display();
  }
}


