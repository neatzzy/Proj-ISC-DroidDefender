# PacMan Assembly RISC-V

## Descrição
Este projeto implementa um jogo similar ao PacMan utilizando a linguagem de programação Assembly para a arquitetura RISC-V. O objetivo é demonstrar a capacidade de desenvolver um jogo clássico em uma linguagem de baixo nível, explorando os recursos da arquitetura RISC-V.

## Funcionalidades
- Interface gráfica (Bitmap Display, 320×240, 8 bits/pixel);
- Interface com teclado (Keyboard and Display MMIO simulator);
- Interface de áudio MIDI (ecalls 31, 32, 33);
- 2 fases com layouts diferentes;
- Animação e movimentação do personagem;
- Colisão com as paredes e com os inimigos (perda de vida);
- Implementação das bolinhas dispostas ao longo da fase e condição de vitória ao coletar todas;
- Implementação dos 4 inimigos, com comportamentos distintos;
- Mecânica de ataque do personagem e mudança do comportamento dos inimigos ao coletar bolas especiais;
- HUD (heads-up display) com informações de score, fase e score máximo;
- Música e efeitos sonoros

## Pré-requisitos
Para executar o jogo, é necessário:
- Um simulador ou emulador de CPU RISC-V compatível. (Recomenda-se o [FPGARS](https://leoriether.github.io/FPGRARS/))
- Ambiente de desenvolvimento Assembly RISC-V configurado.


## Contribuição
Contribuições são bem-vindas! Sinta-se à vontade para abrir issues para reportar bugs, sugerir melhorias ou realizar pull requests.

## Licença
Este projeto está licenciado sob a [Licença MIT](https://opensource.org/licenses/MIT) - veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## Autores
- Élvis Miranda (@neatzzy)
- Gustavo Alves (@gusfring41)
- Pedro Marcinoni (@Liferoijrm)

---

Divirta-se jogando PacMan em Assembly RISC-V! 🎮
