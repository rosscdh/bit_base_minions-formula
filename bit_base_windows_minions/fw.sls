{% from "bit_base_windows_minions/map.jinja" import config with context %}
{%- set settings = config.settings  %}
{%- set minion_host = config.minion_hosts.get(grains.id, false) %}

fw_zabbix_passive:
  win_firewall.add_rule:
    - name: Zabbix Passive (10050)
    - localport: 10050
    - protocol: tcp
    - action: allow

fw_zabbix_active:
  win_firewall.add_rule:
    - name: Zabbix Active (10051)
    - localport: 10051
    - protocol: tcp
    - action: allow

fw_rdp:
  win_firewall.add_rule:
    - name: RDP (3389)
    - localport: 3389
    - protocol: tcp
    - action: allow