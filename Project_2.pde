
//Setup: Initialization and setup of the environment, including screen size, data loading, and variable initialization.
//HeatMapSetup: Preparation for drawing a heatmap, including loading data and parsing it for correlations between variables.

//Draw: The main draw function that acts as the program's controller.

//Draw Menu: Drawing the menu on the right side of the screen for program selection.

//Mouse Pressed: Handling user clicks to change the current program.

//Program 1: Draws a line chart displaying average MPG by model year.

//Program 2: Draws a histogram displaying the number of cars for each cylinder count.

//Program 3: Draws a bar chart showing the number of cars per model year.

//Program 4: Draws a pie chart showing the distribution of car origins.

//Program 5: Draws a scatter plot of MPG vs. Horsepower.

//Program 6: Draws a scatter plot of Horsepower vs. Acceleration.

//Program 7: Draws a heatmap to visualize correlations between dataset variables.

//Calculate Correlation: Function for calculating correlation coefficients between variables.

//Program 8: Draws a horizontal bar chart showing the top car models by fuel efficiency.


int currentProgram = 1; // First program will run when you run the code
int[] cylinders;
int[] mpgValues;
int[] modelYears;
String[] origins = { "American", "European", "Japanese" };
int[] originCounts = new int[3];
float max_distance;

int[] horsepowerValues;
int totalVecs = 406;
BufferedReader reader;

String[] dataLines;
float[][] data;
String[] parameterNames;
int numVariables;

int cellSize = 40;
float[][] corr;
float minCorrelation = -1.0;
float maxCorrelation = 1.0;

int[] accelerationValues;

String[] dataL; 
String[] carModels;
float[] fuelEfficiency;

