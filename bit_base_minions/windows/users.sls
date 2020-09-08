{% from "bit_base_minions/map.jinja" import config with context %}
{%- set users = config.users  %}
{%- set remove_users = config.get('remove_users', []) %}


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