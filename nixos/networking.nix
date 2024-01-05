{
  lib,
  config,
  ...
}: {
  programs.clash-verge = {
    enable = true;
    tunMode = true;
    autoStart = true;
  };

  services = {
    openssh = {
      enable = true;
      # Forbid root login through SSH.
      settings.PermitRootLogin = lib.mkDefault "no";
    };
    # v2raya.enable = true;

    # resolved.enable = true;
    # resolved.fallbackDns = config.networking.nameservers;

    # opensnitch.enable = true;

    # Proxy
    # tor.tsocks = {
    #   enable = true;
    #   server = "127.0.0.1:7890";
    # };

    # Enable CUPS to print documents.
    # printing.enable = true;

    # Publish this server and its address on the network
    avahi = {
      enable = true;
      nssmdns4 = true;
      # publish = {
      #   enable = true;
      #   domain = true;
      #   addresses = true;
      #   workstation = true;
      # };
    };
  };

  networking = {
    networkmanager.enable = true; # conflict with networking.wireless
    networkmanager.dns = "none";
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # defaultGateway = "192.168.2.1";
    #interfaces.eno1.useDHCP = true;
    #interfaces.wlp1s0.useDHCP = true;

    # proxy.default = "http://127.0.0.1:7890";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    nameservers = [
      "8.8.8.8"
      "1.1.1.1"
    ];

    firewall = {
      # enable = false; # true by default
      # allowedUDPPorts = [ 53317 ];
      # allowedTCPPorts = [ 53317 ];
    };

    # ping github.com
    # hosts = {
    #   "20.205.243.166" = ["github.com"];
    # };
  };

  # systemd.services.nix-daemon.environment = {
  #   http_proxy = "http://127.0.0.1:7890";
  #   https_proxy = "http://127.0.0.1:7890";
  # };
}
