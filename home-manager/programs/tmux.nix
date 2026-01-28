{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    baseIndex = 1;
    clock24 = true;
    escapeTime = 0;
    historyLimit = 10000;
    keyMode = "vi";
    mouse = true;
    newSession = true;
    prefix = "C-a"; # Changed from C-b to C-a (more ergonomic)
    terminal = "screen-256color";
    
    extraConfig = ''
      # ============================================================================
      # AI AGENT OPTIMIZED TMUX CONFIGURATION
      # Best practices for running multiple AI agents (SSH or local)
      # ============================================================================
      
      # Enable true color support
      set -g default-terminal "screen-256color"
      set -ga terminal-overrides ",*256col*:Tc"
      
      # Increase scrollback buffer
      set -g history-limit 10000
      
      # Faster key repeat
      set -s escape-time 0
      
      # Window and pane numbering starts at 1
      set -g base-index 1
      setw -g pane-base-index 1
      
      # Renumber windows when one is closed
      set -g renumber-windows on
      
      # ============================================================================
      # KEY BINDINGS
      # ============================================================================
      
      # Unbind default prefix
      unbind C-b
      set -g prefix C-a
      bind C-a send-prefix
      
      # Reload config file
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"
      
      # Split panes using | and -
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %
      
      # Switch panes using Alt-arrow without prefix
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D
      
      # Resize panes using Ctrl-arrow
      bind -n C-Left resize-pane -L 5
      bind -n C-Right resize-pane -R 5
      bind -n C-Up resize-pane -U 5
      bind -n C-Down resize-pane -D 5
      
      # Switch windows using Shift-arrow
      bind -n S-Left previous-window
      bind -n S-Right next-window
      
      # Quick window selection
      bind -r C-h select-window -t :-
      bind -r C-l select-window -t :+
      
      # ============================================================================
      # SESSION MANAGEMENT (CRITICAL FOR MULTIPLE AGENTS)
      # ============================================================================
      
      # Create new session
      bind C-c new-session
      
      # List sessions (fuzzy finder style)
      bind C-f display-popup -E "tmux list-sessions | fzf --reverse | cut -d: -f1 | xargs tmux switch-client -t"
      
      # Detach session
      bind C-d detach
      
      # Kill session
      bind C-k confirm-before -p "kill-session #S? (y/n)" kill-session
      
      # ============================================================================
      # PANE MANAGEMENT
      # ============================================================================
      
      # Toggle between last active pane
      bind Space last-pane
      
      # Toggle pane zoom
      bind z resize-pane -Z
      
      # Break pane into new window
      bind b break-pane -d
      
      # Join pane from window
      bind j choose-window 'join-pane -h -s "%%"'
      
      # Swap panes
      bind { swap-pane -U
      bind } swap-pane -D
      
      # Kill pane
      bind x kill-pane
      
      # ============================================================================
      # COPY MODE (VI MODE)
      # ============================================================================
      
      # Enter copy mode
      bind Enter copy-mode
      
      # Vi mode key bindings in copy mode
      setw -g mode-keys vi
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      bind-key -T copy-mode-vi r send-keys -X rectangle-toggle
      
      # Paste
      bind p paste-buffer
      
      # ============================================================================
      # STATUS BAR (CUSTOMIZED FOR AGENT MONITORING)
      # ============================================================================
      
      # Status bar position
      set -g status-position bottom
      set -g status-justify left
      
      # Status bar colors
      set -g status-style "bg=#1e1e2e fg=#cdd6f4"
      set -g status-left-length 40
      set -g status-right-length 80
      
      # Status bar left (session info)
      set -g status-left "#[fg=#89b4fa,bold] #S #[fg=#cdd6f4]│ "
      
      # Status bar right (time, date, hostname)
      set -g status-right "#[fg=#cdd6f4]│ #[fg=#89b4fa]%H:%M #[fg=#cdd6f4]│ #[fg=#a6e3a1]#h "
      
      # Window status
      setw -g window-status-style "fg=#6c7086"
      setw -g window-status-current-style "fg=#89b4fa bold"
      setw -g window-status-format " #I: #W "
      setw -g window-status-current-format " #I: #W "
      setw -g window-status-separator ""
      
      # Activity and bell alerts
      setw -g window-status-activity-style "fg=#f9e2af bg=#1e1e2e"
      setw -g window-status-bell-style "fg=#fab387 bg=#1e1e2e"
      
      # Message style
      set -g message-style "fg=#cdd6f4 bg=#1e1e2e"
      
      # ============================================================================
      # AGENT-SPECIFIC CONFIGURATIONS
      # ============================================================================
      
      # Keep sessions alive (useful for SSH connections)
      set -g remain-on-exit off
      setw -g remain-on-exit off
      
      # Activity monitoring
      setw -g monitor-activity on
      set -g visual-activity on
      
      # Focus events (for terminal apps)
      set -g focus-events on
      
      # Aggressive resize (only resize if the smaller client sees the window)
      setw -g aggressive-resize on
      
      # ============================================================================
      # PERFORMANCE OPTIMIZATIONS
      # ============================================================================
      
      # Reduce latency
      set -sg escape-time 0
      set -sg repeat-time 600
      
      # ============================================================================
      # HELPER FUNCTIONS FOR AGENT MANAGEMENT
      # ============================================================================
      
      # Function to create a new agent session
      # Usage: tmux new-agent-session <name>
      # Creates a session with 4 panes in a 2x2 grid
      bind C-n new-session -d \; \
        split-window -h \; \
        split-window -v \; \
        select-pane -t 0 \; \
        split-window -v \; \
        select-pane -t 0
      
      # Quick pane layout presets
      bind M-1 select-layout even-horizontal
      bind M-2 select-layout even-vertical
      bind M-3 select-layout main-horizontal
      bind M-4 select-layout main-vertical
      bind M-5 select-layout tiled
      
      # ============================================================================
      # SSH-SPECIFIC OPTIMIZATIONS
      # ============================================================================
      
      # Automatically reattach to existing session if available
      # This is handled by newSession = true in the Nix config
      
      # ============================================================================
      # PLUGINS (OPTIONAL - UNCOMMENT IF NEEDED)
      # ============================================================================
      
      # Example: TPM plugin manager
      # set -g @plugin 'tmux-plugins/tpm'
      # set -g @plugin 'tmux-plugins/tmux-sensible'
      # set -g @plugin 'tmux-plugins/tmux-resurrect'  # Save/restore sessions
      # set -g @plugin 'tmux-plugins/tmux-continuum'  # Auto-save sessions
      # 
      # # Initialize TPM (keep this line at the very bottom of tmux.conf)
      # run '~/.tmux/plugins/tpm/tpm'
    '';
  };
}
