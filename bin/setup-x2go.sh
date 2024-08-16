#=========================================================================
# setup-x2go.sh
#=========================================================================
# Output iTerm2 trigger to enable locally running the x2goclient. Then
# use x2golistsessions to find out the right X11 DISPLAY variable so that
# from now on any X11 applications in this terminal will show up in the
# x2go display.
#
# Author : Christopher Batten
# Date   : March 26, 2020

#-------------------------------------------------------------------------
# Initial checks
#-------------------------------------------------------------------------

# Do nothing if this is not an interactive shell

if [[ ! $- =~ "i" ]]; then
  return
fi

# Check if setup-ece5745.sh has been sourced

if [[ "x${SETUP_ECE5745}" != "xyes" ]]; then
  echo ""
  echo " The setup-ece5745.sh script has not been sourced yet. Please source"
  echo " setup-ece5745.sh and then resource this setup script."
  echo ""
  return
fi

#-------------------------------------------------------------------------
# Command line processing
#-------------------------------------------------------------------------

if [[ "x$1" == "x-q" ]] || [[ "x$2" == "x-q" ]]; then
  quiet="yes"
else
  quiet="no"
fi

#-------------------------------------------------------------------------
# Start
#-------------------------------------------------------------------------

print ""
print " Running x2go setup script"

#-------------------------------------------------------------------------
# Trigger
#-------------------------------------------------------------------------

print "  - Output trigger for iTerm2"

# Determine the server name

user=$(whoami)
server=$(hostname)

# Simply print out the full ssh url, but prefix it with a special phrase.
# We can use iTerm2 triggers to search for this phrase and start the
# corresponding x2go session using the x2goclient on Mac OS X.

print ""
echo "remote-x2go-trigger: ${server}"
print ""

#-------------------------------------------------------------------------
# Wait for x2goclient to connect
#-------------------------------------------------------------------------

done="false"
while [[ "${done}" == "false" ]]; do
  print "  - Waiting for x2goclient to connect"
  sleep 1
  if x2golistsessions | grep -q "|${user}|"; then
    done="true"
  fi
done

#-------------------------------------------------------------------------
# Setup environment variables
#-------------------------------------------------------------------------
# Set the DISPLAY environment variable so any new X11 apps will open in
# the x2go desktop.

print "  - Setup environment variables"

port=$(x2golistsessions | grep "|cb535|" | cut --delimiter="|" --field 3)

print "  - DISPLAY=:${port}.0"

export DISPLAY=":${port}.0"

print ""

