% Questa funzione trova il testo presente in una stringa
% che si trova compreso tra due sotto stringe per mezzo
% dell'utilizzo di espressioni regolari.

function out = findtextbetween(pre,after,text)

% escape for regex
pre = strrep(pre,'(','\(');
pre = strrep(pre,')','\)');
after = strrep(after,'(','\(');
after = strrep(after,')','\)');

expr = ['(?<=',pre,')(.*)(?=',after,')'];
%disp(expr);
index = regexp(text,expr);

out = [];
while(after(1) ~= text(index))
    out = [out, text(index)];
    index = index + 1;
end
    
end

