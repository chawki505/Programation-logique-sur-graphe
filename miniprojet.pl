% les sommets du graph
sommet(a).
sommet(b).
sommet(c).
sommet(d).
sommet(e).
sommet(f).
sommet(g).


% predicat test sommet existe ou non.
isSommet(Point):- sommet(Point).


% les arcs (couple de sommet avec cout).
arc(a,b,1).
arc(b,e,2).
arc(a,c,3).
arc(c,d,2).
arc(e,d,3).
arc(d,f,2).
arc(d,g,3).
arc(f,g,2).
arc(g,a,2).





% predicat pour test un chemin si il existe .
chemin(Point1,Point2):- arc(Point1,Point2,_),!.

chemin(Point1,Point2):- arc(Point1,PointT,_),chemin(PointT,Point2).



% predicat pour tester un chemin si il existe avec une list.
chemin2(Point1,Point2):- chemin2(Point1,Point2,[]).

chemin2(Point1,Point2,_):- arc(Point1,Point2,_),!.

chemin2(Point1,Point2,List):-  not(member(Point1,List)),
                               arc(Point1,PointT,_),
                               chemin2(PointT,Point2,[Point1|List]).



% dans un graph oriente en parle de circuit , pas de cycle
% on appelle circuit une suite d'arcs consecutifs (chemin) dont les deux
% sommets extremites sont identiques.
testCircuit(Point):- chemin2(Point,Point),
                     write('Graphe avec circuit '),!.

testCircuit(_):- write('Graphe sans circuit '),fail.



% Le graphe est dit connexe lorsqu'il existe une chaine entre deux
% sommets quelconques.
testConnexe(Point1,Point2):- chemin2(Point1,Point2),
                             chemin2(Point2,Point1),
                             write('Graph connexe '),!.

testConnexe(_,_):- write('Graph non connexe '),fail.






% afficher tous les chemins possible entre deux sommets dans des liste
% avec le cout total de chaque chemin
afficheAllChemin(Point1,Point2):- not(chemin2(Point1,Point2)),
                                  write('Aucun chemin'),!,fail.

afficheAllChemin(Point1,Point2):- forall(afficheAllChemin(Point1,Point2,Cout,Chemin,[]),
                                  ( write('----> Cout : '), write(Cout),
                                  write('    Chemin : '), write(Chemin),nl )).

afficheAllChemin(Point1,Point2,Cout,[Point1,Point2],_) :- arc(Point1,Point2,Cout).

afficheAllChemin(Point1,Point2,Cout,[Point1|List1],List2):- not(member(Point1,List2)),
                                                            arc(Point1,PointT,CoutT),
                                                            afficheAllChemin(PointT,Point2,Cout2,List1,[Point1|List2]),
                                                            Cout is Cout2+CoutT.








% afficher le chemin le plus court  (le plus court chemin).
:-dynamic(cheminMin/2).


afficheMinChemin(Point1,Point2):- not(chemin2(Point1,Point2)),write('Aucun chemin'),!,fail.

afficheMinChemin(Point1,Point2):- afficheMinChemin(Point1,Point2,Cout,Chemin),
                                  (write('Cout : '), write(Cout),
                                  write('  Chemin : '),write(Chemin),nl).

afficheMinChemin(Point1,Point2,Cout,Chemin):- not(cheminMin(_,_)),
                                              afficheAllChemin(Point1,Point2,CoutT,CheminT,[]),
                                              assertz(cheminMin(CoutT,CheminT)),!,
                                              afficheMinChemin(Point1,Point2,Cout,Chemin).

afficheMinChemin(Point1,Point2,_,_):- afficheAllChemin(Point1,Point2,CoutT2,CheminT2,[]),
                                      cheminMin(CoutT,CheminT),CoutT2 < CoutT,
                                      retract(cheminMin(CoutT,CheminT)),
                                      asserta(cheminMin(CoutT2,CheminT2)),fail.


afficheMinChemin(_,_,Cout,Chemin):- cheminMin(Cout,Chemin),
                                    retract(cheminMin(Cout,Chemin)).
