# Lue ja tiivistä
## Karvinen 2018: Pkg-File-Service – Control Daemons with Salt – Change SSH Server Port
- Pkg-File-Service -malli: Saltilla hallitaan palveluita (daemon)
  1. asentamalla paketti
  2. hallinnoimalla asetustiedostoa
  3. varmistamalla palvelun tila (käynnissä/uudelleenkäynnistys).
- SSH-portin vaihto:
  1. Luodaan SSH state tiedosto joka kopioi muokatun config tiedoston ohjelman luoman tiedoston päälle.
  2. Kopioidaan alkuperäinen config tiedosto ja muokataan se haluamalla tavalla
     - muista tallentaa se määritettyyn lokaatioon mistä se kopioidaan
  3. käynnistä sls tiedosto saltilla
  4. ???
  5. profit
  - Näin saadaan useamalle koneelle vaihdettua ssh portti helposti.
# Tehtävät
## a) Apache easy mode. Asenna Apache, korvaa sen testisivu ja varmista, että demoni käynnistyy.
- 'sudo apt update && sudo apt install apache2 -y'
## b) SSHouto. Lisää uusi portti, jossa SSHd kuuntelee.




# Lähteet
- Karvinen 2018: Pkg-File-Service: https://terokarvinen.com/2018/04/03/pkg-file-service-control-daemons-with-salt-change-ssh-server-port/
- Tehtävienanto ja vihjeet: [https://terokarvinen.com/palvelinten-hallinta/#h3-infraa-koodina](https://terokarvinen.com/palvelinten-hallinta/#h4-pkg-file-service)
- Gemini 2.5 Pro (experimental)
  - kääntämisessä englannista suomeksi
  - avaamaan komentojen merkintöjä `-p` `-y` jne.
