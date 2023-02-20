function sig = AMI(bits,Tb,sig)
sign=1;
             for i=1:length(bits)
                 am=bits(i)*sign;
                    if i==1               
                      sig(1:Tb)=am;      
                    else
                      sig((i-1)*Tb+1:(i-1)*Tb+Tb)=am;
                    end
                    if bits(i)==1
                        sign=sign*(-1);
                    end
             end
end