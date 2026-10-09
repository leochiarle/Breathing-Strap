int BUFFER_SIZE = 500;
Float[] ecg_history = new Float[BUFFER_SIZE];
Float[] rr_history = new Float[BUFFER_SIZE];
int sampleCount = 0;
int firstSampleMs = 0;

float graphSeconds() {
    if (sampleCount < 2) return 0;
    float hz = 1000.0 * sampleCount / (millis() - firstSampleMs);
    return BUFFER_SIZE / hz;
}

void initChartHistory(Float[] q) {
  for (int i = 0; i < BUFFER_SIZE; i++) {
    q[i] = 0.0;
  }
}

void pushValue(Float[] q, float value) {
    for (int i = 0; i < BUFFER_SIZE - 1; i++) {
      q[i] = q[i + 1];
    }
    q[BUFFER_SIZE - 1] = value;
}

void drawGraph(String title, Float[] data, float x, float y, float w, float h, float yMax) {
    fill(0);
    text(title, x, y - 8);
    stroke(0);
    noFill();
    rect(x, y, w, h);
    
    beginShape();
    for (int i = 0; i < data.length; i++) {
        float px = x + map(i, 0, BUFFER_SIZE - 1, 0, w);
        float py = y + h - map(constrain(data[i], 0, yMax), 0, yMax, 0, h);
        vertex(px, py);
    }
    endShape();
}

void drawAxes(float x, float y, float w, float h, String xLabel, String yLabel, float xMin, float xMax, float yMin, float yMax) {
    fill(0);
    stroke(0);
    textSize(11);
    for (int k = 0; k <= 4; k++) {
        float f = k / 4.0;

        float tx = x + f * w;
        line(tx, y + h, tx, y + h + 4);
        textAlign(CENTER, TOP);
        text(nf(lerp(xMin, xMax, f), 0, 1), tx, y + h + 6);

        stroke(128, 80);                 // gray, with low opacity
        float ty = y + h - f * h;
        line(x - 4, ty, width - 20, ty);
        textAlign(RIGHT, CENTER);
        text(nf(lerp(yMin, yMax, f), 0, 0), x - 7, ty);
        
        stroke(0);
    }

    textAlign(CENTER, TOP);
    text(xLabel, x + w / 2, y + h + 20);

    pushMatrix();
    translate(x - 48, y + h / 2);
    rotate(-HALF_PI);
    textAlign(CENTER, BOTTOM);
    text(yLabel, 0, 0);
    popMatrix();

    textAlign(LEFT, BASELINE);
    textSize(12);
}
