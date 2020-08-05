bit_base_windows_minions:
  settings:
    dns_proto: static
    dns_servers:
      - 10.0.22.12
      - 10.0.22.1
    gateway: 10.0.22.1
    ntp_servers:
      - ptbtime1.ptb.de
      - ptbtime2.ptb.de
      - ptbtime3.ptb.de
    apps:
      standard_apps: []
      chocolatey_apps:
      - name: zabbix-agent
        params: ""
        package_args: "-f -y"
      - name: Firefox
        params: "/l:de-DE"
        package_args: "-f -y"

  users:
    - username: BienertIT
      password: pass1234
      groups:
      - Administrators

  minion_hosts:
    "bit-lab-ws01-mg":
      rdp_enable: "true"
      net_adapter: "Realtek PCIe GBE Family Controller"
      ip_proto: static
      ip_addrs:
      - 10.0.22.201
