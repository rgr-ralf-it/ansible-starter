#!/usr/bin/python

from ansible.module_utils.basic import *


def main():

    fields = {
        "no_to_increment": {"default": True, "type": int},
        "name_to_change": {"default": True, "type": str},
        "description": {"default": True, "type": str},
    }

    module = AnsibleModule(argument_spec=fields)
    # change the name
    nameToChange = module.params["name_to_change"]
    module.params.update({"name_to_change": nameToChange + " " + "After"})
    # increment the no
    noToIncrement = module.params["no_to_increment"]
    module.params.update({"no_to_increment": noToIncrement + 1})

    module.exit_json(changed=True, meta=module.params)


if __name__ == '__main__':
    main()

    
