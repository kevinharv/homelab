
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
  username:
    description: RCON password
    required: true
    type: str
  state:
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
raw_output:
  description: Raw response from the "list" command.
  type: str
'''

from ansible.module_utils.basic import AnsibleModule
from ansible.utils.display import Display
import re
display = Display()

def run_module():
    module_args = dict(
        host=dict(type='str', required=True),
        port=dict(type='int', required=False, default=25575),
        password=dict(type='str', required=True, no_log=True),
        state=dict(type='str', required=False, default='present'),
        username=dict(type='str', required=True)
    )

    result = dict(changed=False, raw_output='')

    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=False
    )

    try:
        from rcon.source import Client
    except ImportError:
        module.fail_json(msg="The 'rcon' Python package is not installed. Install it in your environment with 'pip install rcon'.")

    host = module.params['host']
    port = module.params['port']
    password = module.params['password']
    
    # To-Do - sanitize input
    username: str = module.params['username']
    state = module.params['state']

    if state not in ['present', 'absent']:
        module.fail_json(msg="Parameter 'state' must be 'present' or 'absent'.")

    if module.check_mode:
      module.fail_json(msg="Module does not support check mode.")

    with Client(host, port, passwd=password) as client:
        if state == "present":
            response = client.run(f"op {username}")
            display.vvv("hi")
            match = re.search(r"Made (\s+)", response)
            if match.group(1) == username:
                result['changed'] = True
                result['raw_output'] = response
                
            module.exit_json(**result)
    #     else:
    #         response = client.run(f"deop {username}")
    

    # try:
    #     with Client(host, port, passwd=password) as client:
    #         response = client.run("list")
    # except Exception as e:
    #     module.fail_json(msg=f"Failed to query RCON server: {e}")

    # match = re.search(r"There are (\d+) of a max of (\d+) players", response)
    # if not match:
    #     module.fail_json(msg="Unexpected response from server", raw_output=response)

    # result['online'] = int(match.group(1))
    # result['max'] = int(match.group(2))
    # result['raw_output'] = response
    module.exit_json(**result)

def main():
    run_module()

if __name__ == '__main__':
    main()
