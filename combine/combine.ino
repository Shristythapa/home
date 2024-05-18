#include <ESP8266WiFi.h>
#include <FirebaseArduino.h>
#include <ESP8266WiFiMulti.h>
ESP8266WiFiMulti wifiMulti;

#define LED D8  
#define FAN_PIN D5
#define FAN_OFF LOW
#define FAN_ON HIGH

#define FIREBASE_HOST "home-bb179-default-rtdb.firebaseio.com"
#define FIREBASE_AUTH "8wCzAchwOvxuQ5FdFS1aOVaLQQ5MibXk7BqUEA0n"

const char* fanControlPath = "/FanControl";
const char* lightControlPath = "/lightControl";
const char* lightStatusPath = "/lightStatus";

#include <DHT.h>
#define DHTPIN 4    
#define DHTTYPE DHT22   
DHT dht(DHTPIN, DHTTYPE);


void setup() {
  Serial.begin(115200);
  pinMode(LED, OUTPUT);
  pinMode(FAN_PIN, OUTPUT);
  dht.begin();

  wifiMulti.addAP("suary_wlink", "8628586833456+X");

  Serial.println("Connecting to WiFi");
  while (wifiMulti.run() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nConnected to WiFi");

  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  Serial.println("Connected to Firebase");
}

void loop() {
  readTemp();
  fan();
  light();

}

void readTemp(){

  float humidity = dht.readHumidity();
  float temperature = dht.readTemperature();

  if (isnan(humidity) || isnan(temperature)) {
    Serial.println("Failed to read from DHT sensor!");
    return;
  }

  Serial.print("Humidity: ");
  Serial.print(humidity);
  Serial.print("%\t");
  Serial.print("Temperature: ");
  Serial.print(temperature);
  Serial.println("°C");
    Firebase.setFloat("temperature", temperature);
  if (Firebase.failed()) {
    Serial.print("Firebase set failed:");
    Serial.println(Firebase.error());
  }
  
  delay(1000);
}

void fan(){
     FirebaseObject pathOfFan = Firebase.get(fanControlPath);
  if (Firebase.failed()) {
    Serial.print("Firebase get failed:");
    Serial.println(Firebase.error());
    return;
  }
  String fanControlValue = pathOfFan.getString("FanStatus");

  Serial.print("fan:");
  Serial.println(fanControlValue);

  if (fanControlValue == "ON") {
    digitalWrite(FAN_PIN, LOW);
    Serial.println("Fan on");
  } else if (fanControlValue == "OFF") {
    digitalWrite(FAN_PIN, HIGH);
    Serial.println("Fan off");
  }

  delay(1000);
}

void light(){
    // Light Control
  FirebaseObject pathOfLight = Firebase.get(lightControlPath);
  if (Firebase.failed()) {
    Serial.print("Firebase get failed:");
    Serial.println(Firebase.error());
    return;
  }
  String lightControlValue = pathOfLight.getString("lightStatus");

  Serial.print("light:");
  Serial.println(lightControlValue);

  if (lightControlValue == "ON") {
    digitalWrite(LED, HIGH);
    Serial.println("Light on");
  } else if (lightControlValue == "OFF") {
    digitalWrite(LED, LOW);
    Serial.println("Light off");
  }

  delay(1000);
}
