{% from "bit_base_minions/map.jinja" import config with context %}
{%- set settings = config.settings  %}
{%- set minion_host = config.minion_hosts.get(grains.id, false) %}

fw_zabbix_passive:
  win_firewall.add_rule:
    - name: Zabbix Passive (10050)
    - localport: 10050
    - protocol: tcp
    - dir: in
    - action: allow

fw_zabbix_active:
  win_firewall.add_rule:
    - name: Zabbix Active (10051)
    - localport: 10051
    - protocol: tcp
    - dir: out
    - action: allow

#remove_old_windows_zabbix_agent_conf:
#  file.absent:
#    - name: 'C:\ProgramData\zabbix\zabbix_agentd.conf'

windows_zabbix_agent_conf:
  file.managed:
    - name: 'C:\ProgramData\zabbix\zabbix_agentd.conf'
    - makedirs: True
    - template: jinja
    - source:
      - salt://bit_base_minions/files/zabbix.config.jinja2

{%- if settings.zabbix.psk | length %}
windows_zabbix_agent_psk:
  file.managed:
    - name: '{{ settings.zabbix.get('windows', {}).get("psk_file", "C:\ProgramData\zabbix\zabbix_agentd.psk") }}'
    - makedirs: True
    - template: jinja
    - context:
      psk: {{ settings.zabbix.psk }}
    - source:
      - salt://bit_base_minions/files/zabbix_agentd.psk.jinja2
{%- endif %}

'Zabbix Agent':
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: C:\ProgramData\zabbix\zabbix_agentd.conf
      {%- if settings.zabbix.psk | length %}
      - file: {{ settings.zabbix.psk_file }}
      {%- endif %}