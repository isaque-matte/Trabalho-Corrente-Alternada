# Trabalho Final CA Filtros

**Autor:** [Isaque Schneider Matte]  
**Disciplina:** Circuitos de Corrente Alternada  

---

## Apresentação do Problema
Em sistemas de áudio, um único alto-falante não consegue reproduzir com perfeição todas as frequências audíveis. Para solucionar isso, caixas de som utilizam múltiplos alto-falantes (como woofers para graves e tweeters para agudos) combinados a um circuito "crossover". O problema de engenharia aqui é projetar filtros passivos que direcionem a faixa de frequência correta para o alto-falante correspondente. Além disso, enfrentamos o desafio prático de que os valores calculados matematicamente quase nunca existem no mercado, exigindo a adaptação do projeto para componentes comerciais limitados.

## Objetivos e Especificações
O objetivo é desenvolver uma ferramenta em MATLAB/Octave capaz de projetar e analisar o comportamento de um crossover passivo de 2 vias.

**Especificações do Projeto:**
* **Carga:** Alto-falantes com impedância puramente resistiva de **8 Ohms**.
* **Frequência de Corte:** **2000 Hz**.
* **Fator de Qualidade (Q):** **0.707** (Filtro tipo Butterworth para garantir transição suave).
* **Topologias Escolhidas:** * Passa-Baixas (LPF): Circuito RLC em série com a saída medida sobre o capacitor.
* Passa-Altas (HPF): Capacitor em série com um paralelo de indutor e resistor (saída no resistor).

## Funções de Transferência e Fórmulas de Projeto

As funções de transferência $H(s)$ e as equações de projeto derivadas para as topologias específicas escolhidas neste código são:

**Filtro Passa-Baixas:**
$$H(s) = \frac{\frac{1}{LC}}{s^2 + \left(\frac{R}{L}\right)s + \frac{1}{LC}}$$
Fórmulas dos componentes: $L = \frac{R \cdot Q}{\omega_c}$ e $C = \frac{1}{L \cdot \omega_c^2}$

**Filtro Passa-Altas:**
$$H(s) = \frac{s^2}{s^2 + \left(\frac{1}{RC}\right)s + \frac{1}{LC}}$$
Fórmulas dos componentes: $C = \frac{Q}{R \cdot \omega_c}$ e $L = \frac{1}{C \cdot \omega_c^2}$

## Lógica do Programa
O script foi desenvolvido de forma interativa e sequencial:
1. **Entrada de Dados:** O programa solicita ao usuário a frequência de corte, a impedância e o fator Q.
2. **Cálculos do LPF:** Determina os componentes ideais para o woofer e usa a função `min(abs(...))` para varrer os arrays de valores comerciais e encontrar a menor diferença.
3. **Análise de Transferência (LPF):** Utiliza a função `tf()` do MATLAB para criar o modelo ideal e o real, plotando-os via comando `bode()`.
4. **Cálculos e Análise do HPF:** Repete o processo matemático para a topologia do tweeter (cujas equações de base diferem do LPF devido ao arranjo do circuito).

## Guia de Execução
1. Certifique-se de ter o **MATLAB** ou o **GNU Octave** (com o pacote *control* carregado) instalado.
2. Abra o arquivo do código e execute-o.
3. No terminal (Command Window), digite os seguintes valores quando solicitado:
* Frequência de corte: **2000**
* Impedância: **8**
* Fator de qualidade: **0.707**
4. Os valores calculados serão exibidos no console e duas janelas gráficas (`Figure 1` e `Figure 2`) se abrirão mostrando os Diagramas de Bode comparativos.

---

## Análise dos Resultados

**Filtro Passa-Baixas (Woofer):**
* L Ideal: **0.45 mH** $\rightarrow$ L Comercial Selecionado: **0.47 mH**
* C Ideal: **14.07 uF** $\rightarrow$ C Comercial Selecionado: **15.00 uF**

**Filtro Passa-Altas (Tweeter):**
* L Ideal: **0.90 mH** $\rightarrow$ L Comercial Selecionado: **0.82 mH**
* C Ideal: **7.03 uF** $\rightarrow$ C Comercial Selecionado: **6.80 uF**

*(Insira aqui os prints dos gráficos de Bode gerados pelo MATLAB para os "Figures 1 e 2" para ilustrar as curvas).*

---

## Análise Crítica

Ao adaptar os valores matemáticos perfeitos para os componentes reais restritos pelas tabelas disponíveis, o comportamento do circuito sofreu alterações quantificáveis:

1. **Frequência de Corte Real:** No passa-baixas, o uso de **0.47 mH** e **15 uF** deslocou a frequência de corte de **2000 Hz** para aproximadamente **1895 Hz** (um desvio de **-105 Hz** ou **5.2%**).
2. **Frequência de Corte Real:** No passa-altas, o uso de **0.82 mH** e **6.8 uF** deslocou a frequência de corte para aproximadamente **2131 Hz** (um desvio de **+131 Hz** ou **6.5%**).
3. **Impacto Prático e Audibilidade:** Diferente da topologia simétrica, as configurações específicas do nosso código geraram frequências reais diferentes para cada filtro. Isso criou um pequeno "buraco" (gap) de cerca de **236 Hz** (entre **1895 Hz** e **2131 Hz**) onde o sinal sofre uma atenuação ligeiramente maior do que o desejado na soma acústica. Embora perceptível para ouvidos muito treinados (uma pequena perda de "presença" nas vozes, por exemplo), a diferença ainda é sutil no escopo de áudio geral.

## Conclusões

O projeto atingiu plenamente seus objetivos. O código é funcional e demonstrou com sucesso o comportamento dos filtros teóricos versus reais. 

O maior desafio deste projeto foi lidar com o fato de que as topologias requerem valores elétricos bastante específicos, e o distanciamento comercial impactou as duas vias em direções opostas (o LPF cortou mais cedo e o HPF cortou mais tarde). 

A principal lição de engenharia é que projetar não se trata apenas de calcular números perfeitos no papel, mas de saber lidar com tolerâncias. A limitação de componentes ensina que um bom engenheiro deve prever as variações do mundo real, simular os piores cenários e avaliar se o comprometimento no desempenho final atende ou não aos critérios de qualidade do produto desejado.