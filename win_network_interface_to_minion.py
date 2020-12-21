"""
convert the windows network_interfaces to a pillar

salt '*' network.interfaces_names --output yaml > output.yaml
python3 win_network_interface_to_minion.py
"""
import yaml
from pprint import pprint as pp
from pathlib import Path

data = yaml.load(Path('output.yaml').read_bytes(), Loader=yaml.FullLoader)
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