{
  security.pam = {
    services = {
      SDDM = {
        enableGnomeKeyring = true;
        startSession = true;
      };
    };
    sshAgentAuth.enable = true;
    oath.enable = true;
    mount = {
      enable = true;
      logoutWait = 100;
      logoutTerm = true;
    };
  };
}
