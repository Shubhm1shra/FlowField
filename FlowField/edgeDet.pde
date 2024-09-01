PImage convSobelMag(PImage img, float[][] gradMags, float[][] gradAngles) {
  img.filter(GRAY);
  img.loadPixels();

  PImage result = createImage(img.width, img.height, RGB);

  float[][] sobelX = {{-1, 0, 1},
    {-2, 0, 2},
    {-1, 0, 1}};
  float[][] sobelY = {{-1, -2, -1},
    {0, 0, 0},
    {1, 2, 1}};

  for (int y = 1; y < img.height - 1; y++) {
    for (int x = 1; x < img.width - 1; x++) {
      float gX = 0;
      float gY = 0;

      for (int ky = -1; ky <= 1; ky++) {
        for (int kx = -1; kx <= 1; kx++) {
          int pixel = img.pixels[(y + ky) * img.width + (x + kx)];
          float intensity = brightness(pixel);

          gX += sobelX[ky + 1][kx + 1] * intensity;
          gY += sobelY[ky + 1][kx + 1] * intensity;
        }
      }
      float magnitude = sqrt(gX * gX + gY * gY);
      float angle = atan2(gY, gX);

      result.pixels[x + y * img.width] = color(magnitude);
      
      gradMags[y][x] = magnitude;
      gradAngles[y][x] = angle;
    }
  }
  result.updatePixels();
  return result;
}

float[][][] calculateGridVectors(float[][] magnitudes, float[][] gradientAngles, int scale) {
  int rows = floor(height / scale);
  int cols = floor(width / scale);
  float[][][] gridVectors = new float[rows][cols][2];
  
  float maxMag = 0;

  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < cols; c++) {
      float sumX = 0;
      float sumY = 0;

      for (int y = r * scale; y < (r + 1) * scale && y < height; y++) {
        for (int x = c * scale; x < (c + 1) * scale && x < width; x++) {
          float angle = gradientAngles[y][x];
          float magnitude = magnitudes[y][x];

          sumX += cos(angle) * magnitude;
          sumY += sin(angle) * magnitude;
        }
      }
      
      float finalMagnitude = sqrt(sumX * sumX + sumY * sumY);
      float finalAngle = atan2(sumY, sumX);
      
      if(finalMagnitude > maxMag){
        maxMag = finalMagnitude;
      }
      

      gridVectors[r][c][0] = finalMagnitude;
      gridVectors[r][c][1] = finalAngle + PI/2;
    }
  }
  
  for(int row = 0; row < rows; row++){
    for(int col = 0; col < cols; col++){
      if(maxMag > 0){
        gridVectors[row][col][0] = (gridVectors[row][col][0] / maxMag) * 255;
      }
    }
  }

  return gridVectors;
}
