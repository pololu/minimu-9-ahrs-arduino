# MinIMU9ArduinoAHRS
# Pololu MinIMU-9 + Arduino AHRS (Attitude and Heading Reference System)

# Copyright (c) 2011 Pololu Corporation.
# http://www.pololu.com/

# MinIMU9ArduinoAHRS is based on sf9domahrs by Doug Weibel and Jose Julio:
# http://code.google.com/p/sf9domahrs/

# sf9domahrs is based on ArduIMU v1.5 by Jordi Munoz and William Premerlani, Jose
# Julio and Doug Weibel:
# http://code.google.com/p/ardu-imu/

# MinIMU9ArduinoAHRS is free software: you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as published by the
# Free Software Foundation, either version 3 of the License, or (at your option)
# any later version.

# MinIMU9ArduinoAHRS is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for
# more details.

# You should have received a copy of the GNU Lesser General Public License along
# with MinIMU9ArduinoAHRS. If not, see <http://www.gnu.org/licenses/>.

################################################################################

# This is a test/3D visualization program for the Pololu MinIMU-9 + Arduino
# AHRS, based on "Test for Razor 9DOF IMU" by Jose Julio, copyright 2009.

# This script needs VPython, pyserial and pywin modules

# First Install Python 3 (tested with Python 3.9 on linux but earlier versions on Windows should work)
# This can be used in a Python/Conda virtualenv
# Install pywin from http://sourceforge.net/projects/pywin32/
# Install pyserial from http://sourceforge.net/projects/pyserial/files/
# Install VPython from http://vpython.org/contents/download_windows.html

from vpython import *
import serial
import math
import os
import time

DEVICE = "/dev/ttyACM"  # could be "COM", "/dev/ttyUSB", ...


