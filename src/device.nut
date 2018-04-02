#require "WS2812.class.nut:3.0.0"
#require "HTS221.device.lib.nut:2.0.1"

// The interval between sending current readings (sec)
const SEND_INTERVAL = 3;

// Set up the I2C bus the HTS221 connects to
i2c <- hardware.i2c89;
i2c.configure(CLOCK_SPEED_400_KHZ);

// Set up the HTS221
tempHumid <- HTS221(i2c);
tempHumid.setMode(HTS221_MODE.ONE_SHOT);

// Set up the SPI bus the RGB LED connects to
spi <- hardware.spi257;
spi.configure(MSB_FIRST, 7500);
// Activate power gating system to make RGB LED powered
hardware.pin1.configure(DIGITAL_OUT, 1);

// Set up the RGB LED
led <- WS2812(spi, 1);

function setLedState(state) {
	local color = state ? [255,0,0] : [0,0,0];
	server.log(format("Setting LED to %s", state ? "ON" : "OFF"));
	led.set(0, color).draw();
}

// Register a handler function for incoming "set.led" messages from the agent
agent.on("set.led", setLedState);

function sendConditions() {
	local curConditions = tempHumid.read();
	agent.send("conditions.sent", curConditions);
	imp.wakeup(SEND_INTERVAL, sendConditions); 
}

sendConditions();
