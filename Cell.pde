class Cell implements Comparable<Cell>{
  boolean active;
  
  float xPos, yPos, radius;
  float frictionCoefficient;
  float mass;
  
  PVector accel, speed, friction;
  PVector forces;
  
  color fillColour;
  int teamColour;
  
  Cell(int xPos, int yPos, int radius, int targetHue) {
    this.xPos = xPos;
    this.yPos = yPos;
    this.radius = radius;
    teamColour = targetHue;
    
    // physics constants
    mass = 1;
    frictionCoefficient = 0.1;
    
    forces = new PVector(0, 0);
    speed = new PVector(0, 0);
    accel = new PVector(0, 0);
    friction = new PVector(0, 0);
    
    fillColour = color(random(10) + targetHue, 180, 240, 120);
    
    active = true;
  }
  
  int compareTo(Cell other) {
    return (int)(this.radius - other.radius);
  }
  
  void kill() {
    active = false;
    radius = 0;
    xPos = -screenX*10;
    yPos = -screenY*10;
  }

  public void noms(Cell[] otherCells) {
    //int growthSpeed;
    for (int i = 0; i < otherCells.length; i++) {
      if (this.detectNom(otherCells[i]) && this.active == true && otherCells[i].active == true) {
        if (this != otherCells[i]) { //make sure you're not comparing the cell to itself
          //stuff in here happens when cells collide

          //growthSpeed = this.speed + cells[i].speed;
          
          if (this.active && otherCells[i].active) {
            // check which cell is bigger
            Cell bigger, smaller;
            if (this.radius >= otherCells[i].radius) {
              bigger = this;
              smaller = otherCells[i];
            } else {
              bigger = otherCells[i];
              smaller = this;
            }
            
            // DO THE NOMMING
            float amount = smaller.radius / bigger.radius;
            
            bigger.radius += amount/2;
            smaller.radius -= amount;
            
            if (smaller.radius <= 2) {
              smaller.kill();
            }
          }
        }
      }
    }
  }

  boolean detectNom(Cell other) {
    return (dist(xPos, yPos, other.xPos, other.yPos) < (this.radius + other.radius));
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
    accel = PVector.div(forces, radius/30);
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
  
  void display(int screenX, int screenY) {
    fill(fillColour);
    strokeWeight(2);
    stroke(color(0, 0, 0));
//    for (int x = -1; x <= 1; x++) {
//      for (int y = -1; y <= 1; y++) {
    int x = 0; int y = 0;
        ellipse(round(xPos)+x*screenX, round(yPos)+y*screenY, round(radius)*2, round(radius)*2);
//      }
//    }
  }
}
