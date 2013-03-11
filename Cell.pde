class Cell {
  float xPos, yPos, radius;
  
  float mass;
  
  PVector accel, speed, friction;
  
  PVector forceSum;
  
  float frictionCoefficient;
  
  color fillColour;
  
  Cell(int xPos, int yPos, int radius) {
    this.xPos = xPos;
    this.yPos = yPos;
    this.radius = radius;
    
    colorMode(HSB);
    fillColour = color(random(80) + 80, 180, 180);
    
    
    mass = 1;
    frictionCoefficient = 0.1;
    
    forceSum = new PVector(0, 0);
    speed = new PVector(0, 0);
    accel = new PVector(0, 0);
    friction = new PVector(0, 0);
    
  }
  
  void display() {
    fill(fillColour);
    strokeWeight(2);
    stroke(color(0, 0, 0));
    ellipse(round(xPos), round(yPos), round(radius)*2, round(radius)*2);
  }
  
  void addForce(PVector force) {
    forceSum.add(force);
  }
  
  void update() {
    float impulseChance = random(20);
    if (impulseChance <= 2) {
      PVector impulse = PVector.mult(PVector.random2D(), impulseChance);
      addForce(impulse);
    }
    
    // calculate friction
    friction.setMag(0);
    PVector.mult(speed, -frictionCoefficient, friction);
    addForce(friction);
    
    // caculate resulting acceleration and reset force sum
    accel = PVector.div(forceSum, mass);
    forceSum.setMag(0);
    
    // apply acceleration
    speed.add(accel);
    if (speed.mag() < 0.1)
      speed.setMag(0);
    
    // update coordinates
    xPos += speed.dot(1, 0, 0);
    yPos += speed.dot(0, 1, 0);
  }
}
