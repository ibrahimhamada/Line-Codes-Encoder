function sig = unipRZ(bits,Tb,sig)
for i=1:length(bits)
                    if i==1
                            sig(1:floor(Tb/2))=bits(i);
                            sig(1+floor(Tb/2):Tb)=0;     
                    else
                            sig((i-1)*Tb+1:(i-1)*Tb+floor(Tb/2))=bits(i);
                            sig((i-1)*Tb+floor(Tb/2)+1:(i-1)*Tb+Tb)=0; 
                    end
end
end