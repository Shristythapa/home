
#define LED D8
#include <DHT.h>

#define DHTPIN 4     // Digital pin connected to the DHT sensor
#define DHTTYPE DHT22   // DHT 22 (AM2302)

DHT dht(DHTPIN, DHTTYPE);

void setup() {
  Serial.begin(9600);
   pinMode(LED, OUTPUT);
  dht.begin();
}

void loop() {
  delay(2000);  // Wait a few seconds between measurements.
  String lightControlValue = "ON";
   if (lightControlValue == "ON") {
            digitalWrite(LED, HIGH);
        } else {
            digitalWrite(LED, LOW);
        }

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

  
}
