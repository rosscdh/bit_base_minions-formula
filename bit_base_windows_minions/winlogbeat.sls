{% from "bit_base_windows_minions/map.jinja" import config with context %}
{%- set settings = config.settings  %}
{%- set minion_host = config.minion_hosts.get(grains.id, false) %}


windows_winlogbeat_conf:
  file.managed:
    - name: 'C:\\ProgramData\chocolatey\lib\winlogbeat\tools\winlogbeat.yml'
    - makedirs: True
    - template: jinja
    - source:
      - salt://bit_base_windows_minions/files/winlogbeat.yml.jinja2
        

winlogbeat:
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: 'C:\\ProgramData\chocolatey\lib\winlogbeat\tools\winlogbeat.yml'