{% from "bit_base_minions/map.jinja" import config with context %}
{%- set settings = config.settings  %}
{%- set minion_host = config.minion_hosts.get(grains.id, false) %}
{%- set psk_file = settings.zabbix.get("linux", {}).get("psk_file", "/etc/zabbix/zabbix_agentd.psk") %}


{%- if settings.zabbix.psk | length %}
zabbix_psk:
  file.managed:
    - name: '{{ psk_file }}'
    - makedirs: True
    - template: jinja
    - context:
      psk: {{ settings.zabbix.psk }}
    - source:
      - salt://bit_base_minions/files/zabbix_agentd.psk.jinja2

linux-restart-zabbix-agent:
  service.running:
    - name: zabbix-agent
    - enable: True
    - reload: True
    - watch:
      - file: /etc/zabbix/zabbix_agentd.conf
      - file: {{ psk_file }}
{%- endif %}