# Lue ja tiivistä
## Karvinen 2021: Two Machine Virtual Network With Debian 11 Bullseye and Vagrant
- Vagrantilla voi luoda nopeasti kahden koneen virtuaaliverkon Debian käyttöjärjestelmällä.
- Se automatisoi VirtualBox-koneiden pystyttämisen ja SSH-kirjautumisen ilman graafista käyttöliittymää.
- Asennus on helppoa Debianilla ja Ubuntulla (`apt-get`) tai lataamalla asennusohjelmat Macille ja Windowsille.
- `Vagrantfile`-tiedosto määrittää verkon asetukset (kaksi konetta, IP-osoitteet, jaetut kansiot).
- Koneisiin voi kirjautua SSH:lla (`vagrant ssh <koneen_nimi>`), ja ne voivat kommunikoida keskenään sekä Internetin kanssa.
- Koneet on helppo tuhota (`vagrant destroy`) ja luoda uudelleen (`vagrant up`) harjoittelua varten.
- Ohje sisältää myös vianetsintävinkkejä yleisiin ongelmiin, kuten IP-osoitteiden sallittuihin alueisiin liittyen.
## Karvinen 2018: Salt Quickstart – Salt Stack Master and Slave on Ubuntu Linux

* Salt Master kuuluu asentaa tietokoneelle, jolla hallitaan orjia.
    ```bash
    sudo apt-get update
    sudo apt-get -y install salt-master
    ```
* Salt Slave (Minion) asennetaan kaikille orjille, joita halutaan hallita massoissa.
    ```bash
    # Orjakoneella
    sudo apt-get update
    sudo apt-get -y install salt-minion
    ```
* Orjien täytyy tietää masterin osoite ja saada yksilöivä ID.
    * _Mitäköhän tapahtuu, jos kaksi orjaa käyttää samaa ID:tä?_
* Orjat pitää hyväksyä masterilla.
    ```bash
    # Master-koneella
    sudo salt-key -A
    ```
    * _Tätäkin varmaan voisi automatisoida?_
## Salt Vagrant - automatically provision one master and two slaves
Tässä esimerkissä määritellään yksinkertainen SaltStack-konfiguraatio.

### 1. State-tiedoston (`init.sls`) luonti

* Luo hakemisto:
    ```bash
    $ sudo mkdir -p /srv/salt/hello
    ```
* Luo ja muokkaa `init.sls` YAML-muodossa (huomioi sisennykset, 2 välilyöntiä, ei tabeja):
    ```bash
    $ sudoedit /srv/salt/hello/init.sls
    ```
* Lisää sisältö tiedostoon:
    ```yaml
    # /srv/salt/hello/init.sls
    /tmp/seba:
      file.managed
    ```
    Tämä varmistaa, että tiedosto `/tmp/seba` on olemassa ja Saltin hallinnoima.

### 2. Staten (`hello`) ajaminen

* Aja `hello`-state kaikkiin minioneihin (`*`):
    ```bash
    $ sudo salt '*' state.apply hello
    ```

### 3. Top-tiedoston (`top.sls`) määrittely

* `top.sls` määrittää, mitkä statet ajetaan missäkin minionissa.
* Luo ja muokkaa `top.sls`:
    ```bash
    $ sudoedit /srv/salt/top.sls
    ```
* Lisää sisältö, joka kohdistaa `hello`-staten kaikkiin minioneihin `base`-ympäristössä:
    ```yaml
    # /srv/salt/top.sls
    base:
      '*':
        - hello
    ```

### 4. Statejen ajaminen `top.sls`:n avulla

* Nyt voit ajaa kaikki `top.sls`:ssä määritellyt statet ilman erillistä state-nimen mainintaa:
    ```bash
    $ sudo salt '*' state.apply
    ```
