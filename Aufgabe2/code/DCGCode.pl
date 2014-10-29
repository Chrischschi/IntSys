%prolog 
%Intelligente Systeme Praktikum 2
%Christian Schirin, Timo Lange
% 29.10.2014

/* Diese Datei beinhält die definition der DCG, basierend */
%TODO aktionen hinzufügen

/*Ein satz ist eine nominalphrase gefolgt von einer Verbalphrase.*/
s --> np,vp.

% "Eine Nominalphrase kann sein:" 
% Eigenname 
np --> e.

% Artikel, Nomen
np --> a,n.

% Artikel, Nomen, Präpositionalphrase
np --> a,n,pp.  

% "Eine Präpositionalphrase kann sein:"
% Präposition,Nominalphrase
pp --> p,np.

%Präposition,<Bestandteile einer Nominalphrase wie oben aufgeführt>
%Präposition,Eigenname
pp --> p,e.
%Präposition,Artikel,Nomen
pp --> p,a,n.
%Präposition,Artikel,Nomen
pp --> p,a,n,pp.

%Eine Verbalphrase kann sein:
%Verb 
vp --> v. 

%Verb,Nominalphrase
vp --> v,np.

 
