function [bits, sig, tvec1] = init(Tb)
bits=randi([0 1],1,10);
NBits=length(bits);
tvec1=linspace(0,NBits*Tb,NBits*Tb);
sig=zeros(1,length(tvec1));
end
