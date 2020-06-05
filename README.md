# Tema2-IOCLA
Stegano

         Tema 2 IOCLA 
        Realizata de: Babin Sergiu, 324CC

Tema a fost realizata timp de 4 zile in 999 de linii de cod :)

==================================Task 1========================================

 La acest task am facut o functie bruteforce_singlebyte_xor() care face xor pe
fiecare element din matrice cu o cheie = [0..256] fara a schimba valoarea din 
matrice, apoi verifica daca sa gasit fiecare element din stringul "revient" 
(am pus revient intr-un string si il parcurg byte cu byte) consecutiv pe o 
linie din matrice, in caz afirmativ functie se termina si trec la urmatoarea 
functie de printare a linie pe care am gasit cuvantul respectiv, functia primeste 
ca parametri imaginea, linia si cheia cu care sa gasit cuvantul, si afiseaza 
toate caracterele de pe linie pana cand nu intalneste terminatorul de sir sau se 
termina linia. 


==================================Task 2========================================

 La task-ul 2 am folosit fuctie bruteforce_singlebyte_xor() de la task 1 pentru a 
gasi cheia si linia pe care se afla mesajul, apoi xorez toata matricea cu cheia aflata
{xor_Matrix()}, dupa care introduc mesajul nou cu o linie mai jos {new_mesaje()},
calculez noua cheie dupa formula key = floor((2*old_key+3)/5)-4 {new_key()}, si 
xorez deja matricea cu noua cheie {xor_Matrix()}.
--Mesajul l-am pastrat intr-un string si l-am parcurs byte cu byte.

==================================Task 3========================================

 La ascet task am facut o functie morse_encrypt() in care parcurg stringul primit
ca argument in linia de comanda byte cu byte si codific fiecare litera modificand
direct si valorile din matrice incepand cu indicele primit ca argument in linia 
de comanda caracterurile corespunzatoare din codul morse.
Apoi afisez imaginea.

==================================Task 4========================================

 Task-ul 4, am format o functie lsb_encode() in care am luat fiecare octet din 
cuvantul primit ca argument in linia de comanda si am schimbat fiecare LSB din 
elementele matricei (incepand cu indicele dat ca argument in linia de comanda) 
cu bitii din octetul corespunzator literei.
Apoi am afisat imaginea.

==================================Task 5========================================

 La acest task am facut o functie lsb_decode() in care am luat fiecare LSB din 
elementele matricei incepand cu indicele (primit ca argument in linia de comanda) 
si l-am stocat intr-un registru facand shiftarea lui pana cand ocupam toti 8 biti
dupa care afisam octetul corespunzator, repetam toate aceste actiuni pana cand 
gasim terminatorul de sir, adica primul octet = 0.

==================================Task 6========================================

 La task-ul 6 am facut o functie blur() care contine doua parti, prima in care 
calculez media aritmetica dintre elementul din matrice si toti vecini lui mai putin
cei de pe diagonala, apoi am introdus pe stiva fiecare medie aritmedica facuta, ca 
dupa sa trec la partea a doua in care am parcurs matricea in ordine inversa si apoi 
am scos pe rand fiecare element din stiva ca apoi sa il introduc in matrice.
Matrice a fost parcursa in ordine inversa deoarece elementele pe stiva se aflau in 
ordine inversa.



