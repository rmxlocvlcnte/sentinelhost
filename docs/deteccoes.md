Esse documento descreve o que o SentinelHost detecta, como detecta e quais são as limitações conhecidas até o momento

# Serviços Expostos (Portas em ESCUTA)

## O que é analisado?
- Portas TCP e UDP em estado de escuta
- Serviços associados ao ID do Processo (PID)

## Técnica de Análise
```ss -tulnp```
Filtro inicial por portas reconhecidas como sensíveis **(A MUDAR)**
- Porta 21 (FTP)
- Porta 22 (SSH)
- Porta 23 (TELNET)
- 3389 (RDP)
- 4444 (Reverse Shell Comum)
- 5900 (VNC)

## Limitações
- Não identifica portas HTTP ou HTTPS (80 e 443)
- Portas mais altas não são analisadas

# Tentativas de LogIn

## O que é analisado
- Eventos de Autenticação
- Falhas recorrentes de LogIn

## Como é feita a análise
```journalctl -p err..alert
grep -Ei 'failed|denied|unauthorized'
```
E de maneira adicional
```grep 'failed password' /var/log/auth.log```

> Logs podem estar rotacionados, a melhorar.

# Recursos em Abuso

Processos em alto consumo de memória são analisados com 
```ps aux --sort=-%mem | head```

> NÃO identifica malwares fileless e NÃO analisa comportamento a longo prazo

# Interfaces de Rede

São analisadas interfaces ativas e endereços IP associados

> NÃO detecta interfaces virtuais

# O que NÃO é detectado

- Rootkits a nível de kernel
- Comunicação C2 criptografada
- Exploits em tempo real
- Persistência

# Classificação de Severidade (NÃO implementado, mas está nos planos)

| Evento                 | Severidade |
| ---------------------- | ---------- |
| Porta Sensível exposta |      Média |
| Ataque de Força Bruta  |       Alta |
| Alto Consumo           |      Média |

# A melhorar

- Detecção de persistência (cron, systemd)
- Identificação de binários sem inode
- Análise de conexões
- Integrar com MITRE ATT&CK
