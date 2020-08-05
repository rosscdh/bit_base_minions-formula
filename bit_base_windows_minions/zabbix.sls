{% from "bit_base_windows_minions/map.jinja" import config with context %}
{%- set settings = config.settings  %}
{%- set minion_host = config.minion_hosts.get(grains.id, false) %}

"Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))":
  cmd.run:
    - shell: powershell
    - unless:
      - where chocola*

fw_zabbix_passive:
  win_firewall.add_rule:
    - name: Zabbix Passive (10050)
    - localport: 10050
    - protocol: tcp
    - action: allow

fw_zabbix_active:
  win_firewall.add_rule:
    - name: Zabbix Active (10051)
    - localport: 10051
    - protocol: tcp
    - action: allow

InstallZabbixAgent:
  chocolatey.installed:
    - name: zabbix-agent
    - install_args: '/ENABLEPATH:1 /SERVER:argus.bienert.tech /'

#remove_old_windows_zabbix_agent_conf:
#  file.absent:
#    - name: 'C:\ProgramData\zabbix\zabbix_agentd.conf'

windows_zabbix_agent_conf:
  file.managed:
    - name: 'C:\ProgramData\zabbix\zabbix_agentd.conf'
    - makedirs: True
    - template: jinja
    - source:
      - salt://bit_base_windows_minions/files/zabbix.config.jinja2
        

'Zabbix Agent':
  service.running:
    - enable: True
    - reload: True
    - watch:
      - file: C:\ProgramData\zabbix\zabbix_agentd.conf