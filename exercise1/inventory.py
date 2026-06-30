#!/usr/bin/env python3
import json
import os
import re

def parse_env(file_path):
    env_vars = {}
    if os.path.exists(file_path):
        with open(file_path, 'r') as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith('#'):
                    continue
                match = re.match(r'^\s*([\w.-]+)\s*=\s*(.*)$', line)
                if match:
                    key = match.group(1)
                    val = match.group(2).strip('\'"')
                    env_vars[key] = val
    return env_vars

def main():
    # Cari file .env di root project
    base_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
    env_path = os.path.join(base_dir, '.env')
    
    if not os.path.exists(env_path):
        # Fallback ke directory saat ini
        env_path = '.env'
        
    env = parse_env(env_path)
    
    web1_ip = env.get('WEB1_IP', '127.0.0.1')
    web1_user = env.get('WEB1_USER', 'ubuntu')
    web2_ip = env.get('WEB2_IP', '127.0.0.1')
    web2_user = env.get('WEB2_USER', 'ubuntu')
    
    inventory = {
        "webservers": {
            "hosts": ["web1", "web2"]
        },
        "_meta": {
            "hostvars": {
                "web1": {
                    "ansible_host": web1_ip,
                    "ansible_user": web1_user,
                    "ansible_ssh_private_key_file": "~/.ssh/id_rsa"
                },
                "web2": {
                    "ansible_host": web2_ip,
                    "ansible_user": web2_user,
                    "ansible_ssh_private_key_file": "~/.ssh/id_rsa"
                }
            }
        }
    }
    
    print(json.dumps(inventory, indent=2))

if __name__ == '__main__':
    main()
