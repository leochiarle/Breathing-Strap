import processing.serial.*;

String PORT_NAME = "/dev/ttyACM0";
int baudrate = 115200;
Serial port;
String[] items = new String[2];

void setupSerial() {
    printArray(Serial.list());
    port = new Serial(this, PORT_NAME, baudrate);
    port.bufferUntil('\n');
}

void serialEvent(Serial p) {
    String line = p.readStringUntil('\n');
    if (line == null) return;
    line = trim(line);
    println("serial: '" + line + "'");
    
    items = split(line, ','); 
    
    if (!items[0].equals("!")){
      onSample(float(items[0]), float(items[1]));
    }else{
      onSample(float(0), float(items[1]));
    }
}
