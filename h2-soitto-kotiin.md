# Lue ja tiivistä

## Karvinen 2021: Two Machine Virtual Network With Debian 11 Bullseye and Vagrant

- Vagrantilla voi luoda nopeasti kahden koneen virtuaaliverkon Debian käyttöjärjestelmällä.
- Se automatisoi VirtualBox-koneiden pystyttämisen ja SSH-kirjautumisen ilman työpöytää.
- Asennus on helppoa, (`apt-get`) tai lataamalla asennusohjelman Windowsille.
- `Vagrantfile`-tiedosto määrittää verkon asetukset (kaksi konetta, IP-osoitteet, jaetut kansiot).
- Koneisiin voi kirjautua SSH:lla (`vagrant ssh <koneen_nimi>`), ja ne voivat kommunikoida keskenään sekä Internetin kanssa.
- Koneet on helppo tuhota (`vagrant destroy`) ja luoda uudelleen (`vagrant up`) harjoittelua varten.

## Karvinen 2018: Salt Quickstart – Salt Stack Master and Slave on Ubuntu Linux

- Salt Master kuuluu asentaa tietokoneelle, jolla hallitaan orjia.
  ```bash
  sudo apt-get update
  sudo apt-get -y install salt-master
  ```
- Salt Slave (Minion) asennetaan kaikille orjille, joita halutaan hallita massoissa.
  ```bash
  # Orjakoneella
  sudo apt-get update
  sudo apt-get -y install salt-minion
  ```
- Orjien täytyy tietää masterin osoite ja saada yksilöivä ID.
  - _Mitäköhän tapahtuu, jos kaksi orjaa käyttää samaa ID:tä?_
- Orjat pitää hyväksyä masterilla.
  ```bash
  # Master-koneella
  sudo salt-key -A
  ```
  - _Tätäkin varmaan voisi automatisoida?_

## Salt Vagrant - automatically provision one master and two slaves

- Luo hakemisto (`/srv/salt/hello`) Salt-tilatiedostoille.
- Määritä haluttu tila (esim. hallittu tiedosto `/tmp/infra-as-code`) `.sls`-tiedostoon (`init.sls`) YAML-syntaksilla.
- Aja tämä tila (`hello`) minioneihin (hallittaviin palvelimiin) komennolla `sudo salt '*' state.apply hello`.
- Luo `top.sls`-tiedosto määrittämään, mitkä tilat ajetaan millekin minionille.
- Määritä `top.sls`:ssä esimerkiksi, että kaikki minionit (`'*'`) ajavat `hello`-tilan.
- Aja `top.sls`:n mukaiset tilat komennolla `sudo salt '*' state.apply` ilman erillistä tilan nimeämistä.

# Tehtävät

## a) Hello Vagrant! Osoita jollain komennolla, että Vagrant on asennettu (esim tulostaa vagrantin versionumeron). En ole vielä asentanut Vagranttia, joten raportoin myös asentamisen.

