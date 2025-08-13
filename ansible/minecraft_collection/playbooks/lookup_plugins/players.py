# players.py - A custom lookup plugin for Ansible.

# pylint: disable=E0401
# players.py - A custom lookup plugin for Ansible.
# Author: Your Name (@username)
# Copyright 2020 Red Hat
# GNU General Public License v3.0+
# (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

DOCUMENTATION = """
    name: players
    author: Your Name (@username)
    version_added: "1.0.0"
    short_description: A custom lookup plugin for Ansible.
    description:
      - This is a custom lookup plugin to provide lookup functionality.
    options:
      _terms:
        description: Terms to lookup
        required: True
    notes:
      - This is a scaffold template. Customize the plugin to fit your needs.
"""

EXAMPLES = """
- name: Example usage of players
  ansible.builtin.debug:
    msg: "{{ lookup('players', 'example_term') }}"
"""

RETURN = """
_list:
  description: The list of values found by the lookup
  type: list
"""

from typing import Any, Dict, List, Optional

from ansible.errors import AnsibleError  # type: ignore
from ansible.plugins.lookup import LookupBase  # type: ignore
from ansible.utils.display import Display  # type: ignore
# from rcon.source import Client
import sys
print(">>> Plugin running under Python:", sys.executable)

try:
    from rcon.source import Client
except ImportError as e:
    raise AnsibleError("The 'rcon' Python module is required. Install it with: pip install rcon")

display = Display()


class LookupModule(LookupBase):  # type: ignore[misc]
    """
    Custom Ansible lookup plugin: sample_lookup
    A custom lookup plugin for Ansible.
    """

    def run(
        self,
        terms: List[str],
        variables: Optional[Dict[str, Any]] = None,
        **kwargs: Dict[str, Any],
    ) -> List[object]:
        """
        Run the lookup with the specified terms.

        Args:
            terms: A list of terms to lookup.
            variables: Additional variables.
            **kwargs: Additional keyword arguments.

        Returns:
            list: A list of processed results.

        Raises:
            AnsibleError: If the 'terms' parameter is not a list.
        """
        display.vvv(f"terms: {terms}, variables: {variables}")

        if not isinstance(terms, List):
            raise AnsibleError("The 'terms' parameter must be a list.")
        
        if len(terms) == 0:
            terms = ["current"]
        
        if terms[0] not in ["current", "max"]:
            raise AnsibleError("Player count lookup mode must be 'current' or 'max'.")

        display.vvv(f"Getting the {terms} number of players.")

        ansible_host = variables.get('ansible_host')
        ansible_port = variables.get('ansible_port')
        ansible_password = variables.get('ansible_password')

        try:
            with Client(ansible_host, ansible_port, passwd=ansible_password) as client:
                response = client.run('list')
                response_arr = response.split()
                players_online = int(response_arr[2])
                max_players = int(response_arr[7])

            return [{
                "online": players_online,
                "max": max_players
            }]

        except Exception as e:
            raise AnsibleError(f"Error in players plugin: {e}") from e
