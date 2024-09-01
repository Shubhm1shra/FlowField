int scale = 2;
int rows, cols;

flowField field;

int particleCount = 1000;
Particle[] particles = new Particle[particleCount];

PImage img, edgeImg;
float[][] gradAngles, gradMags;
float[][][] gridVectors;

void setup() {
  size(600, 600);
  background(255);

  img = loadImage("C:/Users/user/Desktop/Gunnu/Processing/Assests/face1.jpg");
  img.resize(width, height);
  
  rows = floor(img.height/scale);
  cols = floor(img.width/scale);
  
  gradAngles = new float[img.height][img.width];
  gradMags = new float[img.height][img.width];
  
  edgeImg = convSobelMag(img, gradMags, gradAngles);
  gridVectors = calculateGridVectors(gradMags, gradAngles, scale);
  

  field = new flowField(gridVectors, scale);
  field.incrZ = 0;
  //field.isVisible = true;

  for(int i = 0; i < particleCount; i++){
    particles[i] = new Particle();
  }
}

void draw(){
  field.update();
  field.display();

  for(int i = 0; i < particles.length; i++){
    particles[i].addGradient(field.gradVectors[floor(particles[i].pos.y/scale)][floor(particles[i].pos.x/scale)][0], field.gradVectors[floor(particles[i].pos.y/scale)][floor(particles[i].pos.x/scale)][1]);

    particles[i].update();
    particles[i].display();
  }

  println("FrameRate : ", frameRate);
}

class flowField {
  int rows, cols;
  int scale;

  float incrXY = 0.01;
  float incrZ = 0.001;

  boolean isVisible = false;
  boolean mappedGrad = false;
  float alpha = 50;
  
  float[][][] gradVectors;

  flowField() {
    this.scale = 10;

    this.rows = floor(height/this.scale);
    this.cols = floor(width/this.scale);
    gradVectors = new float[rows][cols][2];
  }

  flowField(int scale) {
    this.scale = scale;

    this.rows = floor(height/this.scale);
    this.cols = floor(width/this.scale);
    gradVectors = new float[rows][cols][2];
  }

  flowField(float[][][] gradVectors, int scale) {
    this.scale = scale;
    this.rows = floor(height/this.scale);
    this.cols = floor(width/this.scale);

    this.gradVectors = gradVectors;
    this.mappedGrad = true;
  }

  void update() {
    float yOff = 0;
    float zOff = 0;
    
    for(int row = 0; row < this.rows; row++){
      float xOff = 0;
      for(int col = 0; col < this.cols; col++){
        if(this.mappedGrad){
          if(this.gradVectors[row][col][0] == 0){
            this.gradVectors[row][col][1] = noise(xOff, yOff, zOff) * TWO_PI;
            xOff += this.incrXY;
          }
        } else {
          this.gradVectors[row][col][1] = noise(xOff, yOff, zOff) * TWO_PI;
          xOff += this.incrXY;
        }
      }
      yOff += this.incrXY;
      zOff += this.incrZ;
    }
  }

  void display() {
    if (this.isVisible) {
      for (int row = 0; row < this.rows; row++){
        for (int col = 0; col < this.cols; col++){          
          float x1 = (col * this.scale) + this.scale / 2;
          float y1 = (row * this.scale) + this.scale / 2;
          float x2 = x1 + cos(this.gradVectors[row][col][1]) * this.scale / 2;
          float y2 = y1 + sin(this.gradVectors[row][col][1]) * this.scale / 2;

          stroke(0);
          line(x1, y1, x2, y2);
        }
      }
    }
  }
}
