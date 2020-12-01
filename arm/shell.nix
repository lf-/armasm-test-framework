let pkgsNative = import <nixpkgs> { };
  pkgs = import <nixpkgs> {
    crossSystem = {
      config = "arm-unknown-linux-gnueabi";
    };
    config = {
      allowUnsupportedSystem = true;
    };
  };
  qemu-user = pkgsNative.qemu.override {
        smartcardSupport = false;
        spiceSupport = false;
        openGLSupport = false;
        virglSupport = false;
        vncSupport = false;
        gtkSupport = false;
        sdlSupport = false;
        pulseSupport = false;
        smbdSupport = false;
        seccompSupport = false;
        hostCpuTargets = ["arm-linux-user"];
  };
in pkgs.mkShell {
      nativeBuildInputs = [ qemu-user pkgs.buildPackages.gdb pkgsNative.gdbgui ];
}
