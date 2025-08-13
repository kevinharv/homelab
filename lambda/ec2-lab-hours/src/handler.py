from typing import Any, Dict
from http import HTTPStatus
import json

def handler(event: Any, context: Any) -> Dict[str, Any]:
    print(event)
    print(context)

    method: str = event["requestContext"]["http"]["method"]
    path: str = event["requestContext"]["http"]["path"]

    # List all EC2 VMs with LabSystem: true
    # If event is "action": "powerOn", then power all VMs on
    # If event if "action": "powerOff", then shut the systems down

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps({
            "code": 200
        })
    }

