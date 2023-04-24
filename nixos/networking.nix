{
  config,
  pkgs,
  ...
}: {
  programs.clash-verge = {
    enable = true;
    tunMode = true;
    autoStart = true;
  };

  programs.clash-for-windows = {
    # enable = true;
    tunMode = true;
    autoStart = true;
  };

  services = {
    # v2raya.enable = true;
    resolved.enable = true;
    openssh.enable = true;
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
      nssmdns = true;
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
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # defaultGateway = "192.168.2.1";
    #interfaces.eno1.useDHCP = true;
    #interfaces.wlp1s0.useDHCP = true;

    # proxy.default = "http://127.0.0.1:7890";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # nameservers = [
    #   "223.5.5.5"
    #   "223.6.6.6"
    #   "119.29.29.29"
    # ];

    firewall = {
      # enable = false; # true by default
      # allowedUDPPorts = [ 53317 ];
      # allowedTCPPorts = [ 53317 ];
    };

    hosts = {
      "20.205.243.166" = ["github.com"];
    };
  };

  # systemd.services.nix-daemon.environment = {
  #   http_proxy = "http://127.0.0.1:7890";
  #   https_proxy = "http://127.0.0.1:7890";
  # };
}