void setup() 
{
  size(1000, 800); // size of the screen
  noStroke();   
  max_distance = dist(0, 0, width, height);
  fill(0); // Set text color to black
  textSize(20); // Set text size to 20

  String[] lines = loadStrings("cars.data");
  cylinders = new int[lines.length];

  for (int i = 0; i < lines.length; i++) {
    String[] parts = splitTokens(lines[i]);
    if (parts.length >= 2) {
      cylinders[i] = int(parts[1]);
    }
  }
  
  mpgValues = new int[lines.length];
  modelYears = new int[lines.length];

  for (int i = 0; i < lines.length; i++) {
    String[] parts = splitTokens(lines[i]);
    if (parts.length >= 8) {
      mpgValues[i] = int(parts[0]);
      modelYears[i] = int(parts[6]);
    }
  }
  
  calculateOriginCounts();
  
  mpgValues = new int[totalVecs];
  horsepowerValues = new int[totalVecs];
  
  // Open the cars.data file
  reader = createReader("cars.data");
  
  try {
    String line;
    int count = 0;
    while ((line = reader.readLine()) != null && count < totalVecs) {
      String[] parts = line.split("\\s+");
      
      // Check if necessary values are present and not equal to "NA"
      if (parts.length >= 4 && !parts[0].equals("NA") && !parts[3].equals("NA")) {
        mpgValues[count] = int(parts[0]);
        horsepowerValues[count] = int(parts[3]);
        count++;
      }
    }
    reader.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
  
  
  HeatMapSetup();
  
  horsepowerValues = new int[totalVecs];
  accelerationValues = new int[totalVecs];
  
  // Open the cars.data file
  reader = createReader("cars.data");
  
  try {
    String line;
    int count = 0;
    while ((line = reader.readLine()) != null && count < totalVecs) {
      String[] parts = line.split("\\s+");
      
      // Check if necessary values are present and not equal to "NA"
      if (parts.length >= 6 && !parts[3].equals("NA") && !parts[5].equals("NA")) {
        int horsepower = int(parts[3]);
        int acceleration = int(parts[5]);
        horsepowerValues[count] = horsepower;
        accelerationValues[count] = acceleration;
        count++;
      }
    }
    reader.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
  program8();
  drawMenu(); // Draw Menu 
}

void HeatMapSetup()
{
 dataLines = loadStrings("cars.data");
  numVariables = 8; // Number of variables in dataset
  data = new float[dataLines.length][numVariables];
  parameterNames = new String[numVariables];

  for (int i = 0; i < dataLines.length; i++) {
    String[] values = split(dataLines[i], ' ');
    for (int j = 0; j < numVariables; j++) {
      if (values[j].equals("?")) {
        data[i][j] = Float.NaN; // Handle missing data (NaN)
      } else {
        data[i][j] = float(values[j]);
      }
    }
  }

  // Define parameter names
  parameterNames[0] = "MPG";
  parameterNames[1] = "Cylinders";
  parameterNames[2] = "Displacement";
  parameterNames[3] = "Horsepower";
  parameterNames[4] = "Weight";
  parameterNames[5] = "Acceleration";
  parameterNames[6] = "Model Year";
  parameterNames[7] = "Origin";

  calculateCorrelation();
}
void draw() 
{
  if (currentProgram == 1) 
  {
    background(0); // Clear the background
    program1();  // Draw Task 1
  } 
  else if (currentProgram == 2) 
  {
    background(0); // Clear the background
    program2();  // Draw Task 2
  } 
  else if (currentProgram == 3) 
  {
    background(0); // Clear the background
    program3();    // Draw Task 3
  }
  else if (currentProgram == 4) 
  {
    background(0); // Clear the background
    int diameter = min(width, height) - 190; // Adjusted diameter based on screen size
    float xPosition = width * 0.4; // Adjusted x-position for pie chart
    program4(diameter, originCounts, xPosition);    // Draw Task 4
  }
  else if (currentProgram == 5) 
  {
    background(0); // Clear the background
    program5();    // Draw Task 5
  }
  else if (currentProgram == 6) 
  {
    background(0); // Clear the background
    program6();    // Draw Task 6
  }
  else if (currentProgram == 7) 
  {
    background(0); // Clear the background
    program7();    // Draw Task 7
  }
  else if (currentProgram == 8) 
  {
    background(0); // Clear the background
    program8();    // Draw Task 8
  }
  drawMenu();  // Redraw the menu
}

void drawMenu() 
{
  // Menu buttons
  fill(100);
  rect(width - 160, 0, 160, height);

  fill(255);
  textSize(20);
  textAlign(CENTER, CENTER);
  text("Menu", width - 80, 30);

  // Program 1 button
  fill(0);
  rect(width - 150, 60, 140, 40);
  fill(255);
  text("Line Chart", width - 80, 80);

  // Program 2 button
  fill(0);
  rect(width - 150, 120, 140, 40);
  fill(255);
  text("Histogram", width - 80, 140);

  // Program 3 button
  fill(0);
  rect(width - 150, 180, 140, 40);
  fill(255);
  text("Bar Chart", width - 80, 200);
  
  // Program 4 button
  fill(0);
  rect(width - 150, 240, 140, 40);
  fill(255);
  text("Pie Chart", width - 80, 260);
  
  // Program 5 button
  fill(0);
  rect(width - 150, 300, 140, 40);
  fill(255);
  text("Scatter plot", width - 80, 320);
  
  // Program 6 button
  fill(0);
  rect(width - 150, 360, 140, 40);
  fill(255);
  text("Scatter plot 2", width - 80, 380);
  
  // Program 7 button
  fill(0);
  rect(width - 150, 420, 140, 40);
  fill(255);
  text("Heat Map", width - 80, 440);
  
  // Program 8 button
  fill(0);
  rect(width - 150, 480, 140, 40);
  fill(255);
  text("Horizontal Bar", width - 80, 500);
}

void mousePressed() 
{
  // Check which button was clicked
  if (mouseX > width - 150 && mouseX < width - 10) 
  {
    if (mouseY > 60 && mouseY < 100) 
    {
      currentProgram = 1;
    } 
    else if (mouseY > 120 && mouseY < 160) 
    {
      currentProgram = 2;
    } 
    else if (mouseY > 180 && mouseY < 220) 
    {
      currentProgram = 3;
    }
    else if (mouseY > 240 && mouseY < 280) 
    {
      currentProgram = 4;
    }
    else if (mouseY > 300 && mouseY < 340) 
    {
      currentProgram = 5;
    }
    else if (mouseY > 360 && mouseY < 400) 
    {
      currentProgram = 6;
    }
    else if (mouseY > 420 && mouseY < 460) 
    {
      currentProgram = 7;
    }
    else if (mouseY > 480 && mouseY < 520) 
    {
      currentProgram = 8;
    }
  }
}

void program1() 
{
  background(255); // White Background
  String[] lines = loadStrings("cars.data");

  int[] modelYears = new int[406];
  float[] mpgValues = new float[406];

  for (int i = 0; i < lines.length; i++) {
    String[] parts = lines[i].split("\\s+");
    if (!parts[0].equals("NA")) {
      modelYears[i] = int(parts[6]);
      mpgValues[i] = float(parts[0]);
    }
  }

  int numYears = 85 - 70 + 1; 

  float[] avgMpgByYear = new float[numYears];
  int[] countByYear = new int[numYears];

  for (int i = 0; i < modelYears.length; i++) {
    if (modelYears[i] >= 70 && modelYears[i] <= 82) {
      int index = modelYears[i] - 70; 
      avgMpgByYear[index] += mpgValues[i];
      countByYear[index]++;
    }
  }

  for (int i = 0; i < avgMpgByYear.length; i++) {
    if (countByYear[i] != 0) {
      avgMpgByYear[i] /= countByYear[i];
    }
  }

  int padding = 50;
  
  stroke(0);
  line(padding, padding, padding, height - padding); 
  line(padding, height - padding, width - padding, height - padding);

  fill(0);
  textSize(16);
  for (int i = 0; i < avgMpgByYear.length; i++) {
    float x = map(i, 0, avgMpgByYear.length-1, padding, width - padding);
    line(x, height - padding + 5, x, height - padding - 5); 
    textAlign(CENTER, TOP);
    text(i + 70, x, height - padding + 10);
  }
  textAlign(CENTER, TOP);
  fill(0);
  text("Model Year", width / 2, height - 20);

  textSize(16);
  for (int i = 10; i <= 70; i += 10) {
    float y = map(i, 10, 70, height - padding, padding);
    line(padding - 5, y, padding + 5, y); 
    textAlign(RIGHT, CENTER);
    text(i, padding - 10, y);
  }
  textAlign(RIGHT, CENTER);
  fill(0);
  pushMatrix();
  translate(10, height / 2);
  rotate(-HALF_PI);
  text("MPG", 0, 0);
  popMatrix();

  for (int i = 0; i < avgMpgByYear.length; i++) {
    if (countByYear[i] != 0) {
      float x = map(i, 0, avgMpgByYear.length-1, padding, width - padding);
      float y = map(avgMpgByYear[i], 10, 70, height - padding, padding); 

      color pointColor = color(255, 0, 0);
      color textColor = color(0);

      float lowerThreshold = 15.0; 
      float upperThreshold = 30.0; 

      if (avgMpgByYear[i] < lowerThreshold || avgMpgByYear[i] > upperThreshold) {
        pointColor = color(0, 0, 255);
        textColor = color(255,0,0);
      }

      fill(pointColor);
      ellipse(x, y, 10, 10); 

      fill(textColor);
      textAlign(CENTER, CENTER);
      text(nf(avgMpgByYear[i], 0, 1), x, y - 15); 
    }
  }

  noFill(); 
  stroke(0, 0, 255); 
  beginShape();
  for (int i = 0; i < avgMpgByYear.length; i++) {
    if (countByYear[i] != 0) {
      float x = map(i, 0, avgMpgByYear.length-1, padding, width - padding);
      float y = map(avgMpgByYear[i], 10, 70, height - padding, padding); 
      vertex(x, y);
    }
  }
  endShape();
}

void program2() 
{
  background(255); // White Background
// Draw Y-axis
stroke(0);
line(100, 50, 100, height - 50);

// Draw X-axis
line(100, height - 50, width - 50, height - 50);

// Draw X-axis labels and ticks
textAlign(CENTER);
fill(0); // Set fill color to black
for (int i = 1; i <= 16; i++) { // Cylinders range from 3 to 8 in the dataset
  int x = i * 60 + 100;
  text(i, x, height - 30);
  line(x, height - 45, x, height - 55);
}
fill(0); // Set fill color to black
textSize(20); // Set text size to 20
text("Cylinders", width / 2, height - 10); // X-axis label

// Draw Y-axis label
textAlign(RIGHT);
for (int i = 20; i <= 240; i += 20) {
  int y = height - i * 3 - 50;
  pushMatrix();
  translate(90, y);
  rotate(-HALF_PI);
  text(i, 0, 0);
  popMatrix();
  line(95, y, 105, y);
}
pushMatrix();
translate(30, height / 2);
rotate(-HALF_PI);
fill(0); // Set fill color to black
textSize(20); // Set text size to 20
text("Number of Cars", 0, 0); // Y-axis label
popMatrix();

// Calculate and draw histogram bars
int[] carCounts = new int[6]; // Array to store the number of cars for each cylinder count
for (int i = 0; i < cylinders.length; i++) {
  int index = cylinders[i] - 3; // Adjust index to match cylinder count (3 to 8)
  carCounts[index]++;
}

// Draw histogram bars and details on hover
for (int i = 0; i < carCounts.length; i++) {
  int x = (i + 3) * 60 + 100; // Cylinder count ranges from 3 to 8
  int y = height - carCounts[i] * 3 - 50;

  // Define thresholds for outliers
  int lowerThreshold = 20;
  int upperThreshold = 120;

  // Draw bars with different colors
  if (carCounts[i] < lowerThreshold || carCounts[i] > upperThreshold) {
    fill(255, 0, 0); // Outlier bars are red
  } else {
    fill(150, 200, 250); // Normal bars are blue
  }
  rect(x, y, 40, carCounts[i] * 3);

  // Check for hover
  if (mouseX > x && mouseX < x + 40 && mouseY > y && mouseY < y + (carCounts[i] * 3)) {
    fill(0);
    text("Cylinders: " + (i + 3) + "\nNumber of Cars: " + carCounts[i], mouseX, mouseY);
  }
}

}

void program3() 
{
  background(255); // White Background

// Define padding values
int leftPadding = 65;
int bottomPadding = 50;

// Draw Y-axis
stroke(0);
line(leftPadding, bottomPadding, leftPadding, height - bottomPadding);

// Draw X-axis
line(leftPadding, height - bottomPadding, width - leftPadding, height - bottomPadding);

// Draw X-axis labels and ticks
textAlign(CENTER);
for (int i = 0; i <= 12; i++) {
  int x = i * 60 + leftPadding;
  int year = i + 70;
  fill(0); // Set fill color to black
  text(year, x, height - 30);
  line(x, height - 45, x, height - 55);
}
fill(0);
text("Model Year", width / 2, height - 10); // X-axis label

// Draw Y-axis label
textAlign(RIGHT);
for (int i = 10; i <= 200; i += 20) {
  int y = height - i * 3 - bottomPadding;
  text(i, leftPadding - 10, y); 
  line(leftPadding - 5, y, leftPadding + 5, y);
}

pushMatrix();
translate(leftPadding - 48, height / 2);
rotate(-HALF_PI);
fill(0); // Set fill color to black
text("Number of Cars", 0, 0);
popMatrix(); // Y-axis label

// Calculate the number of cars per Model Year
int[] carCountsPerYear = new int[13]; // Array to store car counts per year

for (int i = 0; i < modelYears.length; i++) {
  int yearIndex = modelYears[i] - 70; 
  carCountsPerYear[yearIndex]++;
}

// Draw bars and check for hover
for (int i = 0; i < carCountsPerYear.length; i++) {
  int x = i * 60 + leftPadding;
  int y = height - carCountsPerYear[i] * 3 - bottomPadding;

  // Draw bars with different colors
  fill(150, 200, 250); // Adjusted fill color
  rect(x, y, 40, carCountsPerYear[i] * 3);

  // Check for hover
  if (mouseX > x && mouseX < x + 40 && mouseY > y && mouseY < y + (carCountsPerYear[i] * 3)) {
    fill(0);
    text("Model Year: " + (i + 70) + "\nNumber of Cars: " + carCountsPerYear[i], mouseX, mouseY);
  }
}
}

void program4(float diameter, int[] data, float xPosition) 
{
  background(255); // White Background
float total = sum(data);
float lastAngle = 0;

// Define an array of light colors
color[] segmentColors = {
  color(255, 200, 200),  // Light Red
  color(200, 255, 200),  // Light Green
  color(200, 200, 255),  // Light Blue
  color(255, 255, 200),  // Light Yellow
  color(255, 200, 255),  // Light Magenta
  color(200, 255, 255),  // Light Cyan
  color(255, 220, 180),  // Light Orange
  color(200, 160, 200)   // Light Purple
};

for (int i = 0; i < data.length; i++) {
  float angle = radians(map(data[i], 0, total, 0, 360));

  // Set segment colors
  fill(segmentColors[i+1 % segmentColors.length]);

  float midAngle = lastAngle + angle / 2;
  float labelRadius = diameter * 0.3; 

  float labelX = xPosition + cos(midAngle) * labelRadius;
  float labelY = height/2 + sin(midAngle) * labelRadius;

  // Draw segment
  arc(xPosition, height/2, diameter, diameter, lastAngle, lastAngle + angle);
  lastAngle += angle;

  // Display labels with percentages
  textAlign(CENTER, CENTER);
  fill(0);
  text(origins[i], labelX, labelY);

  // Display percentages
  float percentage = (data[i] / (float) total) * 100;
  text(nf(percentage, 2, 1) + "%", labelX, labelY + 20); 

 
  fill(0);
  String info = "Total Cars: " + data[i];
  text(info, labelX, labelY + 40); 
}


}

float sum(int[] arr) {
  float total = 0;
  for (int i = 0; i < arr.length; i++) {
    total += arr[i];
  }
  return total;
}

void calculateOriginCounts() {
  String[] lines = loadStrings("cars.data");
  
  for (String line : lines) {
    String[] parts = line.split("\\s+");
    if (parts.length >= 8 && !parts[7].equals("NA")) {
      int origin = int(parts[7]) - 1;
      originCounts[origin]++;
    }
  }
}
void program5() 
{
  background(255); // White Background
  // Draw X and Y axis
  stroke(0);
  line(50, height - 50, width - 50, height - 50); // X-axis
  line(50, height - 50, 50, 50); // Y-axis
  
  // Draw axis labels
  textAlign(CENTER, CENTER);
  fill(0);
  for (int i = 0; i <= 5; i++) {
    int x = int(map(i * 10, 0, 50, 50, width - 50));
    text(i * 10, x, height - 35);
  }
  for (int i = 1; i <= 5; i++) {
    int y = int(map(i * 50, 0, 300, height - 50, 50));
    text(i * 50, 35, y);
  }
  text("MPG", width / 2, height - 20); // X-axis label
  
 
  pushMatrix();
  translate(10, height / 2); 
  rotate(-HALF_PI); 
  text("Horsepower", 0, -2);
  popMatrix();
  
  for (int i = 0; i < totalVecs; i++) {
    if (mpgValues[i] != 0 && horsepowerValues[i] != 0) {
      int x = int(map(mpgValues[i], 0, 50, 50, width - 50));
      int y = int(map(horsepowerValues[i], 0, 300, height - 50, 50));
      noStroke();
      fill(255, 75, 75);
      ellipse(x, y, 5, 5);
      
      // Display details when the mouse is over the dot
      if (dist(mouseX, mouseY, x, y) < 5) {
        fill(0);
        textAlign(LEFT);
        text("MPG: " + mpgValues[i], x + 10, y - 10);
        text("Horsepower: " + horsepowerValues[i], x + 10, y + 10);
      }
    }
  }
}

void program6() 
{
  background(255); // White Background
  // Draw X and Y axis
  stroke(0);
  line(50, height - 50, width - 50, height - 50); // X-axis
  line(50, height - 50, 50, 50); // Y-axis
  
  // Draw axis labels
  textAlign(CENTER, CENTER);
  fill(0);
  
  // X-axis labels (0 to 250 with a difference of 50)
  for (int i = 0; i <= 5; i++) {
    int x = int(map(i * 50, 0, 250, 50, width - 50));
    text(i * 50, x, height - 35);
  }
  
  // Y-axis labels (0 to 25 with a difference of 5)
  for (int i = 0; i <= 5; i++) {
    int y = int(map(i * 5, 0, 25, height - 50, 50));
    text(i * 5, 35, y);
  }
  
  text("Horsepower", width / 2, height - 20); // X-axis label
  
  pushMatrix();
  translate(20, height / 2); // Position of the label
  rotate(-HALF_PI); 
  text("Acceleration (0 to 60 mph)", 0, -10);
  popMatrix();
  
  for (int i = 0; i < totalVecs; i++) {
    if (horsepowerValues[i] != 0 && accelerationValues[i] != 0) {
      int x = int(map(horsepowerValues[i], 0, 250, 50, width - 50));
      int y = int(map(accelerationValues[i], 0, 25, height - 50, 50));
      noStroke();
      fill(255, 75, 75);
      ellipse(x, y, 5, 5);
      
      // Display details when mouse is over the dot
      if (dist(mouseX, mouseY, x, y) < 5) {
        fill(0);
        textAlign(LEFT);
        text("Horsepower: " + horsepowerValues[i], x + 10, y - 10);
        text("Acceleration: " + accelerationValues[i] + " sec.", x + 10, y + 10);
      }
    }
  }
}


void program7() {
  background(255); // White Background

  // Define cell size and colors
  int cellSize = 60;
 
  float heatmapWidth = numVariables * cellSize;
  float heatmapHeight = numVariables * cellSize;
  float xPosition = (width - heatmapWidth) / 2;
  float yPosition = (height - heatmapHeight) / 2;

  for (int i = 0; i < numVariables; i++) {
    fill(0);
    textAlign(RIGHT);
    text(parameterNames[i], xPosition - 20, yPosition + i * cellSize + cellSize / 2);
  }

  for (int i = 0; i < numVariables; i++) {
    fill(0);
    textAlign(CENTER);
    translate(xPosition + i * cellSize + cellSize / 2, yPosition + numVariables * cellSize + 40);
    rotate(PI/4); 
    text(parameterNames[i], 0, 0);
    rotate(-PI/4); 
    translate(-(xPosition + i * cellSize + cellSize / 2), -(yPosition + numVariables * cellSize + 40));
  }

  // Draw the heatmap with green color
  for (int i = 0; i < numVariables; i++) {
    for (int j = 0; j < numVariables; j++) {
      float c = map(corr[i][j], minCorrelation, maxCorrelation, 0, 255);
      fill(0, 255, 0, c); // Green color
      rect(xPosition + i * cellSize, yPosition + j * cellSize, cellSize, cellSize);
    }
  }
}


void calculateCorrelation() 
{
  // Calculate correlation coefficients and store in the 'corr' array
  corr = new float[numVariables][numVariables];
  for (int i = 0; i < numVariables; i++) {
    for (int j = 0; j < numVariables; j++) {
      corr[i][j] = calculateCorrelationCoefficient(i, j);
    }
  }
}

float calculateCorrelationCoefficient(int variable1, int variable2) {
  float sumXY = 0;
  float sumX = 0;
  float sumY = 0;
  float sumXSquare = 0;
  float sumYSquare = 0;
  int validDataCount = 0;

  for (int i = 0; i < data.length; i++) {
    float x = data[i][variable1];
    float y = data[i][variable2];
    if (!Float.isNaN(x) && !Float.isNaN(y)) {
      sumXY += x * y;
      sumX += x;
      sumY += y;
      sumXSquare += x * x;
      sumYSquare += y * y;
      validDataCount++;
    }
  }

  if (validDataCount == 0) {
    return 0; // Return 0 for cases where there's no valid data
  }

  float n = validDataCount;
  float denominatorX = sqrt(n * sumXSquare - sumX * sumX);
  float denominatorY = sqrt(n * sumYSquare - sumY * sumY);

  if (denominatorX == 0 || denominatorY == 0) {
    return 0; // Return 0 for cases where division by zero occurs
  }

  float numerator = n * sumXY - sumX * sumY;
  return numerator / (denominatorX * denominatorY);
}

void program8() 
{
  background(255); // White Background
  dataL = loadStrings("cars.data"); 
  int numCars = dataL.length; 
  carModels = new String[numCars];
  fuelEfficiency = new float[numCars];
  int validDataCount = 0; 

  
  for (int i = 0; i < numCars; i++) {
    String[] parts = splitTokens(dataL[i]);
    carModels[i] = parts[8].replaceAll("\"", ""); 
    carModels[i] = (carModels[i]).toUpperCase(); 
    float efficiencyValue = float(parts[0]);

    if (!Float.isNaN(efficiencyValue)) {
      fuelEfficiency[validDataCount] = efficiencyValue; 
      validDataCount++;
    }
  }

  carModels = subset(carModels, 0, validDataCount);
  fuelEfficiency = subset(fuelEfficiency, 0, validDataCount);

  for (int i = 0; i < fuelEfficiency.length; i++) {
    for (int j = i + 1; j < fuelEfficiency.length; j++) {
      if (fuelEfficiency[i] < fuelEfficiency[j]) {
        float tempEfficiency = fuelEfficiency[i];
        fuelEfficiency[i] = fuelEfficiency[j];
        fuelEfficiency[j] = tempEfficiency;

        String tempModel = carModels[i];
        carModels[i] = carModels[j];
        carModels[j] = tempModel;
      }
    }
  }

  int topN = min(20, validDataCount);

  for (int i = 0; i < topN; i++) {
    float x = map(fuelEfficiency[i], 0, max(fuelEfficiency), 100, width - 150) * 0.8; 
    float y = height - 700 + i * 30; 

    textAlign(RIGHT, CENTER); 
    textSize(12);
    fill(0);
    text(carModels[i], 90, y + 10); 

    fill(200, 255, 255); 
    rect(100, y, x - 100, 20);

    textAlign(LEFT, CENTER); 
    fill(0);
    text(nf(fuelEfficiency[i], 1, 1), x + 10, y + 10); 
  }

  stroke(0);
  line(100, height - 1, width - 100, height - 1); 
  
}
