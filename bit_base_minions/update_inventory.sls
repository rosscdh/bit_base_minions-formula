{% from "bit_base_minions/map.jinja" import config with context %}
{%- set minion_host = config.minion_hosts.get(grains.id, None) %}

{% if minion_host %}
update_minion_inventory:
  event.send:
    - name: bit/inventory/update
    - data:
      minion_host: "{{ minion_host }}"
      ip_address: "{{ minion_host.ip_addrs | first }}"
      client_name: "{{ salt['grains.get']('client_name', 'client_name not in grains') }}"
      zabbix_proxy: "{{ salt['pillar.get']('zabbix-agent:proxy', {}) }}"
      inventory: [
                  "os":             "{{ salt['grains.get']('osrelease', 'osrelease') }}",
                  "os_full":        "{{ salt['grains.get']('osfullname', 'osfullname') }}",
                  "vendor":         "{{ salt['grains.get']('manufacturer', 'manufacturer') }}",
                  "model":          "{{ salt['grains.get']('productname', 'productname') }}",
                  "type":           "{{ salt['grains.get']('manufacturer', 'manufacturer') }}",
                  "serialno_a":     "{{ salt['grains.get']('serialnumber', 'serialnumber') }}",
                  "location":       "{{ salt['grains.get']('location', 'not specified') }}",
                  "name":           "{{ salt['grains.get']('host', 'host') }}",
                  "alias":          "{{ salt['grains.get']('id') }}",
                  "site_notes":     "{{ salt['grains.get']('timezone') }}",
                  "site_rack":      "",
                  "hardware_full":  "num_gpus: {{ salt['grains.get']('num_gpus') }} cpuarch: {{ salt['grains.get']('cpuarch') }} cpu_model: {{ salt['grains.get']('cpu_model') }} num_cpus: {{ salt['grains.get']('num_cpus') }} biosversion: {{ salt['grains.get']('biosversion') }} motherboard_product_name: {{ salt['grains.get']('motherboard').get('productname') }} motherboard_serialnumber: {{ salt['grains.get']('motherboard').get('serialnumber') }}"
                 ]
{%- endif %}
