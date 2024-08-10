{ pkgs, config, lib, modulesPath, ... }: 

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    /etc/nixos/samba.nix
		/etc/nixos/nextcloud.nix
  ];
	
  environment.systemPackages = with pkgs; [
    vim
    tmux
    git
    fail2ban 		
  ];

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

  # Enable OpenSSH daemon
  services.openssh.enable = true;
#  services.openssh.settings.PermitRootLogin = "yes";
  
	### Tailscale ###
	services.tailscale.enable = true;
  /* 
	add these lines to /etc/pve/lxc/ID.conf
	lxc.cgroup2.devices.allow: c 10:200 rwm
  lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
	*/
	
	programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./tmux.conf;
  };
	

  system.stateVersion = "24.05";

}
