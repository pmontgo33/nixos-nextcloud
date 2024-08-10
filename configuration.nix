{ pkgs, modulesPath, ... }: 

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    /etc/nixos/base_config.nix
    /etc/nixos/nextcloud.nix
  ];
	
  environment.systemPackages = with pkgs; [
		
  ];

  system.stateVersion = "24.05";
}
