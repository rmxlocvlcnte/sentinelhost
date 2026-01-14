# Sentinelhost

Projeto focado em visibilidade de host, detecção inicial de atividades suspeitas e geração de logs para análises de segurança em ambientes Linux.

# Motivação

O projeto tem como objetivo:
- Ajudar na identificação inicial de comportamentos suspeitos em hosts Linux
- Centralizar informações relevantes do sistema para análise forense leve
- Servir como base educacional para detecção a nível de host
- Gerar relatórios para leitura humana

# O que o script faz

No momento, o script tem funções básicas e simples para:
- Coletar interfaces de rede ativas
- Identificar portas TCP/UDP em escuta
- Detectar falhas de autenticação atráves de 'auth.log' e 'journalct'
- Coletar métricas básicas do host (Tempo em atividade, Memória, Espaço em Disco)
- Listar processos com o maior consumo de memória
- Gerar relatório no formato JSON

# ATENÇÃO
- O projeto NÃO é um IDS/IPS completo
- Não realiza bloqueio automático de IP ou Processos
- Não substitui ferramentas de SIEM como Wazuh e Splunk

# Forma de usar
- Clone o projeto com ```git clone https://github.com/rmxlocvlcnte/sentinelhost```
- Entre no diretório do projeto ```cd sentinelhost```
- Torne o script executável com ```chmod +x sentinelhost.sh```
- Rode com ```sudo sentinelhost.sh```

# Aviso
Este projeto foi feito para fins educacionais, use como **ferramenta auxiliar**, não deve ser utilizado como fonte única de detecção de incidentes.
