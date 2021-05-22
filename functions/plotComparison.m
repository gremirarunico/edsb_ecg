% plotphhisionet.m (c) Marco
% Disegna un plot da physionet, fornire
% punti, attributi, gold standard e valori aggiuntivi
function plotComparison(points, attributes, gold,myAnnotations, d)
figure
hold on

% Disegna i grafici delle 2 derivazione x,y con x base dei tempi (in
% secondi), y il valore del campione
plot(((1:attributes.totalsamples)/attributes.samplingFrequency)', points, '-');

xlabel('[s]');
ylabel('[V]');

% abilito lo zoom sull'asse x
pan xon
zoom xon

% aggiungo le annotazioni
% trovo l'indice dei campioni con le annotazioni normali (battiti normali)
NSamples = gold.sample(find(gold.beat=='N'));

% aggiungo un punto rosso sull'annotazione dei QRS del gold
plot(((NSamples)/attributes.samplingFrequency)', points(NSamples), '.r');

% aggiungo un punto verde sull'annotazione dei QRS dell'algoritmo
plot(((myAnnotations)/attributes.samplingFrequency)', points(myAnnotations), 'og');

if exist('d', 'var')
    plot(((1:length(d))/attributes.samplingFrequency), d);
end

end

