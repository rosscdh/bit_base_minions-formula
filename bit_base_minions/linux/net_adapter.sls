{% from "bit_base_minions/map.jinja" import config with context %}
{%- set settings = config.settings  %}
{%- set minion_host = config.minion_hosts.get(grains.id, false) %}
{%- set default_hostname = grains.id.replace('.', '-').split('-')[:-2] %}

{%- if minion_host.net_adapter is defined and minion_host.net_adapter|length %}
{%- for ip_addr in minion_host.ip_addrs %}
{{ minion_host.name | default('eth0') }}:
  network.managed:
    - enabled: {{ minion_host.enabled | default(True) }}
    - type: {{ minion_host.type | default('eth') }}
    - proto: {{ settings.dns_proto | default('static' ) }}
    - ipaddr: {{ ip_addr }}
    - netmask: {{ settings.netmask | default('255.255.255.0' ) }} 
    {%- if settings.gateway is defined and settings.gateway|length %}
    - gateway: {{ settings.gateway }}
    {%- endif %}
    - enable_ipv6: false
    #- ipv6proto: static
    #- ipv6ipaddrs:
    #  - 2001:db8:dead:beef::3/64
    #- ipv6gateway: 2001:db8:dead:beef::1
    #- ipv6netmask: 64
    - dns: {{ settings.dns_servers }}
{%- endfor %}


set_hostname_{{ grains.server_id }}:
  network.system:
    - enabled: True
    - hostname: {{ minion_host.hostname | default(default_hostname) }}
    {%- if settings.gateway is defined and settings.gateway|length %}
    - gateway: {{ settings.gateway }}
    {%- endif %}

{%- endif %}
