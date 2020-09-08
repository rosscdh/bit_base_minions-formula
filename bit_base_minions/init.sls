{% from "bit_base_minions/map.jinja" import config with context %}
{%- set settings = config.settings  %}
{%- set users = config.users  %}
{%- set remove_users = config.get('remove_users', []) %}
{%- set kernel = grains.kernel|lower %}
{%- set minion_host = config.minion_hosts.get(grains.id, None) %}

{%- if kernel ==  'windows' %}
include:
- .windows.chocolatey
- .windows.rdp
- .windows.ntp
- .windows.users
- .windows.zabbix
- .windows.applications
- .windows.fw
- .windows.net_adapter
- .windows.winlogbeat
- .windows.packetbeat
- .windows.update_inventory
{%- endif %}

{%- if kernel ==  'linux' %}
include:
- .linux.net_adapter
{%- endif %}

