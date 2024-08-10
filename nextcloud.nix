{ pkgs, config, lib, modulesPath, ... }: 
{
	#security.acme = {
    #acceptTerms = true;
    #defaults = {
    #  email = "patrick@montycasa.com";
    #  dnsProvider = "cloudflare";
    #  # location of your CLOUDFLARE_DNS_API_TOKEN=[value]
    #  # https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html#EnvironmentFile=
    #  environmentFile = "/etc/nixos/.cloudflare";
    #};
 # };
	
  services = {
    #nginx.virtualHosts = {
    #  "nixcloud.skink-galaxy.ts.net" = {
    #    forceSSL = true;
    #    enableACME = true;
    #    # Use DNS Challenege.
    #    acmeRoot = null;
    #  };
    #};
    # 
		
		nextcloud = {
		    /*
				Had to run these commands in the proxmox node:
				pct mount 121
				chattr +i /var/lib/lxc/121/rootfs/var/empty
				pct unmount 121
				*/
				
      enable = true;
      hostName = "nixcloud.skink-galaxy.ts.net";
      # Need to manually increment with every major upgrade.
      package = pkgs.nextcloud28;
      # Let NixOS install and configure the database automatically.
      database.createLocally = true;
      # Let NixOS install and configure Redis caching automatically.
      configureRedis = true;
      # Increase the maximum file upload size.
      maxUploadSize = "16G";
      https = false;
      autoUpdateApps.enable = true;
      extraAppsEnable = true;
      extraApps = with config.services.nextcloud.package.packages.apps; {
        # List of apps we want to install and are already packaged in
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/servers/nextcloud/packages/nextcloud-apps.json
        inherit calendar contacts notes onlyoffice tasks cookbook qownnotesapi;
        # Custom app example.
#        socialsharing_telegram = pkgs.fetchNextcloudApp rec {
#          url =
#            "https://github.com/nextcloud-releases/socialsharing/releases/download/v3.0.1/socialsharing_telegram-v3.0.1.tar.gz";
#          license = "agpl3";
#          sha256 = "sha256-8XyOslMmzxmX2QsVzYzIJKNw6rVWJ7uDhU1jaKJ0Q8k=";
#        };
      };
#      settings = {
#        overwriteProtocol = "https";
#        default_phone_region = "US";
#      };
      config = {
        dbtype = "pgsql";
        adminuser = "admin";
        adminpassFile = "/etc/nixos/nextcloud.pass";
      };
      # Suggested by Nextcloud's health check.
      phpOptions."opcache.interned_strings_buffer" = "16";
    };
    
	  # Nightly database backups.
    postgresqlBackup = {
      enable = true;
      startAt = "*-*-* 01:15:00";
    };
	};


}