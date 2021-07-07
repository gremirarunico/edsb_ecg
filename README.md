Project: edsb_ecg

== Introduzione ==
Questo è il risultato di un lavoro per un progetto in un esame universitario.

Maggiori informazioni e la relazione del progetto la potrete trovare all'[indirizzo web di questo repository](https://gremirarunico.github.io/edsb_ecg/).

== Installazione ==
In questo progetto mancano i dati da elaborare. Essi sono reperibili su physionet ai seguenti indirizzi: [fibrillazione atriale](https://physionet.org/content/ltafdb/1.0.0/) e [battiti normali](https://physionet.org/content/nsrdb/1.0.0/).

Per elaborare i dati è necessario per prima cosa scaricarli da phisionet (si può usare wget o quello che volete), in seguito è necessario scaricare questo software addizionale [wfdb-matlab](https://physionet.org/content/wfdb-matlab/0.10.0/) e copiare la directory mcode all'interno della directory di lavoro.

I dati scaricati vanno copiati nella directory tools e vanno eseguiti gli script pyhton3 all'interno (da midificare per scegliere quali files elaborare). Nell'ordine eseguire extract_annotations.py che recupera i dati delle annotazioni da binario in testuale, data_conv_to_mat.py che estrae proprio i dati, poi eseguire convert_m_names.py (per rinominare i file nel modo corretto) e matconv.m (per fare le matrici trasposte, come il software desidera che siano posizionate) che servono per creare file .mat che accelerano il processo di lettura dei dati. In seguito seguire i passi del punto successivo (ad eccezione dell'estrazione dell'archivio compresso).

Nel caso si utilizzi l'archivio compresso *non ancora disponibile* dei file già pre elaborati si pososno saltare i passaggi precedenti e procedere direttamente da qui.
* Estrarre i dati compressi trovati nello share file di teams in physionetdata;
* è importante scaricare solo physionetdata, ma cached_data permette un caricamento molto più veloce dei files;
* aggiungere la directory functions al percorso con addpath('./functions').
