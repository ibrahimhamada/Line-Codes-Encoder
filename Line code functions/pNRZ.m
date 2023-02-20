function sig = pNRZ(bits,Tb,sig)
for i=1:length(bits)
                    if i==1
                       if bits(i)==0
                           sig(1:Tb)=-1;
                       else
                           sig(1:Tb)=bits(i);
                       end
                    else
                        if bits(i)==0
                            sig((i-1)*Tb+1:(i-1)*Tb+Tb)=-1;
                        else
                            sig((i-1)*Tb+1:(i-1)*Tb+Tb)=bits(i);
                        end
                    end
end
end