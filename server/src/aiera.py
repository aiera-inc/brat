import requests

import config


def aiera_resolve(path):
    resp = requests.get(config.AIERA_RESOLVE_API, {"path": path}, headers={"X-API-Key": config.AIERA_API_KEY})
    if resp.ok:
        with open(path + ".txt", "w") as f:
            f.write(resp.text)
        return resp.text
    return None
