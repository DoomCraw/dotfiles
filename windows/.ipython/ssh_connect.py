#------------------------------------------------------ PYTHON3 SNIPPETS -------------------------------------------------
# Полезные библиотеки
# https://github.com/docopt/docopt - creates beautiful command-line interfaces
# https://pypi.org/project/texttable/ - рисует собственно текстовые таблички в консоли


#paramiko execute cmd with private key
#!/usr/bin/python3
import paramiko
import io

ssh_possible_users = ['ubuntu', 'ec2-user', 'centos', 'rocky', 'root']

def prepare_key(keyfile, password):
    keyfile = io.StringIO(open(keyfile, 'r').read())
    pkey = paramiko.RSAKey.from_private_key(keyfile, password=password)
    return pkey

def prepare_connection (host, user, pkey):
    client = paramiko.client.SSHClient()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    client.connect(hostname=host, username=user, pkey=pkey)
    return client

def ssh_cmd(client, cmd):
    _stdin, _stdout, _stderr = client.exec_command(command=cmd)
    return _stdout.read().decode()

pkey = prepare_key('.ssh/vzaytsev_devs.pem.key', '')
client = prepare_connection('rapid19', 'ubuntu', pkey)
for r in ssh_cmd(client, 'pwd').split('\n'):
    print(r)
