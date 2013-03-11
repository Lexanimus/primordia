class RepulsionField {
  float xPos, yPos;
  
  int maxRadius, currRadius;
  int duration;
  
  RepulsionField(int xPos, int yPos, int r) {
    this.xPos = xPos;
    this.yPos = yPos;
    
    maxRadius = r;
    currRadius = 0;
    duration = 10;
  }
  
  void display() {
    noFill();
    strokeWeight(2);
    stroke(color(255, 0, 255));
    ellipse(round(xPos), round(yPos), currRadius*2, currRadius*2);
    
    currRadius += (maxRadius - currRadius)/3;
    duration--;
  }
  
  boolean isDone() {
    return (duration <= 0);
  }
}
