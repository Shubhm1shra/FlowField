class Particle{
  PVector pos, vel, acc, ppos;
  PVector terminalVel = new PVector(2, 2);
  float scale = 10; 
  
  Particle(){
    this.pos = new PVector(random(width), random(height));
    this.ppos = this.pos.copy();
    
    this.vel = PVector.random2D();
    this.acc = PVector.random2D();
  }
  
  Particle(PVector pos, PVector vel, PVector acc){
    this.pos = pos;
    this.ppos = this.pos.copy();
    this.vel = vel;
    this.acc = acc;
  }
  
  void update(){
    this.ppos.x = this.pos.x;
    this.ppos.y = this.pos.y;
    
    this.pos.x = (((this.pos.x + this.vel.x) % width) + width) % width;
    this.pos.y = (((this.pos.y + this.vel.y) % height) + height) % height;
    
    if(dist(this.ppos.x, this.ppos.y, this.pos.x, this.pos.y) > width/3){
      this.ppos.x = this.pos.x;
      this.ppos.y = this.pos.y;
    }
    
    this.vel.add(this.acc);
    this.vel.limit(this.terminalVel.mag());
    
    this.acc.mult(0);
  }
  
  void display(){
    stroke(0, 10);
    strokeWeight(1);
    fill(0);
    line(this.pos.x, this.pos.y, this.ppos.x, this.ppos.y); 
  }
  
  void addGradient(float magnitude, float angle){
    if(magnitude != 0){
      this.acc.x += cos(angle);
      this.acc.y += sin(angle);
    }
  }
}
