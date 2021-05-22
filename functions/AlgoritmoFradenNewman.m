function [r_s]=AlgoritmoFradenNewman(t,x,ann,th1)
%  Fraden-Newman (AF2)
% INPUT: 
% t  :  time [s]
% x  :  signal [mV]
% ann:  annotations of R peaks

% OUTPUT:
% r_s : samples where the r peak is identified by the algorithm


r_s=[];

n=length(x);
if ~exist('th1', 'var')
    th1=0.8*max(x);
end

th2=0.7;

%Rettificazione del segnale
y0=abs(x);

%"low level clipper"
for i=1:n
    if y0(i)<th1
        y1(i)=th1;
    else
        y1(i)=y0(i);
    end
end

% figure;
% %in the following subplots we plot the various phases of the algorithm
% subplot(4,1,1)
% plot(t,x)
% hold on
% plot(t(ann),x(ann),'go');
% subplot(4,1,2)
% plot(t,y0)
% subplot(4,1,3)
% plot(t,y1);
% suptitle('Fraden Newman');
%Derivazione del primo ordine
y2=y1(1,3:n)-y1(1,1:n-2);
%ovviamente questo vettore sarà 2 elementi più corto di quello iniziale.
%Aggiungiamo zero padding all'inizio
y2=[0 0 y2];



for i=1:length(y2)
    if y2(i)>th2
        r_s=[r_s;i];
   
    end
end
    
% subplot(4,1,4)
% plot(t,y2);
% hold on
% plot(t(ann),y2(ann),'go');
% plot(t,th2*ones(length(t),1),'r-');
% plot(t(r_s),y2(r_s),'rx');
% if isempty(r_s)
% legend('signal','reference peaks','threshold');
% else
%     legend('signal','reference peaks','threshold','identified peaks');
% end
%     

