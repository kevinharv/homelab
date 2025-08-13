from rcon.source import Client

SERVER_HOST = "192.168.1.31"
SERVER_PORT = 25575
SERVER_PASS = "changeme!"

with Client(SERVER_HOST, SERVER_PORT, passwd=SERVER_PASS) as client:
    response = client.run('list')
    players_online: int = int(response.split()[2])
    max_players: int = int(response.split()[7])

print(f"Online: {players_online} | Max: {max_players}")
