
from __future__ import absolute_import, division, print_function
__metaclass__ = type

DOCUMENTATION = r'''
---
module: players
short_description: Get current Minecraft server player count.
description:
  - Runs the "list" command against a Minecraft server to retrieve active and max players.
options:
  host:
    description: The hostname or IP of the Minecraft server.
    required: true
    type: str
  port:
    description: RCON port
    required: false
    type: int
    default: 25575
  password:
    description: RCON password
    required: true
    type: str
author:
  - Kevin Harvey (@kevinharv)
'''

EXAMPLES = r'''
- name: Get number of online players
  players:
    host: mc.example.com
    port: 25575
    password: my_rcon_password
  register: result

- debug:
    msg: "There are {{ result.online }} players online"
'''

RETURN = r'''
online:
  description: Number of players currently online.
  type: int
max:
  description: Maximum number of players.
  type: int
raw_output:
  description: Raw response from the "list" command.
  type: str
'''

from ansible.module_utils.basic import AnsibleModule
import re

def run_module():
    module_args = dict(
        host=dict(type='str', required=True),
        port=dict(type='int', required=False, default=25575),
        password=dict(type='str', required=True, no_log=True),
    )

    result = dict(
        changed=False,
        online=-1,
        max=-1,
        raw_message=''
      )

    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    try:
        from rcon.source import Client
    except ImportError:
        module.fail_json(msg="The 'rcon' Python package is not installed. Install it in your environment with 'pip install rcon'.")

    host = module.params['host']
    port = module.params['port']
    password = module.params['password']

    try:
        with Client(host, port, passwd=password) as client:
            response = client.run("list")
    except Exception as e:
        module.fail_json(msg=f"Failed to query RCON server: {e}")

    match = re.search(r"There are (\d+) of a max of (\d+) players", response)
    if not match:
        module.fail_json(msg="Unexpected response from server", raw_output=response)

    result['online'] = int(match.group(1))
    result['max'] = int(match.group(2))
    result['raw_output'] = response
    module.exit_json(**result)

def main():
    run_module()

if __name__ == '__main__':
    main()
