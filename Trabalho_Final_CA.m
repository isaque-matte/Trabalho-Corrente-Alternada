clc;
clear;
close all;

% Valores em mH
indutores_reais = [0.10, 0.12, 0.15, 0.18, 0.22, 0.27, 0.33, 0.39, 0.47, 0.56, 0.68, 0.82, 1.0, 1.2, 1.5, 1.8, 2.2, 2.7, 3.3, 3.9, 4.7, 5.6, 6.8, 8.2, 10, 12, 15];

% Valores em uF
capacitores_reais = [1.0, 1.2, 1.5, 1.8, 2.2, 2.7, 3.3, 3.9, 4.7, 5.6, 6.8, 8.2, 10, 12, 15, 18, 22, 27, 33, 39, 47, 56, 68, 82, 100];

% Pedindo os dados para o usuario
f_corte = input('Digite a frequencia de corte (Hz): ');
imp_carga = input('Digite a impedancia da carga (Ohms): ');
Q = input('Digite o fator de qualidade: ');

Wc = f_corte * 2 * pi;
Wc_quadrado = Wc^2;

% =========================================================================
% FILTRO PASSA-BAIXAS
% =========================================================================
% Topologia: RLC em serie com Vout medida sobre o capacitor
% H(s) = (1/LC) / (S^2 + (R/L)S + 1/(LC))

% Calculo dos valores ideais
% R/L = Wc/Q -> L = R*Q/Wc
L_ideal_pb = imp_carga * Q / Wc;

% Wc^2 = 1/(LC) -> C = 1/(LWc^2)
C_ideal_pb = 1 / (L_ideal_pb * Wc_quadrado);

% Convertendo para mH e uF
L_ideal_mH_pb = L_ideal_pb * 10^3;
C_ideal_uF_pb = C_ideal_pb * 10^6;

% Encontrar o indutor e capacitor mais proximos dos valores ideais
[~, idx_L_pb] = min(abs(indutores_reais - L_ideal_mH_pb)); 
[~, idx_C_pb] = min(abs(capacitores_reais - C_ideal_uF_pb)); 

% Valores Reais no SI
L_real_pb = indutores_reais(idx_L_pb) * 10^-3;
C_real_pb = capacitores_reais(idx_C_pb) * 10^-6;

% Impressao dos resultados do LPF
fprintf('\n--- Filtro Passa-Baixas ---\n');
fprintf('Indutor ideal: %.2f mH\n', L_ideal_mH_pb);
fprintf('Capacitor ideal: %.2f uF\n\n', C_ideal_uF_pb);
fprintf('Indutor real selecionado: %.2f mH\n', indutores_reais(idx_L_pb));
fprintf('Capacitor real selecionado: %.2f uF\n', capacitores_reais(idx_C_pb));

% Montagem da Funcao de Transferencia Ideal (LPF)
R_div_L = imp_carga / L_ideal_pb;
Um_div_LC = 1 / (L_ideal_pb * C_ideal_pb);
cima_ideal_pb = [Um_div_LC];
baixo_ideal_pb = [1, R_div_L, Um_div_LC];
H_ideal_pb = tf(cima_ideal_pb, baixo_ideal_pb);

% Montagem da Funcao de Transferencia Real (LPF)
R_div_L_real = imp_carga / L_real_pb;
Um_div_LC_real = 1 / (L_real_pb * C_real_pb);
cima_real_pb = [Um_div_LC_real];
baixo_real_pb = [1, R_div_L_real, Um_div_LC_real];
H_real_pb = tf(cima_real_pb, baixo_real_pb);

% Grafico LPF
figure(1);
bode(H_ideal_pb, H_real_pb);
grid on;
legend('Resposta Ideal (PB)', 'Resposta Real (PB)');
title('Comparativo do Filtro Passa-Baixas');

% =========================================================================
% FILTRO PASSA-ALTAS
% =========================================================================
% Topologia: Capacitor em serie com o paralelo de um indutor e resistor 
% com Vout medida sobre o resistor.
% H(s) = S^2 / (S^2 + (1/RC)S + 1/(LC))

% Calculo dos valores ideais
% 1/RC = Wc/Q -> C = Q/(R*Wc)
C_ideal_pa = Q / (imp_carga * Wc);

% Wc^2 = 1/(LC) -> L = 1/(CWc^2)
L_ideal_pa = 1 / (C_ideal_pa * Wc_quadrado);

% Convertendo para mH e uF
C_ideal_uF_pa = C_ideal_pa * 10^6;
L_ideal_mH_pa = L_ideal_pa * 10^3;

% Encontrar o indutor e capacitor mais proximos dos valores ideais
[~, idx_L_pa] = min(abs(indutores_reais - L_ideal_mH_pa)); 
[~, idx_C_pa] = min(abs(capacitores_reais - C_ideal_uF_pa)); 

% Valores Reais no SI
L_real_pa = indutores_reais(idx_L_pa) * 10^-3;
C_real_pa = capacitores_reais(idx_C_pa) * 10^-6;

% Impressao dos resultados do HPF
fprintf('\n--- Filtro Passa-Altas ---\n');
fprintf('Indutor ideal: %.2f mH\n', L_ideal_mH_pa);
fprintf('Capacitor ideal: %.2f uF\n\n', C_ideal_uF_pa);
fprintf('Indutor real selecionado: %.2f mH\n', indutores_reais(idx_L_pa));
fprintf('Capacitor real selecionado: %.2f uF\n\n', capacitores_reais(idx_C_pa));

% Montagem da Funcao de Transferencia Ideal (HPF)
Um_div_RC = 1 / (imp_carga * C_ideal_pa);
Um_div_LC_pa = 1 / (L_ideal_pa * C_ideal_pa);
cima_ideal_pa = [1, 0, 0];
baixo_ideal_pa = [1, Um_div_RC, Um_div_LC_pa];
H_ideal_pa = tf(cima_ideal_pa, baixo_ideal_pa);

% Montagem da Funcao de Transferencia Real (HPF)
Um_div_RC_real = 1 / (imp_carga * C_real_pa);
Um_div_LC_pa_real = 1 / (L_real_pa * C_real_pa);
cima_real_pa = [1, 0, 0];
baixo_real_pa = [1, Um_div_RC_real, Um_div_LC_pa_real];
H_real_pa = tf(cima_real_pa, baixo_real_pa);

% Grafico HPF
figure(2);
bode(H_ideal_pa, H_real_pa);
grid on;
legend('Resposta Ideal (PA)', 'Resposta Real (PA)');
title('Comparativo do Filtro Passa-Altas');