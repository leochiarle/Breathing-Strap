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

// plot area inside a card: leaves room for title, y labels and x labels
float plotX(float x) { return x + 62; }
float plotY(float y) { return y + 42; }
float plotW(float w) { return w - 84; }
float plotH(float h) { return h - 42 - 38; }

void drawGraph(String title, Float[] data, float x, float y, float w, float h, float yMax, color c) {
    card(x, y, w, h);
    label(title.toUpperCase(), x + 22, y + 28, 11, C_DIM, LEFT, false);
    float px0 = plotX(x), py0 = plotY(y), pw = plotW(w), ph = plotH(h);

    noFill();
    // glow passes, then crisp line
    for (int pass = 0; pass < 3; pass++) {
        stroke(red(c), green(c), blue(c), pass < 2 ? 22 : 255);
        strokeWeight(pass == 0 ? 7 : pass == 1 ? 4 : 1.8);
        strokeJoin(ROUND);
        beginShape();
        for (int i = 0; i < data.length; i++) {
            float px = px0 + map(i, 0, BUFFER_SIZE - 1, 0, pw);
            float py = py0 + ph - map(constrain(data[i], 0, yMax), 0, yMax, 0, ph);
            vertex(px, py);
        }
        endShape();
    }
    strokeWeight(1);
}

void drawAxes(float x, float y, float w, float h, String xLabel, String yLabel, float xMin, float xMax, float yMin, float yMax) {
    float px0 = plotX(x), py0 = plotY(y), pw = plotW(w), ph = plotH(h);
    for (int k = 0; k <= 4; k++) {
        float f = k / 4.0;

        float tx = px0 + f * pw;
        label(nf(lerp(xMin, xMax, f), 0, 1), tx, py0 + ph + 20, 10, C_DIM, CENTER, false);

        float ty = py0 + ph - f * ph;
        stroke(255, 255, 255, k == 0 ? 50 : 16);
        line(px0, ty, px0 + pw, ty);
        label(nf(lerp(yMin, yMax, f), 0, 0), px0 - 10, ty + 4, 10, C_DIM, RIGHT, false);
    }
    label(xLabel, px0 + pw / 2, py0 + ph + 34, 10, C_DIM, CENTER, false);
    label(yLabel, x + w - 22, y + 28, 10, C_DIM, RIGHT, false);
    textAlign(LEFT, BASELINE);
}

void drawModePanel() {
    float x = 928, y = 216, w = 328, h = 292;
    card(x, y, w, h);
    label(mode.toUpperCase() + " MODE", x + 22, y + 28, 11, C_DIM, LEFT, false);
    float lx = x + 22, rx = x + w - 22;

    if (mode.equals("Fitness")) {
      for (int i = 0; i < 5; i++) {
          float ry = y + 50 + i * 48;
          glowDot(lx + 5, ry + 12, 4, zoneColors[i]);
          label(zoneNames[i], lx + 22, ry + 17, 14, C_TEXT, LEFT, true);
          label(zoneN[i] + " s", rx, ry + 17, 14, C_TEXT, RIGHT, true);
          String line = "-";
          if (zoneInh[i] != 0) {
              line = "RR " + nf(zoneRr[i] - restingRr, 0, 1)
                   + "   in " + nf(zoneInh[i] / 1000.0, 0, 1) + " s"
                   + "   out " + nf(zoneExh[i] / 1000.0, 0, 1) + " s";
          }
          label(line, lx + 22, ry + 35, 10, C_DIM, LEFT, false);
      }
    } else if (mode.equals("Stress")) {
        String st = stressState();
        color sc = st.equals("Calm") ? #34D399 : st.equals("Elevated") ? #FBBF24 : st.equals("Stressed") ? #F43F5E : C_DIM;
        glowDot(x + w / 2, y + 100, 30, sc);
        label(st.toUpperCase(), x + w / 2, y + 180, 28, sc, CENTER, true);
        label("vs. resting baseline", x + w / 2, y + 204, 11, C_DIM, CENTER, false);
        label("HR " + nf(bpm, 0, 0) + " / " + nf(restingHr, 0, 0), lx, y + 262, 12, C_TEXT, LEFT, true);
        label("RR " + nf(rpm, 0, 0) + " / " + nf(restingRr, 0, 0), rx, y + 262, 12, C_TEXT, RIGHT, true);
    } else {
        boolean lost = badBreaths >= 3;
        color mc = lost ? #F43F5E : #34D399;
        glowDot(x + w / 2, y + 100, 30 + (lost ? (millis() / 250) % 2 * 4 : 0), mc);
        label(lost ? "PATTERN LOST" : "PATTERN OK", x + w / 2, y + 180, 24, mc, CENTER, true);
        label("target: inhale at most half the exhale", x + w / 2, y + 204, 11, C_DIM, CENTER, false);
        label("BAD BREATHS IN A ROW", lx, y + 262, 10, C_DIM, LEFT, false);
        label("" + badBreaths, rx, y + 264, 16, C_TEXT, RIGHT, true);
    }
    textAlign(LEFT, BASELINE);
}
