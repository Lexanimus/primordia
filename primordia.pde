  int screenX = 800;
  int screenY = 600;
  PImage bg;
  
  int numberOfCells = 15;

  Cell cells[] = new Cell[numberOfCells];
  
  void setup () {
    bg = loadImage("bg.jpg");
    size(screenX, screenY);

    strokeWeight(0);
    
    for(int i = 0; i < numberOfCells; i++){
    cells[i] = new Cell();
    smooth();
    }
  }

  void draw () {
    background(bg);
    for(int i = 0; i < cells.length; i++) {
      cells[i].cellStuff();
    }

/* keypress stuff
    if (keyPressed) {
      if (key == 'a')
        cell1.changeMood(1);
      if (key == 's')
        cell1.changeMood(2);
      if (key == 'd')
        cell1.changeMood(0);
    }
end keypress stuff */

  }

class Cell {
  boolean active = true;
  int xpos = 100;
  int ypos = 100;
  int speed = 1; //number of pixels jumped per loop (2 is nice)
  int direction = 0; //default up
  int dcf = 7;  //number of loops before direction change (direction change frequency; changes constantly)
  int freqMin = 4;  //minimum no. of loops before direction change
  int freqMax = 7;  //maximum no. of loops before direction change
  int cellSize = 40; //cell diameter
  color cellColor;

public Cell() {
  xpos = (int) random(0, screenX);
  ypos = (int) random(0, screenY);
  cellSize = (int) random(15, 50);
  //this.updateSpeed();
  cellColor = lerpColor(color(50, 100, 50), color(50, 255, 50), (float)random(0, 100)/100); //color assignment for this cell
}

public void noms() {
//int growthSpeed;
  for(int i = 0; i < cells.length; i++){
    if(this.detectNom(cells[i]) && this.active == true && cells[i].active == true) {
      if(xpos != cells[i].xpos && ypos != cells[i].ypos) { //make sure you're not comparing the cell to itself
        //stuff in here happens when cells collide
        
        //growthSpeed = this.speed + cells[i].speed;

        if(this.cellSize >= cells[i].cellSize) {
          if(this.active && cells[i].active) {
            this.cellSize += 2*this.speed;
            cells[i].cellSize -= 2*cells[i].speed;
          }
          
          if(this.cellSize <= 2)
            this.kill();
          if(cells[i].cellSize <= 2)
            cells[i].kill();
          //this.updateSpeed();
          //cells[i].updateSpeed();
          
        } else if (cells[i].cellSize < this.cellSize) {
          if(this.active && cells[i].active) {
            cells[i].cellSize += 2*this.speed;
            this.cellSize -= 2*cells[i].speed;
          }

          if(this.cellSize <= 2)
            this.kill();
          if(cells[i].cellSize <= 2)
            cells[i].kill();
          //this.updateSpeed();
          //cells[i].updateSpeed();
        }
      }
    } 
  }
}

public boolean detectNom(Cell other) {
  return (dist(xpos, ypos, other.xpos, other.ypos) < (this.cellSize/2 + other.cellSize/2));
}

public void updateSpeed() {
   if(this.cellSize >= 1)
     this.speed = 4 - (int) map(this.cellSize, 15, 50, 1, 3);
   else
     this.kill();
}

public void kill() {
  this.active = false;
  this.xpos = -50;
  this.ypos = -50; 
}

public void cellStuff(){
  if(this.active == true) {
    noms();
    updateDirection();
    move();
    drawCell();
  }
}

public void drawCell() {
  fill(cellColor);
  ellipse(xpos, ypos, cellSize, cellSize);
}

  void updateDirection() {
    if (dcf==0) {
      if ((int)random(2)>0) {
        direction++;
      } 
      else {
        direction--;
      }
      if (direction>7)
        direction--;
      if (direction<0)
        direction++;

      dcf = (int)random(freqMin, freqMin);
    } 
    else {
      dcf--;
    }
  }

  void move() {
    if (xpos >= -cellSize/2 && xpos <= screenX+cellSize/2 && ypos >= -cellSize/2 && ypos <= screenY+cellSize/2) {
      switch(direction) {
      case 0:
        ypos -= speed;
        break;
      case 1:
        xpos += speed;
        ypos -= speed;
        break;
      case 2:
        xpos += speed;
        break;
      case 3:
        xpos += speed;
        ypos += speed;
        break;
      case 4:
        ypos += speed;
        break;
      case 5:
        xpos -= speed;
        ypos += speed;
        break;
      case 6:
        xpos -= speed;
        break;
      case 7:
        xpos -= speed;
        ypos -= speed;
        break;
      }
    } 
    else if (xpos < -cellSize/2) {
      xpos = screenX+cellSize/2;
    } 
    else if (xpos > screenX+cellSize/2) {
      xpos = 0-cellSize/2;
    } 
    else if (ypos < -cellSize/2) {
      ypos = screenY+cellSize/2;
    } 
    else if (ypos > screenY+cellSize/2) {
      ypos = 0-cellSize/2;
    }
  }

  //cell's mood. 0=default, 1=angry, 2=sad
  void changeMood(int mood) {
    switch(mood) {
    case 0:
      fill(255, 255, 255);
      speed = 2; 
      freqMin = 4;
      freqMax = 7;
      break;
    case 1:
      fill(255, 0, 0);
      speed = 4; 
      freqMin = 2;
      freqMax = 3;
      break;
    case 2:
      fill(0, 0, 255);
      speed = 1; 
      freqMin = 13;
      freqMax = 15;
      break;
    }
  }
}
