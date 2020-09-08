
fw_saltstack:
  win_firewall.add_rule:
    - name: SaltStack (4505-4506)
    - localport: 4505-4506
    - protocol: tcp
    - dir: in
    - action: allow