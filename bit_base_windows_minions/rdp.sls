{% from "bit_base_windows_minions/map.jinja" import config with context %}
{%- set minion_host = config.minion_hosts.get(grains.id, false) %}

setup-rdp:
  module.run:
    {%- if minion_host.rdp_enable is defined and minion_host.rdp_enable == 'true' %}
    - name: rdp.enable
    {%- else %}
    - name: rdp.disable
    {%- endif  %}