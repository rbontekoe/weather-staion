// toit pkg install github.com/toitware/bme280-driver
// toit pkg install github.com/toitware/toit-ssd1306
// toit pkg install github.com/toitware/toit-pixel-display

import gpio
import bme280

import i2c
import ssd1306 show *

import font show *
import pixel_display.texture show *
import pixel_display.two_color show *  // Provides WHITE and BLACK.
import pixel_display show *

get_display -> TwoColorPixelDisplay bus:
  
  devices := bus.scan
  
  if not devices.contains SSD1306_ID: throw "No SSD1306 display found"
  
  driver := SSD1306 (bus.device 0x3c)
  
  return TwoColorPixelDisplay driver

bus := i2c.Bus
  --sda=gpio.Pin.out 21
  --scl=gpio.Pin.out 22
  --frequency=800_000

sans ::= Font.get "sans10"
display := get_display bus

main:
  
  bme := bme280.Driver (bus.device 0x76)
  
  //device2 := bus.device 0x3C
  //display := SSD1306 (bus.device 0x3c)

  
  //a := bus.scan
  //print a
  
  
  time := Time.now.local
  temp := bme.read_temperature
  press := (bme.read_pressure/100)
  hum := bme.read_humidity
    
  print "================="
  //print "Time:\t$(%02d time.h):$(%02d time.m)"
  //print "Date:\t$(%04d time.year)-$(%02d time.month)-$(%02d time.day)"
  print "Temp:\t$(%0.1f temp)"
  print "Press:\t$(%0.1f press)"
  print "Humid:\t$(%0.1f hum)"
    
  display.background = WHITE
  display.background = BLACK
  display.draw
  sleep --ms=2000
  context := display.context --landscape --color=WHITE --font=sans
    
  display.text context 0 15 "Time:  $(%02d time.h):$(%02d time.m)"
  display.text context 0 30 "Temp: $(%0.1f temp)"
  display.text context 0 45 "Pres:  $(%0.1f press)"
  display.text context 0 60 "Hum:   $(%0.1f hum)"
  display.draw