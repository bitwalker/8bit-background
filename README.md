# How to use

This is currently built for OSX, but with minimal modification could be
used on any \*NIX system.

The `tod.sh` script is what changes your desktop background based on the
time of day. However in order for this to be automatic, you must set it
up to run via cron. The following crontab entry works on OSX 10.8.5, and
should work with no modification for any system.

First, execute `EDITOR=nano crontab -e` from the command line. Add a line to the
bottom that matches the following, but replace the path with the path to
the `tod.sh` script on your own machine. Vim does not work to edit
crontab on OSX for some reason, hence the `EDITOR=nano`.

```
0 * * * * /Users/Paul/Repositories/8bit-background/tod.sh
```

This will schedule the script to run once an hour.

# Multiple monitors

By default, `tod.sh` sets the background for your primary monitor. If
you want it to set the background of a particular monitor, pass the `-m`
flag with the integer value representing the monitor you want to set.
This is based on the order in which your desktops are configured in OSX.
Passing 1 will set your primary monitor, 2 your secondary monitor, and
so forth.

# Credits

These images come from Pokemon Sapphire (or that's what I've been led to
believe by Reddit). If you are the original author and would like
credit, please send me a message so I can properly credit you for your
work.
