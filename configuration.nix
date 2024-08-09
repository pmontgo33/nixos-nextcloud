{ pkgs, modulesPath, ... }: 

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
#    ./samba.nix
    /etc/nixos/base_config.nix
  ];
	
  environment.systemPackages = with pkgs; [
#    vim
#    tmux
#    git
#    fail2ban 		
  ];

  system.stateVersion = "23.05";
}
