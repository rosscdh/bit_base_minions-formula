"""
convert the windows network_interfaces to a pillar

salt '*' network.interfaces_names --output yaml
"""
import yaml
from pprint import pprint as pp
from pathlib import Path

data = yaml.load(Path('fixture-interface_names.yaml').read_bytes(), Loader=yaml.FullLoader)
# print(data)
output = dict(minion_hosts={})
for item, data in data.items():
    # import pdb;pdb.set_trace()
    if isinstance(data, list):
        # Assume the primary interface is item 1
        ethernet_interface = data[0]
        output['minion_hosts'][item] = {
            "rdp_enable": "true",
            "hostname": item,
            "net_adapter": ethernet_interface,
            "ip_proto": "static",
            "ip_addrs": []
        }
print(yaml.dump(output))