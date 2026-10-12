PImage bgImg;
float orbR = 40;
PFont fontBold, fontReg;

final color C_BG1 = #070A12;
final color C_BG2 = #131A2E;
final color C_TEXT = #F1F5F9;
final color C_DIM = #8A94A8;
final color C_ECG = #22D3EE;
final color C_RESP = #A78BFA;
final color C_HEART = #FB7185;

void setup() {
    size(1280, 840);
    fontReg = createFont("Helvetica Neue", 14, true);
    fontBold = createFont("Helvetica Neue Bold", 14, true);
    textFont(fontReg);
    buildBackground();
    setupSerial();
    startBaseline();
    initChartHistory(ecg_history);
    initChartHistory(rr_history);
    initChartHistory(hr_history);
}

void keyPressed() {
    if (key == 'f') setMode("Fitness");
    if (key == 's') setMode("Stress");
    if (key == 'm') setMode("Meditation");
    if (key == 'r') showSummary = !showSummary;
    if (key >= '0' && key <= '9' && ageStr.length() < 3) ageStr += key;
    if (key == BACKSPACE && ageStr.length() > 0) ageStr = ageStr.substring(0, ageStr.length() - 1); updateAge();
}

void buildBackground() {
    PGraphics g = createGraphics(width, height);
    g.beginDraw();
    g.noStroke();
    for (int y = 0; y < height; y++) {
        g.stroke(lerpColor(C_BG2, C_BG1, y / (float) height));
        g.line(0, y, width, y);
    }
    // soft colored glows in the corners
    g.noStroke();
    for (int i = 40; i > 0; i--) {
        g.fill(34, 211, 238, 1.4);
        g.ellipse(80, 40, i * 22, i * 22);
        g.fill(167, 139, 250, 1.4);
        g.ellipse(width - 60, height - 40, i * 24, i * 24);
    }
    g.endDraw();
    bgImg = g.get();
}

void draw() {
    image(bgImg, 0, 0);

    drawHeader();
    drawStats();

    float span = millis()/1000;

    drawGraph("ECG", ecg_history, 24, 216, 880, 196, 1023, C_ECG);
    drawAxes(24, 216, 880, 196, "Time (s)", "ECG", 0, span, 150, 1023);

    drawGraph("Respiration", rr_history, 24, 428, 880, 176, 400, C_RESP);
    drawAxes(24, 428, 880, 176, "Time (s)", "FSR", 0, span, 0, 400);

    drawZoneGraph("Cardio zone", hr_history, 24, 620, 880, 196);
    drawAxes(24, 620, 880, 196, "Time (s)", "Heart rate (bpm)", 0, span, 0, maxHr);

    drawModePanel();
    drawOrbCard();
    drawAgeCard();

    if (showSummary) drawSummary();
}

void onSample(float e, float r) {
    if (sampleCount++ == 0) firstSampleMs = millis();
    pushValue(ecg_history, e);
    pushValue(rr_history, r);
    calculateBpm(e);
    calculateRpm(r);
    calculateBreath(r);
    updateBaseline();
    updateZones();
}

// ---------- UI pieces ----------

void drawHeader() {
    // logo mark
    noStroke();
    for (int i = 5; i > 0; i--) { fill(34, 211, 238, 18); ellipse(46, 46, 14 + i * 7, 14 + i * 7); }
    fill(C_ECG);
    ellipse(46, 46, 14, 14);
    label("BREATHING STRAP", 70, 36, 20, C_TEXT, LEFT, true);
    label("LIVE BIOMETRIC MONITOR", 70, 60, 10, C_DIM, LEFT, false);

    // mode pills
    String[] names = {"Fitness", "Stress", "Meditation"};
    String[] keys = {"F", "S", "M"};
    float px = 1256;
    for (int i = 2; i >= 0; i--) {
        boolean on = mode.equals(names[i]);
        float w = names[i].length() * 8 + 58;
        px -= w;
        fill(on ? color(34, 211, 238, 230) : color(255, 255, 255, 14));
        stroke(on ? color(34, 211, 238) : color(255, 255, 255, 28));
        rect(px, 28, w, 36, 18);
        label(keys[i], px + 20, 46, 10, on ? C_BG1 : C_DIM, CENTER, true);
        label(names[i], px + 34, 46, 13, on ? C_BG1 : C_TEXT, LEFT, on);
        px -= 10;
    }
}

