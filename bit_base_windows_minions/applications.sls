{% from "bit_base_windows_minions/map.jinja" import config with context %}
{%- set settings = config.settings  %}
{%- set minion_host = config.minion_hosts.get(grains.id, false) %}

# choco install Firefox --params "/l:de-DE"

#
# Standard
#
install_standard_apps:
  pkg.installed:
  - pkgs:
    {% for app in settings.apps.standard_apps %}
    - {{ app }}
    {% endfor %}


#
# Chocolatey Versions
#
{% for app in settings.apps.chocolatey_apps %}
'install_{{ app.name }}':
  chocolatey.installed:
  - name: {{ app.name }}
  - package_args: {{ app.params | default('') }}
  - install_args: {{ app.package_args | default('') }}
{% endfor %}
