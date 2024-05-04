#include <ESP8266WiFi.h>
#include <ESP8266WiFiMulti.h>
#include <FirebaseArduino.h>

ESP8266WiFiMulti wifiMulti;

#define LED D8


#include <DHT.h>

#define DHTPIN 4     // Digital pin connected to the DHT sensor
#define DHTTYPE DHT22   // DHT 22 (AM2302)

DHT dht(DHTPIN, DHTTYPE);



#define FIREBASE_HOST "home-bb179-default-rtdb.firebaseio.com"
#define FIREBASE_AUTH "8wCzAchwOvxuQ5FdFS1aOVaLQQ5MibXk7BqUEA0n"

const char* lightControlPath = "/lightControl";
const char* lightStatusPath = "/lightStatus";

void setup() {
  Serial.begin(115200);
  pinMode(LED, OUTPUT);

  wifiMulti.addAP("Shristy", "thisisnoy@makemestrong12333");

  Serial.println("Connecting ...");

  while (wifiMulti.run() != WL_CONNECTED) {
    delay(250);
    Serial.print('.');
  }

  Serial.println('\n');
  Serial.print("Connected to ");
  Serial.println(WiFi.SSID());
  Serial.print("IP address:\t");
  Serial.println(WiFi.localIP());

  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
  
  if (Firebase.failed()) {
    Serial.print("Firebase connection failed: ");
    Serial.println(Firebase.error());
  } else {
    Serial.println("Firebase Connected");
    Firebase.setString("Senura/Value", "0");
  }

   dht.begin();
 
}
void loop() {
    if (Firebase.failed()) {
        Serial.print("Firebase retrieval failed: ");
        Serial.println(Firebase.error());
        return;
    }

    String lightControlValue = Firebase.getString("lightControl/lightStatus");

    if (lightControlValue.length() > 0) {
        // Value retrieved successfully
        Serial.print("Light Status: ");
        Serial.println(lightControlValue);

        if (lightControlValue == "ON") {
            digitalWrite(LED, HIGH);
        } else {
            digitalWrite(LED, LOW);
        }
    } else {
        // Value is empty
        Serial.println("Empty light status value.");
    }



   delay(2000);  // Wait a few seconds between measurements.

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
}
