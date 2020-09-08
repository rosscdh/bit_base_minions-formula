{% from "bit_base_minions/map.jinja" import config with context %}
{%- set settings = config.settings  %}
{%- set minion_host = config.minion_hosts.get(grains.id, false) %}

# choco install Firefox --params "/l:de-DE"

#
# Standard
#
{%- if settings.apps is defined and settings.apps.standard_apps is defined and settings.apps.standard_apps|length %}
install_standard_apps:
  pkg.installed:
  - pkgs:
    {% for app in settings.apps.standard_apps %}
    - {{ app }}
    {% endfor %}
{%- endif %}

#
# Chocolatey Versions
#
{%- if settings.apps is defined and settings.apps.chocolatey_apps is defined and settings.apps.chocolatey_apps|length %}
{% for app in settings.apps.chocolatey_apps %}
'install_{{ app.name }}':
  chocolatey.installed:
  - name: {{ app.name }}
  - package_args: {{ app.params | default('') }}
  - install_args: {{ app.package_args | default('') }}
{% endfor %}
{%- endif %}