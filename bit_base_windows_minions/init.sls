{% from "bit_base_windows_minions/map.jinja" import config with context %}
{%- set settings = config.settings  %}
{%- set users = config.users  %}
{%- set remove_users = config.get('remove_users', []) %}
{%- set kernel = grains.kernel|lower %}
{%- set minion_host = config.minion_hosts.get(grains.id, false) %}

{%- if kernel ==  'windows' %}

{%- for user in users %}
'{{ user.username }}':
  user.present:
    - password: {{ user.password }}
    {%- if user.fullname is defined and user.fullname|length %}
    - fullname: {{ user.fullname }}
    {%- endif %}
    {%- if user.groups is defined and user.groups|length %}
    - groups: {{ user.groups }}
    {%- endif %}
{%- endfor %}

{%- for user in remove_users %}
'{{ user.username }}':
  user.absent
{%- endfor %}

fw_zabbix:
  win_firewall.add_rule:
    - name: Zabbix (10050)
    - localport: 10050
    - protocol: tcp
    - action: allow

fw_rdp:
  win_firewall.add_rule:
    - name: RDP (3389)
    - localport: 3389
    - protocol: tcp
    - action: allow

setup-rdp:
  module.run:
    {%- if minion_host.rdp_enable is defined %}
    - name: rdp.enable
    {%- else %}
    - name: rdp.disable
    {%- endif  %}

setup-ntp:
  ntp.managed:
    - servers: {{ settings.ntp_servers | default([]) }}

{%- if minion_host.net_adapter is defined and minion_host.net_adapter|length %}
'{{ minion_host.net_adapter }}':
  network.managed:
    - enable_ipv6: false
    - dns_proto: {{ settings.dns_proto | default('dhcp' ) }}
    {%- if settings.dns_servers is defined and settings.dns_servers|length %}
    - dns_servers: {{ settings.dns_servers }}
    {%- endif %}
    {%- if settings.dns_servers is defined and settings.dns_servers|length %}
    - gateway: {{ settings.gateway }}
    {%- endif %}
    - ip_proto: {{ minion_host.ip_proto | default('dhcp' ) }}
    - ip_addrs: {{ minion_host.ip_addrs | default('') }}

restart_minion:
  cmd.run:
    - name: 'salt-call --local service.restart salt-minion'
    - watch:
      - cmd: '{{ minion_host.net_adapter }}'
{%- endif %}

{%- endif %}

# include:
# - applications