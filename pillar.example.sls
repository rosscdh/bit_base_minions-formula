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

  users:
    - username: BienertIT
      password: pass1234
      groups:
      - Administrators

  minion_hosts:
    "bit.lab.ws01.mg":
      rdp_enable: "true"
      net_adapter: "Realtek PCIe GBE Family Controller"
      ip_proto: static
      ip_addrs:
      - 10.0.22.201
    "bit.lab.ws02.mg":
      rdp_enable: "true"
      net_adapter: "Realtek PCIe GBE Family Controller"
      ip_proto: static
      ip_addrs:
      - 10.0.22.202