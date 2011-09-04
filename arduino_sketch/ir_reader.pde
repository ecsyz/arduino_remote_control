#include <IRremote.h>
#include <IRremoteInt.h>

int RECV_PIN = 53;
int led=13;
int last_received;
IRrecv irrecv(RECV_PIN);
decode_results results;

// Setup
void setup(){
  Serial.begin(115200);
  irrecv.enableIRIn(); // inicia o reciver IR
  pinMode(led,OUTPUT);
}

void bip() {
 digitalWrite(led,HIGH);
 delay(100);
 digitalWrite(led,LOW);
}

// Loop
void loop() {
  if (irrecv.decode(&results)) {
    bip();
    irrecv.resume();
    Serial.println(results.value,DEC);
  }
}