1.  Hain `vagrant windows 11`. Haun sivussa Wikipedia totesi, että se on HashiCorpin tekemä.
2.  Menin ensimmäiseen linkkiin: https://developer.hashicorp.com/vagrant/docs/installation
3.  Latasin `vagrant_2.4.3_windows_amd64.msi` version. 
    - ![Kuva Vagrantin lataussivusta](https://github.com/user-attachments/assets/7267acab-d7b5-4d8c-9cfe-dc4c8188a64d)
4.  Käynnistin tietokoneen uudelleen.
5.  Vagrant on asennettu.
    - ![Kuva komentokehotteesta, jossa näkyy Vagrantin versio](https://github.com/user-attachments/assets/7f05e3f8-466a-47ff-b86f-8f04b564ebfa)

## b) Linux Vagrant. Tee Vagrantilla uusi Linux-virtuaalikone.

1.  Tein Vagrantille uuden kansion.
2.  Navigoin kansioon cmd:ssä (aluksi oli ongelmia vaihtaa oikeaan levyasemaan, mutta se ratkesi `cd D:` käskyn sijaan ihan vain `D:` käskyllä).
3.  Käskyllä `vagrant init debian/bookworm64` sain tehtyä uuden konfiguraatiotiedoston. Tiedostoa ei tarvitse muokata.
4.  Käynnistin virtuaalikoneen asennuksen käskyllä `vagrant up`.
5.  Vagrant latasi Debian 12 boxin. (Tässä tapauksessa box tarkoittaa Vagrantille tarkoitettua levykuvaketta, missä on valmiiksi asennettu tarvittavia työkaluja Vagrantille.)

## c) Kaksin kaunihimpi. Tee kahden Linux-tietokoneen verkko Vagrantilla. Osoita, että koneet voivat pingata toisiaan.

1.  Hain opetusmateriaalista Vagrant-tiedoston: https://terokarvinen.com/2021/two-machine-virtual-network-with-debian-11-bullseye-and-vagrant/
2.  Laitoin sen cmd:llä navigoimaani lokaatioon.
3.  Käynnistin `vagrant up`.
4.  Asennuksen ja parin admin-oikeuksien jälkeen kirjauduin sisään toiseen virtuaalikoneista komennolla `vagrant ssh t001`. 
    - ![Kuva SSH-yhteydestä t001-koneeseen](https://github.com/user-attachments/assets/f7482c27-3658-4744-8236-e405f0c9f68d)
5.  Pingasin toista konetta (pingaus onnistui). 
    - ![Kuva onnistuneesta pingauksesta t001-koneesta t002-koneeseen](https://github.com/user-attachments/assets/08ae2a5d-2de8-434e-81ac-cd95de3bae0c)
6.  Kirjauduin ulos `exit`-komennolla.
7.  Kirjauduin toiseen koneeseen komennolla `vagrant ssh t002`.
8.  Pingasin ensimmäistä konetta komennolla `ping -c 1 192.168.88.101`.

## d) Herra-orja verkossa. Demonstroi Salt herra-orja arkkitehtuurin toimintaa kahden Linux-koneen verkossa, jonka teit Vagrantilla. Asenna toiselle koneelle salt-master, toiselle salt-minion. Laita orjan /etc/salt/minion -tiedostoon masterin osoite. Hyväksy avain ja osoita, että herra voi komentaa orjakonetta.
1. Kirjauduin ensin ensimmäiselle koneelle: vagrant ssh t001
2. sudo apt-get update ja sudo apt-get -qy install salt-master
     - E: Unable to locate package salt-master
         - ongelma oli loputon kuilu mitä en saanut ratkaistua. ainut tapa miten ratkaisin onghelman oli Gemini 2.5 Pro:n generoima Vagrant tiedosto joka asentaa asiat valmiiksi.
3. Valitettavien ongelmien takia voin vain todeta että masterin ja minionin asennus on tapahtunut oikein:
    - ![image](https://github.com/user-attachments/assets/ed25b6f4-f8ca-46bd-be45-b159d0987b73)
    - sudo salt-key -L näyttää että orja on hyväksyttyjen orjien listalla.
    - sudo salt '*' test.ping testaa yhteyttä kaikkiin orjiin. Tässä tapauksessa t002.
    - sudo salt 't002' cmd.run 'hostname -I' tulostaa orjalla IP osoitteet.

# Lähteet

- Karvinen 2021: Two Machine Virtual Network With Debian 11 Bullseye and Vagrant
- Karvinen 2018: Salt Quickstart – Salt Stack Master and Slave on Ubuntu Linux
- Karvinen 2023: Salt Vagrant - automatically provision one master and two slaves
- Karvinen: h2-soitto-kotiin https://terokarvinen.com/palvelinten-hallinta/#h2-soitto-kotiin
- HashiCorp - Vagrant installation https://developer.hashicorp.com/vagrant/docs/installation
- Gemini 2.5 Pro: Tehtävien teossa käytetty keskustelu - https://g.co/gemini/share/1871d0ad4291
- Karvinen 2018: Saltin asennus https://terokarvinen.com/2018/salt-quickstart-salt-stack-master-and-slave-on-ubuntu-linux/