def launch():
    grad2rad = 3.141592 / 180.0
    # find the device
    ser = None
    maxi = 10
    it = 0
    while it < maxi:
        try:
            dev = DEVICE + str(it)
            if os.path.exists(dev):
                ser = serial.Serial(port=dev, baudrate=115200, timeout=1)
                print(dev + " exists !")
                break
            else:
                print("device %s does not exists" % dev)
        except serial.serialutil.SerialException:
            print("Serial device triggered an exception :-(")
        it += 1
    if not ser:
        return 1

    # Main scene
    scene = canvas(title="Platform")
    caption = "<b>Pololu MinIMU-9 + Arduino AHRS</b>"
    caption += """
Click to toggle between pausing or running.
Right button drag or Ctrl-drag to rotate "camera" to view scene.
To zoom, drag with mid1e button or Alt/Option depressed, or use scroll wheel.
On a two-button mouse, midd1e is left + right.
Touch screen: pinch/extend to zoom, swipe or two-finger rotate."""
    scene.caption = caption

    scene.forward = vector(0, -1, -0.25)

    # # Second scene (Roll, Pitch, Yaw)
    scene2 = canvas(title='Rotation axis')
    scene2.select()
    scene.width = 500
    scene.y = 200

    # Roll, Pitch, Yaw
    cil_roll = cylinder(pos=vector(-0.4, 0, 0), axis=vector(0.2, 0, 0), radius=0.01, color=color.red)
    cil_roll2 = cylinder(pos=vector(-0.4, 0, 0), axis=vector(-0.2, 0, 0), radius=0.01, color=color.red)
    cil_pitch = cylinder(pos=vector(0.1, 0, 0), axis=vector(0.2, 0, 0), radius=0.01, color=color.green)
    cil_pitch2 = cylinder(pos=vector(0.1, 0, 0), axis=vector(-0.2, 0, 0), radius=0.01, color=color.green)
    # cil_course = cylinder(pos=(0.6,0,0),axis=(0.2,0,0),radius=0.01,color=color.blue)
    # cil_course2 = cylinder(pos=(0.6,0,0),axis=(-0.2,0,0),radius=0.01,color=color.blue)
    arrow_course = arrow(pos=vector(0.6, 0, 0), color=color.cyan, axis=vector(-0.2, 0, 0), shaftwidth=0.02,
                         fixedwidth=1)

    # Roll,Pitch,Yaw labels
    label(pos=vector(-0.4, 0.3, 0), text="Roll", box=0, opacity=0, billboard=True)
    label(pos=vector(0.1, 0.3, 0), text="Pitch", box=0, opacity=1, billboard=True)
    label(pos=vector(0.55, 0.3, 0), text="Yaw", box=0, opacity=0, billboard=True)
    label(pos=vector(0.6, 0.22, 0), text="N", color=color.yellow, box=0, opacity=0)
    label(pos=vector(0.6, -0.22, 0), text="S", color=color.yellow, box=0, opacity=0)
    label(pos=vector(0.38, 0, 0), text="W", color=color.yellow, box=0, opacity=0)
    label(pos=vector(0.82, 0, 0), text="E", box=0, opacity=0, color=color.yellow)
    label(pos=vector(0.75, 0.15, 0), height=7, text="NE", box=0, color=color.yellow)
    label(pos=vector(0.45, 0.15, 0), height=7, text="NW", box=0, color=color.yellow)
    label(pos=vector(0.75, -0.15, 0), height=7, text="SE", box=0, color=color.yellow)
    label(pos=vector(0.45, -0.15, 0), height=7, text="SW", box=0, color=color.yellow)

    l_1 = label(pos=vector(-0.4, 0.22, 0), text="-", box=0, opacity=0)
    l_2 = label(pos=vector(0.1, 0.22, 0), text="-", box=0, opacity=0)
    l_3 = label(pos=vector(0.7, 0.3, 0), text="-", box=0, opacity=0)

    # Main scene objects
    scene.select()
    # Reference axis (x,y,z)
    arrow(color=color.green, axis=vector(1, 0, 0), shaftwidth=0.02, fixedwidth=1)
    arrow(color=color.green, axis=vector(0, -1, 0), shaftwidth=0.02, fixedwidth=1)
    arrow(color=color.green, axis=vector(0, 0, -1), shaftwidth=0.02, fixedwidth=1)
    # labels
    # label(pos=vector(0, 0, 0.8), text="Pololu MinIMU-9 + Arduino AHRS", box=0, opacity=0)
    label(pos=vector(1, 0, 0), text="X", box=0, opacity=0)
    label(pos=vector(0, -1, 0), text="Y", box=0, opacity=0)
    label(pos=vector(0, 0, -1), text="Z", box=0, opacity=0)
    # IMU object
    platform_mimi = box(length=1, height=0.05, width=1, color=color.blue)
    p_line = box(length=1, height=0.08, width=0.1, color=color.yellow)
    plat_arrow = arrow(color=color.green, axis=vector(1, 0, 0), shaftwidth=0.06, fixedwidth=1)
    roll = 0
    pitch = 0
    yaw = 0

    time.sleep(0.2)
    rate(25)
    while True:
        line = ser.readline()
        line = line.decode('utf-8')
        if line.find("=ANG:") != -1:  # filter out incomplete (invalid) lines
            line = line.replace("=ANG:", "")  # Delete "!ANG:"
            words = line.split(",")  # Fields split
            if len(words) > 2:
                try:
                    roll = float(words[0]) * grad2rad
                    pitch = float(words[1]) * grad2rad
                    yaw = float(words[2]) * grad2rad
                except (TypeError, IndexError) as ex:
                    print("Invalid line")

                axis = vector(math.cos(pitch) * math.cos(yaw), -math.cos(pitch) * math.sin(yaw), math.sin(pitch))
                up = vector(math.sin(roll) * math.sin(yaw) + math.cos(roll) * math.sin(pitch) * math.cos(yaw),
                            math.sin(roll) * math.cos(yaw) - math.cos(roll) * math.sin(pitch) * math.sin(yaw),
                            - math.cos(roll) * math.cos(pitch))
                platform_mimi.axis = axis
                platform_mimi.up = up
                platform_mimi.length = 1.0
                platform_mimi.width = 0.65
                plat_arrow.axis = axis
                plat_arrow.up = up
                plat_arrow.length = 0.8
                p_line.axis = axis
                p_line.up = up
                cil_roll.axis = vector(0.2 * math.cos(roll), 0.2 * math.sin(roll), 0)
                cil_roll2.axis = vector(-0.2 * math.cos(roll), -0.2 * math.sin(roll), 0)
                cil_pitch.axis = vector(0.2 * math.cos(pitch), 0.2 * math.sin(pitch), 0)
                cil_pitch2.axis = vector(-0.2 * math.cos(pitch), -0.2 * math.sin(pitch), 0)
                arrow_course.axis = vector(0.2 * math.sin(yaw), 0.2 * math.cos(yaw), 0)
                l_1.text = str(float(words[0]))
                l_2.text = str(float(words[1]))
                l_3.text = str(float(words[2]))
                sleep(0.05)

    ser.close()


if __name__ == '__main__':
    launch()
