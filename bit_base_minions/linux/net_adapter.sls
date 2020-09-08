{% from "bit_base_minions/map.jinja" import config with context %}
{%- set settings = config.settings  %}
{%- set minion_host = config.minion_hosts.get(grains.id, false) %}
{%- set default_hostname = grains.id.replace('.', '-').split('-')[:-2] %}

{%- if minion_host.net_adapter is defined and minion_host.net_adapter|length %}
install_net_adapter_{{ grains.server_id }}:
 network.managed:
   - name: '{{ minion_host.net_adapter }}'
   - type: {{ settings.type | default('eth' ) }}
   - dns_proto: {{ settings.dns_proto | default('dhcp' ) }}
   {%- if settings.dns_servers is defined and settings.dns_servers|length %}
   - dns_servers: {{ settings.dns_servers }}
   {%- endif %}
   {%- if settings.gateway is defined and settings.gateway|length %}
   - gateway: {{ settings.gateway }}
   {%- endif %}
   - ip_proto: {{ minion_host.ip_proto | default('dhcp' ) }}
   - ip_addrs: {{ minion_host.ip_addrs | default('') }}

set_hostname_{{ grains.server_id }}:
  network.system:
    - enabled: True
    - hostname: {{ minion_host.hostname | default(default_hostname) }}
    {%- if settings.gateway is defined and settings.gateway|length %}
    - gateway: {{ settings.gateway }}
    {%- endif %}

restart_minion_{{ grains.server_id }}:
  cmd.run:
    - name: 'salt-call --local service.restart salt-minion'
    - watch:
      - cmd: install_net_adapter_{{ grains.server_id }}
      - cmd: install_dns_{{ grains.server_id }}
{%- endif %}
