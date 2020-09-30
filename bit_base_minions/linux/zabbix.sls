{% from "bit_base_minions/map.jinja" import config with context %}
{%- set settings = config.settings  %}
{%- set minion_host = config.minion_hosts.get(grains.id, false) %}

{%- if settings.zabbix.psk | length %}
zabbix_psk:
  file.managed:
    - name: '{{ settings.zabbix.get("linux", {}).get("psk_file", "/etc/zabbix/zabbix_agentd.psk") }}'
    - makedirs: True
    - template: jinja
    - context:
      psk: {{ settings.zabbix.psk }}
    - source:
      - salt://bit_base_minions/files/zabbix_agentd.psk.jinja2
{%- endif %}

liunux-zabbix-agent:
  service.running:
    - name: zabbix-agent
    - enable: True
    - reload: True
    - watch:
      {%- if settings.zabbix.psk | length %}
      - file: {{ settings.zabbix.psk_file }}
      {%- endif %}