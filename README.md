# microondas-vhdl
Implementação de um microondas usando VHDL

**Status**: Em desenvolvimento

## Arquitetura do sistema

O sistema possui três módulos a seguir:

* Módulo programação automática
* Módulo programação incremental
* Módulo programação via teclado

## Diagrama em blocos do sistema

![diagrama em blocos](/images/diagrama_blocos_microondas.png)

## Características

A contagem do temporizador inicia com o valor 0 min 0 seg (00:00).
Um LCD mostra o tempo restante de cozimento em progresso.


### Módulo de programação automática

Três botões de autocozimento fornecem as programações do forno:

* Pipoca (0 min 7 seg)
* Pizza (0 min 14 seg)
* Lasanha (1 min 3 seg)

#### Modos de operação para o módulo de programação automática

1. Quando ligado ou *cancel* acionado, o forno fica no _modo wait_ e a contagem em 00:00.
2. Um led acende sinalizando que o forno espera ser programado (*led wait*).
3. Seleciona-se uma programação de auto cozimento dentre as opções disponíveis (pipoca, pizza ou lasanha).
4. Inicia ou para o cozimento (botão *start/continue* e *stop*).
5. Contagem do **temporizador** decresce a cada segundo após iniciada.
6. A contagem para automaticamente quando atinge o valor zero e fica no modo *wait*.

### Módulo de programação incremental

Botões +3 e +5 *incrementam* o tempo do temporizador de 3 e 5 sengundos, respectivamente.

#### Modos de operação para o módulo de programação incremental

1. O forno de micro-ondas está no modo *wait*
2. Botões de autocozimento ou os botões +3 e +5 **alteram** o tempo de cozimento em *_qualquer situação_*
3. Botão **start** acionado e porta fechada _inicia_ a contagem decrescente do tempo de cozimento
4. Contagem do **temporizador** _decresce_ a cada seg.
   * Botões **+3** e **+5** _adiciona_ a contagem em progresso
   * Botão **stop** ou porta aberta _congelam_ a contagem
   * Botão **continue** __reinicia__ a contagem congelada
   * Botão **cancel** _zera_ e para a contagem
5. A contagem para automaticamente quando atinge valor zero e fica no modo *wait*

## Componentes principais

Os componentes principais são aqueles que compõem a lógica digital do sistema no nível mais alto.

Lista de componentes principais que já foram implementados ou que estão sendo implementados no momento:

- [x] Decodificador 1 (programação automática)
- [x] Temporizador de minutos e segundos
- [x] Controlador
- [ ] Decodificador 2 (programação incremental)
- [ ] ULA
- [ ] Controlador do teclado
- [ ] Registrador Controlador do Teclado
- [x] Controlador do LCD
- [x] Registrador Controlador do LCD

## Componentes secundários

São utilizados pelos componentes principais

Lista de componentes secundários que já foram implentados ou que ainda estão sendo trabalhados no momento:

- [x] Decrementador BCD8421
- [x] Divisor de frequência
- [x] Debounce
- [x] Registrador de 16 bits
