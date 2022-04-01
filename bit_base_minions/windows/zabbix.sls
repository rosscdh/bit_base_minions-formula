{% from "bit_base_minions/map.jinja" import config with context %}
{%- set settings = config.settings  %}
{%- set minion_host = config.minion_hosts.get(grains.id, false) %}
{%- set psk_file = settings.zabbix.get("windows", {}).get("psk_file", "C:\ProgramData\zabbix\zabbix_agentd.psk") %}

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
    - name: '{{ psk_file }}'
    - makedirs: True
    - template: jinja
    - context:
      psk: {{ settings.zabbix.psk }}
      psk_file: {{ settings.zabbix.windows.psk_file }}
    - source:
      - salt://bit_base_minions/files/zabbix_agentd.psk.jinja2
{%- endif %}

windows-retsart-zabbix-agent:
  service.running:
    - name: 'Zabbix Agent'
    - enable: True
    - reload: True
    - watch:
      - file: {{ psk_file }}
      - windows_zabbix_agent_conf


{%- if config.zabbix._connection_url %}
update_zabbix:
  zabbix_host.present:
    - _connection_user: {{ settings.zabbix._connection_user }}
    - _connection_password: {{ settings.zabbix._connection_password }}
    - _connection_url: {{ settings.zabbix._connection_url }}
    - host: {{ minion_host.hostname }}.{{ settings.fqdn }}
    - groups:
      - {{ settings.zabbix.group_id }}
    - interfaces:
      - {{ minion_host.net_adapter }}:
        - ip: {{ minion_host.ip_addrs[0] }}
        - type: 'Agent'
        - port: 1050
{%- endif %}

