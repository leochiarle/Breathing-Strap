float bpm = 0;
float prevEcg = 0;
float ecgMin = 512, ecgMax = 512;
int lastBeatMs = 0;

float[] rr = new float[5];   // last 5 beat intervals (ms)
int rrN = 0;

void calculateBpm(float ecg) {
    int now = millis();

    // peak-hold min/max that slowly relax toward the signal
    ecgMax = max(ecg, ecgMax + (ecg - ecgMax) * 0.002);
    ecgMin = min(ecg, ecgMin + (ecg - ecgMin) * 0.002);
    float thr = ecgMin + 0.6 * (ecgMax - ecgMin);
    boolean hasSignal = (ecgMax - ecgMin) > 100;

    boolean crossed = prevEcg < thr && ecg >= thr;
    if (hasSignal && crossed && now - lastBeatMs >= 300) {
        int interval = now - lastBeatMs;
        if (lastBeatMs > 0 && interval <= 1500) {
            rr[rrN % 5] = interval;
            rrN++;
            int c = min(rrN, 5);
            bpm = 60000.0 / sort(subset(rr, 0, c))[c / 2];
        }
        lastBeatMs = now;
    }
    prevEcg = ecg;
}

int lastRespMs = 0;
float rpm = 0;
float prevResp = 0;

void calculateRpm(float resp) {
    if (prevResp < 512 && resp >= 512) {
        int now = millis();
        if (lastRespMs > 0) {
            rpm = 60000.0 / (now - lastRespMs);
        }
        lastRespMs = now;
    }
    prevResp = resp;
}

int lastRiseMs = 0;
int lastFallMs = 0;
int inhaleMs = 0;
int exhaleMs = 0;
float prevBreath = 512;

void calculateBreath(float resp) {
    int now = millis();
    if (prevBreath < 512 && resp >= 512) {
        if (lastFallMs > 0) exhaleMs = now - lastFallMs;
        lastRiseMs = now;
    } else if (prevBreath >= 512 && resp < 512) {
        if (lastRiseMs > 0) inhaleMs = now - lastRiseMs;
        lastFallMs = now;
    }
    prevBreath = resp;
}
