import java.util.*;

Queue<Float> ecg_history = new ArrayDeque<Float>();
Queue<Float> rr_history = new ArrayDeque<Float>();

void push_ecg_value(Float value) {
    if (ecg_history.size() == 500) {
        ecg_history.poll();
    }
    ecg_history.add(value);
}

void push_rr_value(Float value) {
    if (rr_history.size() == 500) {
        rr_history.poll();
    }
    rr_history.add(value);
}

void drawGraph(String title, Queue<Float> data, float x, float y, float w, float h) {
    fill(0);
    text(title, x, y - 8);
    stroke(0);
    noFill();
    rect(x, y, w, h);
    float prevX = 0, prevY = 0;
    int i = 0;
    for (float v : data) {
        float px = x + map(i, 0, 499, 0, w);
        float py = y + h - map(v, 0, 1023, 0, h);

        if (i > 0) line(prevX, prevY, px, py);
        prevX = px;
        prevY = py;
        i++;
    }
}
