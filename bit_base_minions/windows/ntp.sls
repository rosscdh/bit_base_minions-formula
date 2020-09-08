{% from "bit_base_minions/map.jinja" import config with context %}
{%- set settings = config.settings  %}

setup-ntp:
  ntp.managed:
    - servers: {{ settings.ntp_servers | default([]) }}
