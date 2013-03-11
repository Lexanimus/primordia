/* 
Art Game made for FACS 3935 "Screen-Based Fluid Interfaces"
Creative team: Alexander Moakler, Alexander Ornat, Ryan Chang

PRIMORDIA
*/
  
int screenX = 1024;
int screenY = 800;
int margin = 20;

int numCells = 100;

Cell[] cells;
RepulsionField[] repulsionFields;

void setup () {
  size(screenX, screenY);
  colorMode(HSB);
  
  // initialize cells
  cells = new Cell[numCells];
  for (int i = 0; i < numCells; i++) {
    cells[i] = new Cell((int)random(screenX), (int)random(screenY), (int)random(10)+10);
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
    float distance = dist(cells[i].xPos, cells[i].yPos, mouseX, mouseY); 
    if (distance < 100) {
      PVector repulsion = new PVector(cells[i].xPos - mouseX, cells[i].yPos - mouseY);
      repulsion.normalize();
      repulsion.mult((100 - distance) / 5);
      cells[i].addForce(repulsion);
    }
  }
}

void draw () {
  
  // background
  background(#424242);
  
    // update objects
  for (int i = 0; i < cells.length; i++) {
    // physics stuff
    cells[i].update();
    
    // wrapping
    if (cells[i].xPos < -margin)
      cells[i].xPos = screenX + margin;
    else if (cells[i].xPos > screenX + margin)
      cells[i].xPos = -margin;
    if (cells[i].yPos < -margin)
      cells[i].yPos = screenY + margin;
    else if (cells[i].yPos > screenY + margin)
      cells[i].yPos = -margin;
  }
  for (int i = 0; i < repulsionFields.length; i++) {
    if (repulsionFields[i] != null && repulsionFields[i].isDone())
      repulsionFields[i] = null;
  }
  
  // draw objects
  for (int i = 0; i < cells.length; i++) {
    cells[i].display();
  }
  for (int i = 0; i < repulsionFields.length; i++) {
    if (repulsionFields[i] != null)
      repulsionFields[i].display();
  }
}


