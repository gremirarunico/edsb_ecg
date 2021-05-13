function status = plotphysionet(points,attributes,gold,extras)
plots = tiledlayout(2,1);
% Top plot
p1 = nexttile(plots);
p2 = nexttile(plots);

plot(p1, ((1:attributes.totalsamples)/attributes.samplingFrequency)', points(:,1), '-');
plot(p2, ((1:attributes.totalsamples)/attributes.samplingFrequency)', points(:,2), '-');
linkaxes([p1,p2],'x');
title(p1, 'ECG1');
title(p2, 'ECG2');
xlabel(p1, '[s]');
ylabel(p1, '[int]');
xlabel(p2, '[s]');
ylabel(p2, '[int]');

pan xon
zoom xon

% add annotation to graph

NSamples = gold.sample(find(gold.beat=='N'));

p1.NextPlot = 'add';
plot(p1, ((NSamples)/attributes.samplingFrequency)', points(NSamples,1), '.');

p2.NextPlot = 'add';
plot(p2, ((NSamples)/attributes.samplingFrequency)', points(NSamples,2), '.');

VSamples = gold.sample(find(gold.beat=='V'));

%
pIndex = find(gold.beat=='+');
PSamples = gold.sample(pIndex);
labels = gold.aux(pIndex);

y = max(points(:,1));
y=300;
for i = 2:length(pIndex)
    ann = line(p1, [PSamples(i-1)/attributes.samplingFrequency,PSamples(i)/attributes.samplingFrequency],[y,y]);
    ann.Marker = 'o';
    text(p1, PSamples(i-1)/attributes.samplingFrequency, y, labels(i-1));
    
    ann = line(p2, [PSamples(i-1)/attributes.samplingFrequency,PSamples(i)/attributes.samplingFrequency],[y,y]);
    ann.Marker = 'o';
    text(p2, PSamples(i-1)/attributes.samplingFrequency, y, labels(i-1));
end
line(p1, [PSamples(end)/attributes.samplingFrequency,attributes.totalsamples/attributes.samplingFrequency],[y,y]);
line(p2, [PSamples(end)/attributes.samplingFrequency,attributes.totalsamples/attributes.samplingFrequency],[y,y]);
end

