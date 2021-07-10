---
title: Introduzione
type: docs
---

# edsb_ecg

{{< columns >}}
## Cosa è

edsb_ecg è un progetto matlab che ha 2 obiettivi:
* Riconoscimento autonomo di un battito su un tracciato ECG;
* Riconoscimento della fibrillazione atriale.

<--->

## Come nasce

edsb_ecg nasce come progetto per un esame universitario, pertanto è da intendersi
puramente a scopo didattico.

Dopo aver passato con successo l'esame a credo sia consono
pubblicare il lavoro per tutti.
{{< /columns >}}

## Cosa contiene
{{< columns >}}
**Riconoscimento QRS**
![ECG](ecg1.png)
Per il riconoscimento dei QRS sono stati implementati diversi algoritmi
* Fraden-Newmann;
* Template (Norma L2 e Crosscorrleazione);
* Wavelet
Il massimo ottenuto è una
{{< katex display >}}
Sens_average=96,14%{{< /katex >}}

{{< katex display >}}
Spec_average=99,80%{{< /katex >}}

{{< katex display >}}
Acc_average=99,76%{{< /katex >}}
<--->
**Fibrillazione atriale**
![AFIB](afib_algo.png)

Per la fibrillazione atriale è stato usato un algoritmo che utilizza il plot
di Poincaré e la sample entropy.

{{< katex display >}}
Sens_average=79,87%{{< /katex >}}
{{< katex display >}}
Spec_average=91,95%{{< /katex >}}
{{< /columns >}}

## Documentazione

Il progetto verrà documentato piano piano. Nel frattempo quello che renderemo
pubblica è la [relazione del progetto](/relazione) e il [codice](https://github.com/gremirarunico/edsb_ecg).

Il codice è stato parzialmente documentato, ogni collaborazione è benaccetta.

Sarebbe anche da effettuare una traduzione in inglese della relazione e dei commenti,
ma dal momento che la consegna era da svolgere in italiano e il lavoro da fare
non era poco per il momento la traduzione è in sospeso fino a data da destinarsi.
