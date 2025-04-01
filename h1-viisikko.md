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


# Tehtävät
## a) Asenna Debian 12-Bookworm virtuaalikoneeseen. 
Ei ollut ongelmia, tein sen jo ennen ensimmäistä tuntia.
## b) Asenna Salt (salt-minion) Linuxille (uuteen virtuaalikoneeseesi).

## c) Viisi tärkeintä. Näytä Linuxissa esimerkit viidestä tärkeimmästä Saltin tilafunktiosta: pkg, file, service, user, cmd. Analysoi ja selitä tulokset.

## d) Idempotentti. Anna esimerkki idempotenssista. Aja 'salt-call --local' komentoja, analysoi tulokset, selitä miten idempotenssi ilmenee.


# Lähteet
Karvinen 2023: https://terokarvinen.com/2021/salt-run-command-locally/ \
Karvinen 2018: https://terokarvinen.com/2018/03/28/salt-quickstart-salt-stack-master-and-slave-on-ubuntu-linux/ \
Karvinen 2006: https://terokarvinen.com/2006/06/04/raportin-kirjoittaminen-4/ \
WMWare Inc: https://docs.saltproject.io/salt/install-guide/en/latest/topics/install-by-operating-system/linux-deb.html
