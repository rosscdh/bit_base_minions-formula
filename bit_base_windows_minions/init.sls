{% from "bit_base_windows_minions/map.jinja" import config with context %}
{%- set settings = config.settings  %}
{%- set users = config.users  %}
{%- set remove_users = config.get('remove_users', []) %}
{%- set kernel = grains.kernel|lower %}
{%- set minion_host = config.minion_hosts.get(grains.id, false) %}

{%- if kernel ==  'windows' %}

include:
- .chocolatey
- .rdp
- .ntp
- .users
- .zabbix
- .applications
- .fw
- .net_adapter
- .winlogbeat

{%- endif %}

