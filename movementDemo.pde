int screenX = 800;
int screenY = 600;
int xpos = 100;
int ypos = 100;
int speed = 2; //number of pixels jumped per loop
int direction = 0; //default up
int dcf = 7;  //number of loops before direction change (direction change frequency; changes constantly)
int freqMin = 4;  //minimum no. of loops before direction change
int freqMax = 7;  //maximum no. of loops before direction change

void setup () {
  size(screenX, screenY);
  background(#424242);
}

void draw () {
  background(#424242);
  ellipse(xpos, ypos, 30, 30);
  updateDirection();
  move();
  
  //keypress stuff
  if(keyPressed) {
    if(key == 'a')
      changeMood(1);
    if(key == 's')
      changeMood(2);
    if(key == 'd')
      changeMood(0);
  }
  //end keypress stuff
}

void updateDirection() {
  if(dcf==0){
    if((int)random(2)>0) {
      direction++;
    } else {
      direction--;
    }
    if(direction>7)
      direction--;
    if(direction<0)
      direction++;
      
     dcf = (int)random(freqMin, freqMin);
  } else {
    dcf--;    
  }
}

void move() {
  if(xpos >= 0 && xpos <= screenX && ypos >= 0 && ypos <= screenY) {
    switch(direction){
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
  } else {
    xpos = width/2;
    ypos = height/2; 
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
