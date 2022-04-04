{% from "bit_base_minions/map.jinja" import config with context %}
{%- set minion_host = config.minion_hosts.get(grains.id, None) %}
{%- set settings = config.settings  %}

{%- if '_connection_url' in settings.zabbix %}
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