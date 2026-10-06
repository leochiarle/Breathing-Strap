int lastSampleMs = 0;

float ecg, resp;

void onSample(float e, float r) {
    ecg = e;
    resp = r;

    push_ecg_value(e);
    push_rr_value(r);
    calculateBpm(e);
    calculateRpm(r);
}

void mockSamples() {
  for (; millis() - lastSampleMs >= 10; lastSampleMs += 10) {
    float t = lastSampleMs / 1000.0;
    float ecg = 512 + (t % 0.8 < 0.05 ? 300 : 0) + random(-10, 10);
    float resp = 512 + 200 * sin(TWO_PI * t / 5);
    onSample(ecg, resp);
  }
}
