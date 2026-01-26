Notes on opencode notifications

- oh-my-opencode provides a "session-notification" hook that emits desktop
  notifications when an agent is ready. By default it may run if no external
  notifier plugin is detected.

- Two strategies to avoid notification spam:
  1) Configure oh-my-opencode to not force-enable session-notification (we set
     force_enable=false in .oh-my-opencode.local.json). This allows external
     notifier plugins to disable oh-my-opencode's notifier if present.
  2) If you control the notifier code, ensure notify-send calls use a synchronous
     tag (e.g. -h string:x-canonical-private-synchronous:opencode) so notifications
     replace rather than accumulate in swaync.
