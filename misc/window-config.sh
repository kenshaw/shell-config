#!/bin/bash

# configure window buttons (for chrome)
gconftool-2 --set /apps/metacity/general/button_layout --type string ":minimize,maximize,close"
