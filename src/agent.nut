#require "Ubidots.agent.lib.nut:1.0.0"

const UBIDOTS_TOKEN = "<YOUR UBIDOTS.COM API TOKEN>";
const UBIDOTS_DEVICE_LABEL = "YOUR DEVICE LABEL";

ubidots <- Ubidots.Client(UBIDOTS_TOKEN);
ubidots.setDeviceLabel(UBIDOTS_DEVICE_LABEL);

// Log the URLs we need to control the LED
server.log("Turn LED On: " + http.agenturl() + "?led=1");
server.log("Turn LED Off: " + http.agenturl() + "?led=0");

// Handler for incoming HTTP requests
function requestHandler(request, response) {
  try {
    // Check if the user sent led as a query parameter
    if ("led" in request.query) {
        if (request.query.led == "1" || request.query.led == "0") {
            local ledState = (request.query.led == "0") ? false : true;

            // Send "set.led" message to device, and send ledState as the data
            device.send("set.led", ledState); 
        }
    }

    // Send a response back to the browser saying everything was OK.
    response.send(200, "OK");
    } catch (ex) {
        response.send(500, "Internal Server Error: " + ex);
    }
}

// Register the HTTP handler to begin watching for incoming HTTP requests
http.onrequest(requestHandler);

// A callback to check if the data is successfully sent to Ubidots
function ubidotsSendCallback(response) {
    if (response.statuscode != 200) { 
        server.log(format("ERROR: could not send data to Ubidots. Statuscode = %d", response.statuscode));
    }
    else {
        server.log("Successfully sent!");
    }
}

// Update data at the Ubidots service
function updateConditions(conditions) {
    try {
        server.log(format("Sending current conditions: Humidity: %0.2f %s, Temperature: %0.2f °C", conditions.humidity, "%", conditions.temperature));
    } catch (ex) {
        server.error(ex);
        return;
    }

    ubidots.sendToDevice(conditions, ubidotsSendCallback);
}

// Register a handler function for incoming "conditions.sent" messages from the device
device.on("conditions.sent", updateConditions);
