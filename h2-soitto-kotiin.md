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
Tein Vagrantille uuden kansion ja navigoin sinne cmd:ssä (aluksi oli ongelmia vaihtaa oikeaan levyasemaan, mutta se ratkesi cd D: käskyn sijaan ihan vain D: käskyllä). Käskyllä vagrant init debian/bookworm64 sain tehtyä uuden configuraatio tiedoston. Tiedostoa ei tarvitse muokata. Käynnistetään virtuaalikoneen asennus käskyllä vagrant up. Vagrant latasi debian 12 boxin. Tässä tapauksessa box tarkoittaa Vagrantille tarkoitettua levykuvaketta, missä on valmiiksi asennettu tarvittavia työkaluja Vagrantille.
## c) Kaksin kaunihimpi. Tee kahden Linux-tietokoneen verkko Vagrantilla. Osoita, että koneet voivat pingata toisiaan.
Aloitin hakemalla opetusmateriaalista Vagrant tiedoston https://terokarvinen.com/2021/two-machine-virtual-network-with-debian-11-bullseye-and-vagrant/ ja laitoin sen cmd:llä navigoimaani lokaatioon. Siellä käynnistin vagrant up. Asennuksen ja parin admin oikeuksien jälkeen pystyn kirjautumaan sisään toiseen virtuaalikoneista vagrant ssh t001. ![image](https://github.com/user-attachments/assets/f7482c27-3658-4744-8236-e405f0c9f68d)
Pingaus toiseen koneeseen kävi helposti. ![image](https://github.com/user-attachments/assets/08ae2a5d-2de8-434e-81ac-cd95de3bae0c)
exit komennolla menin pois ja kirjauduin toiseen koneeseen vagrant ssh t002 ja pingasin ensimmäistä konetta ping -c 1 192.168.88.101.
## d) Herra-orja verkossa. Demonstroi Salt herra-orja arkkitehtuurin toimintaa kahden Linux-koneen verkossa, jonka teit Vagrantilla. Asenna toiselle koneelle salt-master, toiselle salt-minion. Laita orjan /etc/salt/minion -tiedostoon masterin osoite. Hyväksy avain ja osoita, että herra voi komentaa orjakonetta.



# Lähteet
Karvinen 2021: Two Machine Virtual Network With Debian 11 Bullseye and Vagrant
Karvinen 2018: Salt Quickstart – Salt Stack Master and Slave on Ubuntu Linux 
Karvinen 2023: Salt Vagrant - automatically provision one master and two slaves
Karvinen: h2-soitto-kotiin https://terokarvinen.com/palvelinten-hallinta/#h2-soitto-kotiin
HashiCorp - Vagrant installation https://developer.hashicorp.com/vagrant/docs/installation
Gemini 2.5 Pro: Tehtävien teossa käytetty keskustelu - https://g.co/gemini/share/1871d0ad4291
Karvinen 2018: Saltin asennus https://terokarvinen.com/2018/salt-quickstart-salt-stack-master-and-slave-on-ubuntu-linux/
