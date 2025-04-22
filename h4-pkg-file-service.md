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
- Apachen asennus:`sudo apt update && sudo apt install apache2 -y`
- Testi toimiiko:`sudo systemctl status apache2`ja tarkastelun jälkeen `q`
- Korvataan nettisivun html tiedoston sisältö echon tekstillä:`echo Testing out my cool website | sudo tee /var/www/html/index.html`
## b) SSHouto. Lisää uusi portti, jossa SSHd kuuntelee.
- `vagrant up`,  Vagrant tiedosto löytyy [tästä](https://github.com/koodikas/palv-hall/blob/main/Vagrant)
1. otin yhteyden minioniin `t002` komennolla `vagrant ssh t002`
2. menin katsomaan asetustiedostoa mitä vihjeissä kerrottiin: /etc/ssh/sshd_config `sudo nano /etc/ssh/sshd_config`
   - ![image](https://github.com/user-attachments/assets/5349de50-15ec-46cf-a575-5970d38ce895)

3. configista löytyi heti `#Port 22` teksti. Otan kommentoinnin pois ja lisään uuden portin 1234
   ![image](https://github.com/user-attachments/assets/95d44a17-82f4-4e7c-b40a-e852d320091c)
4. poistuin editorista näppäimillä: `CTRL + q`,`y`ja`enter`
5. käynnistin sshd:n uudelleen komennolla: `sudo systemctl restart sshd`
### Testit, toimiiko portti.
Ensin paikallisesti:
- `ssh -p 1234 vagrant@localhost` ![image](https://github.com/user-attachments/assets/54460100-0074-4057-8a53-603e0ef37c7e)
Sitten Masterilta käsin.
- Kirjauduttuani masterille laitoin
  - Hups! ![image](https://github.com/user-attachments/assets/0243ca4e-3e5c-406b-ad2d-37ee808c0345)
  - Gemini2.5 Pro neuvoi, että salasanatodennus taitaa estää yhdistämisen. Sitten menin kokeilemaan salasanan autentikointia.
      - Eli minionilla sudo nano /etc/ssh/sshd_config ja salasanan varmistus päälle:
        ![image](https://github.com/user-attachments/assets/28622d30-644b-4c71-ab61-b763bad80445)
        - Ei auttanut: ![image](https://github.com/user-attachments/assets/11befc12-e527-41dd-9d81-b4880cb8a0c6)
#### jäin jumiin tehtävässä en tiedä mitä tehdä 🥲
        




# Lähteet
- Karvinen 2018: Pkg-File-Service: https://terokarvinen.com/2018/04/03/pkg-file-service-control-daemons-with-salt-change-ssh-server-port/
- Tehtävienanto ja vihjeet: https://terokarvinen.com/palvelinten-hallinta/#h4-pkg-file-service
- Gemini 2.5 Pro (experimental)
  - kääntämisessä englannista suomeksi
  - avaamaan komentojen merkintöjä `-p` `-y` jne.
