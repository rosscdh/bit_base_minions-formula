{% from "bit_base_windows_minions/map.jinja" import config with context %}
{%- set minion_host = config.minion_hosts.get(grains.id, false) %}

fw_rdp:
  win_firewall.add_rule:
    - name: RDP (3389)
    - localport: 3389
    - protocol: tcp
    - action: allow

setup-rdp:
  module.run:
    {%- if minion_host.rdp_enable is defined and minion_host.rdp_enable == 'true' %}
    - name: rdp.enable
    {%- else %}
    - name: rdp.disable
    {%- endif  %}