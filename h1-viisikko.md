# Lue ja tiivistä
## Karvinen 2023: Run Salt Command Locally
- Saltilla ohjataan useampaa konetta, mutta tässä ohjeessa keskitytään lokaaliin harjoitteluun.
- Kerrataan kuinka pkg (paketit), file (tiedostot), service (palvelut/daemonit), user (käyttäjätunnukset) ja cmd (komentorivikomentoja) ovat tärkeimpiä tilafunktioita.
- Lokaalit komennot ovat muodossa sudo salt-call --local

## Karvinen 2018: Salt Quickstart – Salt Stack Master and Slave on Ubuntu Linux
- Salt Master kuuluu asentaa tietokoneelle jolla hallitaan orjia.
  - sudo apt-get update
  - sudo apt-get -y install salt-master
- Salt Slave asennetaan kaikille orjille joita halutaan hallita massoissa.
  - slave$ sudo apt-get update
  - slave$ sudo apt-get -y install salt-minion
- Orjien täytyy tietää missä osoitteessa master on ja orjien täytyy saada yksilöivä id.
  - _Mitäköhän tapahtuu jos kaksi orjaa käyttää samaa id:tä?_
- Orjat pitää hyväksyä masterilla
  - master$ sudo salt-key -A
  - _Tätäkin varmaan voisi automatisoida?_

## Karvinen 2006: Raportin kirjoittaminen
- Raporttia kuuluu kirjoittaa tehtävää tehdessä tuoreeltaan.
- Raportti kuuluu tehdä siistiksi ja helppolukuiseksi.
- Kerrotaan täsmällisesti mitä on tehty ja millä koneella.
- Ei missään nimessä saa plagioida ja lähteet kuuluu merkata.

## WMWare Inc: Salt Install Guide: Linux (DEB) (poimi vain olennainen osa)
- Asennettaessa Linux Debian käyttöjärjestelmälle ladataan Saltin avain /etc/apt/keyrings kansioon. Samalla asennetaan Saltin repo.
- Sitten asennetaan Master tai Slave riippuen onko tietokone master vai slave.
- Jotta Salt toimisi suoraan uudelleenkäynnistyksen yhteydessä tarvitaan lyhyt käsky järjestelmälle.
  - Esimerkiksi salt orjalle se olisi:
    - sudo systemctl enable salt-minion && sudo systemctl start salt-minion

# Tehtävät
## a) Asenna Debian 12-Bookworm virtuaalikoneeseen. 
Ei ollut ongelmia, tein sen jo ennen ensimmäistä tuntia.
## b) Asenna Salt (salt-minion) Linuxille (uuteen virtuaalikoneeseesi).
![image](https://github.com/user-attachments/assets/fca07dd1-1cf1-404f-aa7b-ac9dbcb3d30a)
- Jonka jälkeen salasanavahvistuksella lähti hakemaan tietoja.
- sudo apt-get -y install salt-minion
  - HUPS. Pitää asentaa se keyring juttu ensin.
![image](https://github.com/user-attachments/assets/800a7325-f037-42c0-b9a1-421ebb2d7caf) \
    - curl -fsSL https://packages.broadcom.com/artifactory/api/security/keypair/SaltProjectKey/public | sudo tee /etc/apt/keyrings/salt-archive-keyring.pgp
    - curl -fsSL https://github.com/saltstack/salt-install-guide/releases/latest/download/salt.sources | sudo tee /etc/apt/sources.list.d/salt.sources
- Yritin uudelleen sudo apt-get -y install salt-minion mutta sain saman ilmoituksen.
  - Unohdin laittaa sudo apt update ennen asennusta.
  - updaten jälkeen apt-get -y install salt-minion toimi.
![image](https://github.com/user-attachments/assets/6e70dfec-7cc6-45be-8c37-8c4a7830a0b6)


## c) Viisi tärkeintä. Näytä Linuxissa esimerkit viidestä tärkeimmästä Saltin tilafunktiosta: pkg, file, service, user, cmd. Analysoi ja selitä tulokset.
- pkg varmistetaan että tree paketti on asennettu:
  - sudo salt-call --local -l info state.single pkg.installed name=tree
    ![image](https://github.com/user-attachments/assets/f01e5725-42d2-4fb3-a1c8-e6c1084662e8)
- file (Gemini 2.5 pro:n idea) tarkistetaan että tiedosto /tmp/tervehdys.txt on olemassa ja sisältää tekstin "Hei Salt!".
  - sudo salt-call --local -l info state.single file.managed name=/tmp/tervehdys.txt contents='Hei Salt!'
    ![image](https://github.com/user-attachments/assets/47faf0fb-5f1e-4631-84dd-d703e0a25fee)
    - Komento loi uuden tekstitiedoston johon se kirjoitti Hei Salt!.
    - Ajoin komennon uudelleen ja nyt ohjelma sanoo että teksti on oikeassa paikassa.
      ![image](https://github.com/user-attachments/assets/4345ee11-719b-448c-9e15-384819a334da)
- service katsotaan onko cron palvelu käynnissä
  - sudo salt-call --local -l info state.single service.running name=cron enable=True
    - Vastauksena tuli että The service cron is already running.
- user testataan onko käyttäjä seba olemassa
  - sudo salt-call --local -l info state.single user.present name=seba
    ![image](https://github.com/user-attachments/assets/ce07d670-ee1f-4146-93a1-7f00f94b11d1)
- cmd luodaan tiedosto touch komennolla
  - sudo salt-call --local -l info state.single cmd.run name='touch /tmp/cmd_luotu.txt'
    ![image](https://github.com/user-attachments/assets/d5690205-8e2b-4185-ba00-3218ff2ecf74)
    - Ongelma tässä komennossa on se, että se joka kerta luo saman tekstin uudelleen. Se ei ole koskaan havaittu jo luoduksi. Seuraava tehtävä korjaa sen.

## d) Idempotentti. Anna esimerkki idempotenssista. Aja 'salt-call --local' komentoja, analysoi tulokset, selitä miten idempotenssi ilmenee.
- Indempotentti komento tarkoittaa että komennon voi ajaa monta kertaa peräkkäin ilman että se tekee muutoksia ensimmäisen käskyn jälkeen. Eli se ei tee samaa käskyä uudelleen ja uudelleen, vaan toteaa että se on jo tehty.
- Edellisen tehtävän touch komento saadaan idempotentiksi lisäämällä loppuun creates='/tmp/cmd_luotu.txt'
  - sudo salt-call --local -l info state.single cmd.run name='touch /tmp/cmd_luotu.txt' creates='/tmp/cmd_luotu.txt'
    ![image](https://github.com/user-attachments/assets/df7cf66c-b252-4ed2-aa5b-b57bff0e4d38)
    - creates tarkistaa että onko tiedostoa jo olemassa, jos tiedosto on jo olemassa niin se ei tee suoritettua käskyä.
      - Tavallaan niinkuin IF lauseke mutta käskyn lopussa.


# Lähteet
Karvinen 2023: https://terokarvinen.com/2021/salt-run-command-locally/ \
Karvinen 2018: https://terokarvinen.com/2018/03/28/salt-quickstart-salt-stack-master-and-slave-on-ubuntu-linux/ \
Karvinen 2006: https://terokarvinen.com/2006/06/04/raportin-kirjoittaminen-4/ \
WMWare Inc: https://docs.saltproject.io/salt/install-guide/en/latest/topics/install-by-operating-system/linux-deb.html
