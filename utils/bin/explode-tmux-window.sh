#!/usr/bin/env bash

new_session_name="$(tmux display-message -p '#S')-out"
cur_win=$(tmux display-message -p  "#S:#{window_name}")

if ! tmux has-session -t "${new_session_name}" 2> /dev/null; then
	tmux new -d -s "${new_session_name}"
	tmux move-window -t "${new_session_name}" -s "${cur_win}"

	alacritty \
		--option 'window.dimensions.lines=55' \
		--option 'window.dimensions.columns=95' \
		-e zsh -c "tmux attach -t '${new_session_name}'" &

	# is this needed?
	disown
else
	tmux move-window -t "${new_session_name}"
fi

