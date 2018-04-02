# Electric Imp test project

This test project contains an application integrated with Ubidots.com IoT platform to send and collect data from the HTS221(Temp/Hum) sensor and to control the LED on impExplorer Kit.

My dashboard at Ubidots.com, for example: [here](https://app.ubidots.com/ubi/public/getdashboard/page/PlZ-K3cT9O4s_i-nVG8wEL3ko60).

The app uses the REST API of the Ubidots.com platform through the ["Ubidots.agent.lib.nut:1.0.0"](https://github.com/electricimp/ubidots/tree/v1.0.0) library.

## How to use?

1. Sign up at [Ubidots.com (for education)](https://app.ubidots.com/accounts/signup/)
2. Get into your account
3. Create new device or use the existing one
4. Set API label for your device
5. Create three variables of type "Default" in the device: LED, Temperature and Humidity
6. Set API labels for these variables to "led", "temperature" and "humidity"
7. Set UBIDOTS_TOKEN in agent.nut to your token (click at your username, then "API Credentials")
8. Set UBIDOTS_DEVICE_LABEL in agent.nut to API label you set (step 4)
9. Run app and copy URLs for LED On/Off (like https://agent.electricimp.com/XXXXXXXXXXXX?led=1)
10. Add two events for your device on variable LED:
	1. if LED value equal to 0 then WebHook (METHOD = GET, URL = LED Off from step 9)
	2. if LED value equal to 1 then WebHook (METHOD = GET, URL = LED On from step 9)
11. Great! Now you can make widgets on your dashboard: charts for Temperature and Humidity and control->switch for LED


