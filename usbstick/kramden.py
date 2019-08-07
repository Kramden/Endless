#!/usr/bin/env python3 

import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk
import subprocess

class StackWindow(Gtk.Window):

    def __init__(self):
        Gtk.Window.__init__(self, title="Kramden Utilities")
        self.set_border_width(10)

        vbox = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=6)
        self.add(vbox)

        stack = Gtk.Stack()
        stack.set_transition_type(Gtk.StackTransitionType.SLIDE_LEFT_RIGHT)
        stack.set_transition_duration(1000)
        
        # OS Load box
        osload_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=6)
        osload = Gtk.Button(label="Perform OS Load")
        osload.connect("clicked", self.on_osload_clicked)
        osload_box.pack_start(osload, True, True, 0)
        self.osload = Gtk.Label()
        osload_box.pack_start(self.osload, False, False, 0)
        stack.add_titled(osload_box, "osload_box", "OS Load")

        # Battery Test box
        battery_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=6)
        battery_refresh = Gtk.Button(label="Refresh")
        battery_refresh.connect("clicked", self.on_battery_refresh_clicked)
        battery_box.pack_end(battery_refresh, False, False, 0)
        self.battery_stats = Gtk.Label()
        self.on_battery_refresh_clicked(None)
        battery_box.pack_start(self.battery_stats, True, True, 0)
        stack.add_titled(battery_box, "battery_box", "Battery Test")

        # Final Test box
        finaltest_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=6)
        self.finaltest = Gtk.Button(label="Perform Final Test")
        self.finaltest.connect("clicked", self.on_finaltest_clicked)
        finaltest_box.pack_end(self.finaltest, False, False, 0)
        self.finaltest_result = Gtk.Label()
        self.finaltest_result.set_markup("Click buttom below to run final test")
        finaltest_box.pack_start(self.finaltest_result, True, True, 0)
        stack.add_titled(finaltest_box, "finaltest_box", "Final Test")

        stack_switcher = Gtk.StackSwitcher()
        stack_switcher.set_stack(stack)
        vbox.pack_start(stack_switcher, True, True, 0)
        vbox.pack_start(stack, True, True, 0)

    def on_osload_clicked(self, widget):
        print("OS Load Clicked")
        ret_str = ""
        try:
            ret = subprocess.check_output("./osload.sh")
            if len(ret) > 0:
                ret_str = "OS Load complete"
        except subprocess.CalledProcessError as err:
            print("Failed with %s", err)
        self.osload.set_markup(ret_str)

    def on_battery_refresh_clicked(self, widget):
        ret = subprocess.check_output("./battery_stats.sh")
        self.battery_stats.set_markup(ret.decode("utf-8"))
        print("Battery Refresh Clicked")

    def on_finaltest_clicked(self, widget):
        print("Final Test Clicked")
        output = "Final Test Success"
        ret = subprocess.check_output("./finaltest.sh")
        if len(ret) > 0:
            output = ret.decode("utf-8")
        self.finaltest_result.set_markup(output)

win = StackWindow()
win.connect("destroy", Gtk.main_quit)
win.show_all()
Gtk.main()