void drawStats() {
    float y = 88, h = 110, w = 296, gap = 16;

    // Heart rate
    float x = 24;
    card(x, y, w, h);
    label("HEART RATE", x + 20, y + 26, 11, C_DIM, LEFT, false);
    label(bpm > 0 ? nf(bpm, 0, 0) : "--", x + 20, y + 84, 52, C_TEXT, LEFT, true);
    label("bpm", x + 20 + textWidth(bpm > 0 ? nf(bpm, 0, 0) : "--") + 8, y + 84, 14, C_DIM, LEFT, false);
    float beat = bpm > 0 ? pow(max(0, 1 - ((millis() % (int) (60000 / bpm)) / 220.0)), 2) : 0;
    glowDot(x + w - 38, y + 40, 8 + beat * 6, C_HEART);
    String zoneText = baselineDone && bpm > 0 ? zoneNames[zoneOf(bpm)] : "warming up";
    label(zoneText.toUpperCase(), x + w - 20, y + 92, 10, baselineDone && bpm > 0 ? zoneColors[zoneOf(bpm)] : C_DIM, RIGHT, true);

    // Respiration
    x += w + gap;
    card(x, y, w, h);
    label("RESPIRATION", x + 20, y + 26, 11, C_DIM, LEFT, false);
    label(rpm > 0 ? nf(rpm, 0, 0) : "--", x + 20, y + 84, 52, C_TEXT, LEFT, true);
    label("/min", x + 20 + textWidth(rpm > 0 ? nf(rpm, 0, 0) : "--") + 8, y + 84, 14, C_DIM, LEFT, false);
    glowDot(x + w - 38, y + 40, 8 + (inhaling ? 4 : 0), C_RESP);

    // Inhale / exhale
    x += w + gap;
    card(x, y, w, h);
    label("BREATH TIMING", x + 20, y + 26, 11, C_DIM, LEFT, false);
    float tot = max(inhaleMs + exhaleMs, 1);
    label("IN", x + 20, y + 58, 11, C_RESP, LEFT, true);
    label(nf(inhaleMs / 1000.0, 0, 1) + " s", x + w - 20, y + 58, 14, C_TEXT, RIGHT, true);
    bar(x + 50, y + 52, w - 150, 6, inhaleMs / tot, C_RESP);
    label("OUT", x + 20, y + 88, 11, C_ECG, LEFT, true);
    label(nf(exhaleMs / 1000.0, 0, 1) + " s", x + w - 20, y + 88, 14, C_TEXT, RIGHT, true);
    bar(x + 50, y + 82, w - 150, 6, exhaleMs / tot, C_ECG);

    // Baseline
    x += w + gap;
    card(x, y, w, h);
    label("BASELINE", x + 20, y + 26, 11, C_DIM, LEFT, false);
    if (!baselineDone) {
        float p = constrain((millis() - baselineStartMs) / (float) BASELINE_MS, 0, 1);
        int left = ceil((BASELINE_MS - (millis() - baselineStartMs)) / 1000.0);
        label("Hold still", x + 20, y + 60, 20, C_TEXT, LEFT, true);
        label(left + " s left", x + w - 20, y + 60, 13, C_DIM, RIGHT, false);
        bar(x + 20, y + 80, w - 40, 8, p, #FBBF24);
    } else {
        label("RESTING HR", x + 20, y + 58, 10, C_DIM, LEFT, false);
        label(nf(restingHr, 0, 1) + " bpm", x + w - 20, y + 58, 16, C_TEXT, RIGHT, true);
        label("RESTING RR", x + 20, y + 88, 10, C_DIM, LEFT, false);
        label(nf(restingRr, 0, 1) + " /min", x + w - 20, y + 88, 16, C_TEXT, RIGHT, true);
    }
}

void drawOrbCard() {
    float x = 928, y = 524, w = 328, h = 222;
    card(x, y, w, h);
    label("BREATH", x + 20, y + 26, 11, C_DIM, LEFT, false);
    orbR = lerp(orbR, inhaling ? 62 : 34, 0.06);
    float cx = x + w / 2, cy = y + h / 2 + 8;
    color c = inhaling ? C_RESP : C_ECG;
    noStroke();
    for (int i = 14; i > 0; i--) {
        fill(red(c), green(c), blue(c), 9);
        ellipse(cx, cy, orbR * 2 + i * 9, orbR * 2 + i * 9);
    }
    fill(red(c), green(c), blue(c), 70);
    stroke(c);
    strokeWeight(2);
    ellipse(cx, cy, orbR * 2, orbR * 2);
    strokeWeight(1);
    label(inhaling ? "INHALE" : "EXHALE", cx, cy + 5, 13, C_TEXT, CENTER, true);
}

void drawAgeCard() {
    float x = 928, y = 762, w = 328, h = 54;
    card(x, y, w, h);
    label("AGE", x + 20, y + 32, 11, C_DIM, LEFT, false);
    String a = ageStr.length() > 0 ? ageStr : "_";
    label(a + ((millis() / 500) % 2 == 0 ? "|" : ""), x + 64, y + 34, 18, C_TEXT, LEFT, true);
    label("MAX HR  " + maxHr, x + w - 20, y + 32, 12, C_DIM, RIGHT, true);
}

// ---------- helpers ----------

void label(String s, float x, float y, float size, color c, int align, boolean bold) {
    textFont(bold ? fontBold : fontReg);
    textSize(size);
    textAlign(align, BASELINE);
    fill(c);
    noStroke();
    text(s, x, y);
}

void card(float x, float y, float w, float h) {
    noStroke();
    fill(0, 0, 0, 40);
    rect(x, y + 4, w, h, 18);
    fill(255, 255, 255, 12);
    stroke(255, 255, 255, 26);
    strokeWeight(1);
    rect(x, y, w, h, 18);
    noStroke();
}

void bar(float x, float y, float w, float h, float p, color c) {
    noStroke();
    fill(255, 255, 255, 20);
    rect(x, y, w, h, h);
    fill(c);
    rect(x, y, max(w * constrain(p, 0, 1), h), h, h);
}

void glowDot(float x, float y, float r, color c) {
    noStroke();
    for (int i = 6; i > 0; i--) {
        fill(red(c), green(c), blue(c), 14);
        ellipse(x, y, r * 2 + i * 6, r * 2 + i * 6);
    }
    fill(c);
    ellipse(x, y, r * 2, r * 2);
}
