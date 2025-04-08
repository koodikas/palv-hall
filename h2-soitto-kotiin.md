# Lue ja tiivistä
## Karvinen 2021: Two Machine Virtual Network With Debian 11 Bullseye and Vagrant
- Vagrantilla voi luoda nopeasti kahden koneen virtuaaliverkon Debian käyttöjärjestelmällä.
- Se automatisoi VirtualBox-koneiden pystyttämisen ja SSH-kirjautumisen ilman työpöytää.
- Asennus on helppoa, (`apt-get`) tai lataamalla asennusohjelman Windowsille.
- `Vagrantfile`-tiedosto määrittää verkon asetukset (kaksi konetta, IP-osoitteet, jaetut kansiot).
- Koneisiin voi kirjautua SSH:lla (`vagrant ssh <koneen_nimi>`), ja ne voivat kommunikoida keskenään sekä Internetin kanssa.
- Koneet on helppo tuhota (`vagrant destroy`) ja luoda uudelleen (`vagrant up`) harjoittelua varten.
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
- Luo hakemisto (`/srv/salt/hello`) Salt-tilatiedostoille.
- Määritä haluttu tila (esim. hallittu tiedosto `/tmp/infra-as-code`) `.sls`-tiedostoon (`init.sls`) YAML-syntaksilla.
- Aja tämä tila (`hello`) minioneihin (hallittaviin palvelimiin) komennolla `sudo salt '*' state.apply hello`.
- Luo `top.sls`-tiedosto määrittämään, mitkä tilat ajetaan millekin minionille.
- Määritä `top.sls`:ssä esimerkiksi, että kaikki minionit (`'*'`) ajavat `hello`-tilan.
- Aja `top.sls`:n mukaiset tilat komennolla `sudo salt '*' state.apply` ilman erillistä tilan nimeämistä.
# Tehtävät
## a) Hello Vagrant! Osoita jollain komennolla, että Vagrant on asennettu (esim tulostaa vagrantin versionumeron). En ole vielä asentanut Vagranttia, joten raportoin myös asentamisen.
Hain vagrant windows 11 ja haun sivussa wikipedia toteaa että se on HashiCorpin tekemä, joten menen esimmäiseen linkkiin: https://developer.hashicorp.com/vagrant/docs/installation ja latasin vagrant_2.4.3_windows_amd64.msi version. ![image](https://github.com/user-attachments/assets/7267acab-d7b5-4d8c-9cfe-dc4c8188a64d) Sitten käynnistin tietokoneen uudelleen.
Vagrant on asennettu ![image](https://github.com/user-attachments/assets/7f05e3f8-466a-47ff-b86f-8f04b564ebfa)
## b) Linux Vagrant. Tee Vagrantilla uusi Linux-virtuaalikone.
Tein Vagrantille uuden kansion ja navigoin sinne cmd:ssä. käskyllä vagrant init debian/bookworm64 sain tehtyä uuden configuraatio tiedoston. Tiedostoa ei tarvitse muokata. Käynnistetään virtuaalikoneen asennus käskyllä vagrant up. Vagrant latasi debian 12 boxin



# Lähteet
Karvinen 2021: Two Machine Virtual Network With Debian 11 Bullseye and Vagrant
Karvinen 2018: Salt Quickstart – Salt Stack Master and Slave on Ubuntu Linux 
Karvinen 2023: Salt Vagrant - automatically provision one master and two slaves
Karvinen: h2-soitto-kotiin https://terokarvinen.com/palvelinten-hallinta/#h2-soitto-kotiin
HashiCorp - Vagrant installation https://developer.hashicorp.com/vagrant/docs/installation
Gemini 2.5 Pro `Kuinka tarkistan Vagrantin asennuksen windowsilla`
