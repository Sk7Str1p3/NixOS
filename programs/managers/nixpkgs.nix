{
  nixpkgs = {
    config = {
      enableParallelBuildingByDefault = true;
      allowAliases = true;
      allowBroken = false;
      allowUnfree = true;
      checkMeta = true;
      cudaSupport = true;
      doCheckByDefault = true;
    };
    system = builtins.currentSystem;
  };
}
