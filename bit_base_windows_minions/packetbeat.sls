{% from "bit_base_windows_minions/map.jinja" import config with context %}
{%- set settings = config.settings  %}
{%- set minion_host = config.minion_hosts.get(grains.id, false) %}


windows_packetbeat_conf:
  file.managed:
    - name: 'C:\\ProgramData\chocolatey\lib\packetbeat\tools\packetbeat.yml'
    - makedirs: True
    - template: jinja
    - source:
      - salt://bit_base_windows_minions/files/packetbeat.yml.jinja2
        

packetbeat:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: 'C:\\ProgramData\chocolatey\lib\packetbeat\tools\packetbeat.yml'