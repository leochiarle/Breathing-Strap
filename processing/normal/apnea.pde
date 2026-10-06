void drawApnea() {
    int since = millis() - lastRespMs;
    if (lastRespMs > 0 && since > 10000) {
        fill(255, 0, 0);
        rect(300, 450, 400, 60);
        fill(255);
        text("APNEA ALERT: no breath for " + since / 1000 + " s", 320, 485);
    }
}
