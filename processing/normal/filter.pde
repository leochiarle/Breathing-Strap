Queue<Float> ecgWindow = new ArrayDeque<Float>();
Queue<Float> respWindow = new ArrayDeque<Float>();

float smooth(Queue<Float> window, float value, int size) {
    window.add(value);
    if (window.size() > size) window.poll();
    float sum = 0;
    for (float v : window) sum += v;
    return sum / window.size();
}
