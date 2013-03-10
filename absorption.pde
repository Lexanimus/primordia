// :Cell Absorption:
// This peice of functionality will focus on cell collisions and absorption
// A larger cell will appear to absorb a smaller cell
//
//
// :Pseudocode:
// 1. calculate distance between every cell by traversing array
//  - (make sure not to detect distance from each cell to itself)
// 2. IF the distance is less than the sum of the radiuses of both cells, we have a
// 	collision
// 3. in the case of a collision, compare the size of both colliding cells
// 	- LARGER CELL: grows and continues trajectory
// 	- SMALLER CELL: shrinks, fades, and is removed from array
//
// :Implementation:
// The following function is performed on every existing cell during every iteration
// of the 'draw' loop

public void noms() {
  for(int i = 0; i < cells.length; i++){ //go through all existing cells
    if(this.detectNom(cells[i]) && this.active == true && cells[i].active == true) { //if cells being compared are active and in range of each other
      if(xpos != cells[i].xpos && ypos != cells[i].ypos) { //make sure you're not comparing the cell to itself
        if(this.cellSize >= cells[i].cellSize) { //if cell A is larger than cell B
          if(this.active && cells[i].active) { //if cells are still active, grow and shrink as necessary
            this.cellSize += 3*this.speed;
            cells[i].cellSize -= 3*cells[i].speed;
          }
          if(this.cellSize <= 2) //if a cell is too small, remove it
            this.kill();
          if(cells[i].cellSize <= 2)
            cells[i].kill();
        } else if (cells[i].cellSize < this.cellSize) { //if cell B is larger than cell A
          if(this.active && cells[i].active) { //if cells are still active, grow and shrink as necessary
            cells[i].cellSize += 3*this.speed;
            this.cellSize -= 3*cells[i].speed;
          }
          if(this.cellSize <= 2) //if a cell is too small, remove it
            this.kill();
          if(cells[i].cellSize <= 2)
            cells[i].kill();
        }
      }
    } 
  }
}

public boolean detectNom(Cell other) { //used by the function above to calculate distance between cells
  return (dist(xpos, ypos, other.xpos, other.ypos) < (this.cellSize/2 + other.cellSize/2));
}

// Alexander Ornat
