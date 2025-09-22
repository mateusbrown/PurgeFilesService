# PurgeFilesService

PurgeFilesService é um projeto desenvolvido em Delphi baseado no projeto (https://github.com/silvercoder70/filepurger) que tem como objetivo automatizar o (simulado) processo de exclusão de arquivos em sistemas operacionais Windows.
O serviço permite configurar regras e diretórios para remoção periódica ou manual de arquivos, facilitando a gestão e limpeza de ambientes.

## Funcionalidades

- Exclusão automatizada de arquivos conforme regras definidas.
- Configuração de diretórios e padrões de arquivos.
- Registro de logs das operações realizadas.
- Interface gráfica para configuração e execução manual.

## Instalação

1. Clone o repositório:
   ```sh
   git clone https://github.com/mateusbrown/PurgeFilesService.git
   ```
2. Abra o projeto no Delphi ou ambiente compatível com Pascal.
3. Compile o projeto usando o arquivo `PurgeFilesService.dpr`.

## Como executar

Após a compilação, execute o arquivo binário gerado. Configure os diretórios e regras de exclusão conforme sua necessidade através da interface do programa.

## Exemplo de uso

1. Adicione diretórios para monitoramento.
2. Defina os padrões de arquivos a serem removidos (ex: *.log, *.tmp).
3. Inicie o serviço. O sistema realizará a exclusão conforme as regras.

## Principais arquivos

- `PurgeFilesService.dpr` — Arquivo principal do projeto.
- `uDeleteFiles.pas` — Lógica de exclusão de arquivos.
- `uLogProvider.pas` — Registro de logs.
- `uSettings.pas` e `uSettingsProvider.pas` — Configurações do serviço.
- `Win32/` — Diretório para arquivos de build específicos de Windows.

## Licença

Este projeto está sob a licença disponível no arquivo [LICENSE](LICENSE).
