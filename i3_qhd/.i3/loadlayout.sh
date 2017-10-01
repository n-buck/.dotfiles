#!/bin/bash

# First we append the saved layout of worspace N to workspace M
i3-msg "workspace 4: Chat; append_layout ~/.i3/workspace_chat"
i3-msg "workspace 3: Workspace; append_layout ~/.i3/workspace_latex"
i3-msg "workspace 2: Terminal; append_layout ~/.i3/workspace_2terminal"
i3-msg "workspace 1: Browser; append_layout ~/.i3/workspace_browser"

# And finally we fill the containers with the programs they had
(chromium &)
#(termite &)
(termite &)
(termite &)
(termite &)
(telegram &)
(thunderbird &)
#(uxterm &)
