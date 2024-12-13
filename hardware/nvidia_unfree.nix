{
  hardware.nvidia = {
    powerManagement = {
      enable = true;
      finegrained = true;
    };
    open = true;
    nvidiaSettings = true;
    nvidiaPersistenced = true;
    modesetting.enable = true;
    forceFullCompositionPipeline = true;
    dynamicBoost.enable = true;
  };
}
