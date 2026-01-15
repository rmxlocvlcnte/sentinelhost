# Visão Geral

- O SentinelHost é uma ferramenta leve de monitoramento e inspeção de segurança focada em máquinas locais, desenvolvido em bash, com foco em ambientes Linux. O objetivo é coletar informações de segurança do sistema e gerar relatórios estruturados para análise manual.
O projeto foi idealizado com uma mentalidade virada para **Blue Teaming / SOC**, priorizando simplicidade e baixo acoplamento.

# Princípios

- Host Based: A análise é feita de forma local, sem dependência de tráfego externo
- Read Only: Nenhuma alteração é feita no sistema, o script apenas analisa
- Paralelismo: Coleta simultaneamente e sincroniza análises no relatório
- Portabilidade: Uso mínimo de dependências

# Fluxo de Execução

```
main()
├── init.json()
├── analise_rede   &
├── analise_log    &
├── saude_sis      &
├── wait
├── close_json
```

Cada módulo é executado de forma independente e escreve no mesmo arquivo JSON utilizando **file locking** ```flock``` para evitar corrupção de dados

# Componentes do Código

## Coleta de Rede
- Interfaces de rede ativas (ip -brief addr)
- Portas em LISTEN (ss --tunlp)
- Filtro inicial em portas comumente usadas em ataques


## Análise de Logs
- Eventos Críticos atráves de ```journalctl```
- Tentativas de login falhas
- Indícios de força bruta (auth.log)

## Saúde do Sistema
- Tempo ativo
- Carga média da CPU
- Uso de memória
- Espaço em Disco
- Processos em alto consumo

## Formato de Saída
O sentinelhost gera:
- Relatório JSON estruturado para automação
- Log TXT para leitura humana

> Vale notar que a estrutura gerada em JSON ainda é manual, a mudar para ```jq``` no futuro

# Limitações atuais
- JSON feito manualmente, risco de escape
- Regex ainda é simples para portas

# A fazer
- Normalizar com ```jq```
- Classificação de riscos
- Detecção de Persistência
- Integrar com SIEMs 

> O sentinelhost foi feito para ser simples e auditável.
