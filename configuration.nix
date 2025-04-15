# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:


let
	tex= (pkgs.texlive.combine {
		inherit (pkgs.texlive) scheme-basic
		      dvisvgm dvipng # for preview and export as html
		      wrapfig amsmath ulem hyperref capt-of;
		      #(setq org-latex-compiler "lualatex")
		      #(setq org-preview-latex-default-process 'dvisvgm)
	});
	# unstable = import
	#     (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/<branch or commit>)
	#     # reuse the current configuration
	#     { config = config.nixpkgs.config; };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # ./nginx.myblog.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = false;
  services.xserver.desktopManager.gnome.enable = true;


  # Enable the SDDM Display Manager.
  services.xserver.displayManager.sddm.enable = true;

  services.xserver.windowManager.awesome = {
  enable = true;
  luaModules = with pkgs.luaPackages; [
  luarocks
  luadbi-mysql
  ];

  };

  # Enable the Hyprland Desktop Environment.
  # programs.hyprland = {
  # enable = true;
  # xwayland.enable = true;
  #};

#  xdg.portal.enable = true;
#  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];


  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  #sound.enable = true;
  #hardware.pulseaudio.enable = false;
  #security.rtkit.enable = true;
  #services.pipewire = {
  # enable = true;
  # alsa.enable = true;
  # alsa.support32Bit = true;
  # pulse.enable = true;
  # # If you want to use JACK applications, uncomment this
  # #jack.enable = true;

  # # use the example session manager (no others are packaged yet so this is enabled by default,
  # # no need to redefine it in your config for now)
  # #media-session.enable = true;
  #};

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.stevesp = {
    isNormalUser = true;
    description = "Steve Sujo Pulikottil";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  users.defaultUserShell=pkgs.zsh;

  # Install firefox.
  programs.firefox.enable = true;

  # Install direnv
  programs.direnv.enable = true;

  # enable appimage support
  # programs.appimage.binfmt = true;

  boot.binfmt.registrations.appimage = {
  wrapInterpreterInShell = false;
  interpreter = "${pkgs.appimage-run}/bin/appimage-run";
  recognitionType = "magic";
  offset = 0;
  mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
  magicOrExtension = ''\x7fELF....AI\x02'';
};

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Allow exp feat
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  awesome my rice
  rofi
  komorebi
  pulseaudio
  teams-for-linux
  ## lib
  gst_all_1.gst-libav
  # prod
  taskwarrior
  taskwarrior-tui
  libresprite 
  godot_4
  raylib
  inotify-tools
  libtool
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  vlc
  # apacheHttpd
  ardour
  html-xml-utils
  wget
  php
  phpPackages.composer
  ffmpeg
  gnomeExtensions.gnordvpn-local
  nodejs
  neovide
  gh
  recode
  anki-bin
  ninja
  emacs
  git
  rustup
  python3
  neovim
  zsh
  ripgrep
  findutils
  ledger
  sqlite
  pgadmin4
  fd
  vim
  arandr
  clang
  fira-code-nerdfont
  hplip
  go
  mage
  tex
  docker
  libgcc
  # cpp
  clang-tools
  cmake
  codespell
  conan
  cppcheck
  doxygen
  gtest
  lcov
  #c
  gnumake
  # web
  playwright-driver
  insomnia
  chromium
  #vcpkg
  #vcpkg-tool
  # wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };


# Docker setup
# virtualisation.docker.enable = true;
# virtualisation.docker.rootless = {
#   enable = true;
#   setSocketVariable = true;
# };

# postgresql setup

 services.postgresql = {
 enable = true;
 ensureDatabases = ["led" "drupal"];
 authentication = pkgs.lib.mkOverride 10 ''
#type database DBuser address auth-method  
 local 	all	all 		trust     
 host 	all	all   127.0.0.1/32 trust     
 '';
};

programs={
zsh = {
enable = true;
autosuggestions.enable = true;
zsh-autoenv.enable = true;
syntaxHighlighting.enable = true;
shellAliases = {
  "nixconf" = "sudo nvim /etc/nixos/configuration.nix";
  update = "sudo nixos-rebuild switch";
  };
shellInit = ''

alias in='task add +in'

tickle () {
	deadline=$1
	shift
	in +tickle wait:$deadline $@
}

alias tick=tickle
alias think='tickle +1d '

alias rnd='task add +rnd +next +@computer +@online'

webpage_title (){
wget -qO- "$*" | hxclean | hxselect -s '\n' -c 'title' | recode html..
}

read_and_review (){
    link="$1"
    title=$(webpage_title $link)
    echo $title
    descr="\"Read and review: $title\""
    id=$(task add +next +rnr "$descr" | sed -n 's/Created task \(.*\)./\1/p')
    task "$id" annotate "$link"
}

alias rnr=read_and_review
 
'';

ohMyZsh ={
enable = true;
# custom = "$HOME/.oh-my-zsh/custom";
# theme = "steve";
plugins = [
"git"
"taskwarrior"
"npm"
"history"
"node"
"rust"
"z"
];
};
};
starship = {
    enable = true;
    # Configuration written to ~/.config/starship.toml
    settings = {
      add_newline = false;

      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };

        command_timeout = 1300;
        continuation_prompt = "[∙](bright-black) ";
        
	right_format = "";
	scan_timeout = 30;
      custom.gtd_in = {
      command = "task +in +PENDING count";
      when = "";
      symbol = " ";
      };

      # package.disabled = true;
  };
};
};

# services.nginx = {

# enable = true;
# recommendedProxySettings = true;
# recommendedTlsSettings = true;

# virtualHosts."Flow.home" = {
# #addSSL = true;
# locations."/" = {
# proxyPass = "http://127.0.0.1:5173";
# };
# };
# };
# services.nginx.enable = true;
# services.nginx = {
#   enable = true;
#   virtualHosts."drupal-host.home" = {
#     # enableACME = true;
#     # forceSSL = true;
#     root = "/var/www/drupal-host.home/drupal11_host/web";
#     locations."~ \\.php$".extraConfig = ''
#       fastcgi_pass  unix:${config.services.phpfpm.pools.mypool.socket};
#       fastcgi_index index.php;
#     '';
#   };
# };
# apacheserver
# services.httpd = {
#   enable = true;
#   adminAddr = "webmaster@drupal-host.home";
#   enablePHP = {name = "php83" };
#  virtualHosts."drupal-host.home" = {
#     documentRoot = "/var/www/drupal-host.home";
#  };
#   };

# services.phpfpm.pools.mypool = {
#   user = "nobody";
#   settings = {
#     "pm" = "dynamic";
#     "listen.owner" = config.services.nginx.user;
#     "pm.max_children" = 5;
#     "pm.start_servers" = 2;
#     "pm.min_spare_servers" = 1;
#     "pm.max_spare_servers" = 3;
#     "pm.max_requests" = 500;
#   };
# };


# systemd.tmpfiles.rules = [
#     "d /var/www/drupal-host.home"
#     "f /var/www/drupal-host.home/index.php - - - - <?php phpinfo();"
#   ];
#security.acme = {
#acceptTerms = true;
#defaults.email = "stevesp2013@gmail.com";
#};

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
   networking.firewall = {
   enable = true;
   allowedTCPPorts = [ 5173 80 443];
   };
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
