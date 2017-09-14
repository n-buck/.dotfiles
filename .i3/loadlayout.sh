#!/bin/bash

# First we append the saved layout of worspace N to workspace M
i3-msg "workspace 4: Chat; append_layout ~/.i3/workspace_chat"
i3-msg "workspace 3: LaTex; append_layout ~/.i3/workspace_latex"
i3-msg "workspace 2: Terminal; append_layout ~/.i3/workspace_terminal"
i3-msg "workspace 1: Browser; append_layout ~/.i3/workspace_browser"

# And finally we fill the containers with the programs they had
(chromium &)
(terminator &)
(terminator &)
(terminator &)
(terminator &)
(telegram &)
(thunderbird &)
#(uxterm &)