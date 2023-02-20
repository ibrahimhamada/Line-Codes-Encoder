function sig = unipNRZ(bits,Tb,sig)
  for i=1:length(bits)
      if i==1               
         sig(1:Tb)=bits(i);      
      else
         sig((i-1)*Tb+1:(i-1)*Tb+Tb)=bits(i);
      end
  end
end