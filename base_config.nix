{ pkgs, modulesPath, ... }: 
{
  imports = [
    /etc/nixos/samba.nix
  ];
	
  ### INSTALL PACKAGES ###
  environment.systemPackages = with pkgs; [
    vim
    tmux
    git
    fail2ban
		nix-ld
  ];

  ### SET TIMEZONE ###
  time.timeZone = "America/New_York";

  ### ADD AND SETUP USERS ###
  users.users.patrick = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };
	
  security.sudo.extraRules= [
    { users = [ "patrick" ];
      commands = [
        { command = "ALL" ;
	  options= [ "NOPASSWD" ]; # "SETENV" # Adding the following could be a good idea
	}
      ];
    }
  ];

  ### OPENSSH ###
  services.openssh.enable = true;
#  services.openssh.settings.PermitRootLogin = "yes";
  
  ### TAILSCALE ###
  services.tailscale.enable = true;
  /* 
  add these lines to /etc/pve/lxc/ID.conf
  lxc.cgroup2.devices.allow: c 10:200 rwm
  lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
  */
	
  ### SETUP PACKAGES ###
  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./tmux.conf;
  };
	
  programs.git = {
    enable = true;
#    userName  = "Monty";
#    userEmail = "21371673+pmontgo33@users.noreply.github.com";
  };
	
  ### ENABLE REMOTE VSCODE TO CONNECT ###
	programs.nix-ld.enable = true;


}
