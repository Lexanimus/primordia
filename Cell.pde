class Cell {
  float xPos, yPos, radius;
  float frictionCoefficient;
  float mass;
  
  PVector accel, speed, friction;
  PVector forces;
  
  color fillColour;
  
  Cell(int xPos, int yPos, int radius) {
    this.xPos = xPos;
    this.yPos = yPos;
    this.radius = radius;
    
    // physics constants
    mass = 1;
    frictionCoefficient = 0.1;
    
    forces = new PVector(0, 0);
    speed = new PVector(0, 0);
    accel = new PVector(0, 0);
    friction = new PVector(0, 0);
    
    fillColour = color(random(80) + 80, 180, 180);
  }
  
  void display() {
    fill(fillColour);
    strokeWeight(2);
    stroke(color(0, 0, 0));
    ellipse(round(xPos), round(yPos), round(radius)*2, round(radius)*2);
  }
  
  void addForce(PVector force) {
    forces.add(force);
  }
    
  void applyForces() {
    // calculate friction:
    //   get vector of current speed
    //   scale it by a friction coefficient
    //   invert the scale so the force is 'backwards'
    friction.setMag(0);
    PVector.mult(speed, -frictionCoefficient, friction);
    addForce(friction);
    
    // caculate resulting acceleration and reset force sum:
    //  Set acceleration to total of all current forces, divided by mass
    accel = PVector.div(forces, mass);
    forces.setMag(0);
    
    // apply acceleration to speed vector
    speed.add(accel);
    // if speed is negligible, set it to zero
    if (speed.mag() < 0.1)
      speed.setMag(0);
    
    // update coordinates using vector dot product
    xPos += speed.dot(1, 0, 0);
    yPos += speed.dot(0, 1, 0);
  }
  
  void update() {
    // occcasionally add a force in a random direction
    float impulseChance = random(20);
    if (impulseChance <= 2) {
      PVector impulse = PVector.mult(PVector.random2D(), impulseChance);
      forces.add(impulse);
    }
    applyForces();
  }
}
