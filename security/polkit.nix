{
  security.polkit = {
    enable = true;
    extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (subject.isInGroup("wheel") && (
          action.id == "org.freedesktop.login1.reboot" ||
          action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
          action.id == "org.freedesktop.login1.power-off" ||
          action.id == "org.freedesktop.login1.power-off-multiple-sessions"
        ))
        {
          return polkit.Result.YES;
        }
      });
    '';
  };
}
