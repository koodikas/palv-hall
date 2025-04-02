# Lue ja tiivistä

## Karvinen 2023: Run Salt Command Locally

* Saltilla ohjataan useampaa konetta, mutta tässä ohjeessa keskitytään lokaaliin harjoitteluun.
* Kerrataan kuinka `pkg` (paketit), `file` (tiedostot), `service` (palvelut/daemonit), `user` (käyttäjätunnukset) ja `cmd` (komentorivikomentoja) ovat tärkeimpiä tilafunktioita.
* Lokaalit komennot ovat muodossa `sudo salt-call --local`.

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

## Karvinen 2006: Raportin kirjoittaminen

* Raporttia kuuluu kirjoittaa tehtävää tehdessä tuoreeltaan.
* Raportti kuuluu tehdä siistiksi ja helppolukuiseksi.
* Kerrotaan täsmällisesti mitä on tehty ja millä koneella.
* Ei missään nimessä saa plagioida ja lähteet kuuluu merkitä.

## VMware Inc: Salt Install Guide: Linux (DEB) (Olennaiset osat)

* Asennettaessa Debian/Ubuntu-pohjaiselle Linuxille:
    1.  Ladataan Saltin GPG-avain `/etc/apt/keyrings`-kansioon.
    2.  Lisätään Saltin pakettilähde (repository).
    3.  Päivitetään pakettilistat (`sudo apt update`).
    4.  Asennetaan `salt-master`, `salt-minion` tai molemmat (`sudo apt install salt-minion`).
* Jotta Salt-palvelu (esim. minion) käynnistyy automaattisesti uudelleenkäynnistyksen yhteydessä:
    ```bash
    sudo systemctl enable salt-minion && sudo systemctl start salt-minion
    ```

# Tehtävät

## a) Asenna Debian 12-Bookworm virtuaalikoneeseen.

Ei ollut ongelmia, tein sen jo ennen ensimmäistä tuntia.

## b) Asenna Salt (salt-minion) Linuxille (uuteen virtuaalikoneeseesi).

1.  **Yritin ensin asentaa suoraan:**
    ```bash
    sudo apt-get -y install salt-minion
    ```
    * **HUPS!** Piti asentaa avain ja pakettilähde ensin.
    ![Kuva yrityksestä asentaa ilman avainta](https://github.com/user-attachments/assets/fca07dd1-1cf1-404f-aa7b-ac9dbcb3d30a)

2.  **Avaimen ja pakettilähteen lisäys:**
    ```bash
    curl -fsSL [https://packages.broadcom.com/artifactory/api/security/keypair/SaltProjectKey/public](https://packages.broadcom.com/artifactory/api/security/keypair/SaltProjectKey/public) | sudo tee /etc/apt/keyrings/salt-archive-keyring.pgp
    curl -fsSL [https://github.com/saltstack/salt-install-guide/releases/latest/download/salt.sources](https://github.com/saltstack/salt-install-guide/releases/latest/download/salt.sources) | sudo tee /etc/apt/sources.list.d/salt.sources
    ```
    ![Kuva avaimen ja lähteen lisäyksestä](https://github.com/user-attachments/assets/800a7325-f037-42c0-b9a1-421ebb2d7caf)

3.  **Yritin uudelleen asennusta:** `sudo apt-get -y install salt-minion`
    * Sain saman ilmoituksen. Unohdin `sudo apt update`.

4.  **Päivitys ja onnistunut asennus:**
    ```bash
    sudo apt update
    sudo apt-get -y install salt-minion
    ```
    ![Kuva onnistuneesta asennuksesta](https://github.com/user-attachments/assets/6e70dfec-7cc6-45be-8c37-8c4a7830a0b6)

## c) Viisi tärkeintä. Näytä Linuxissa esimerkit viidestä tärkeimmästä Saltin tilafunktiosta: pkg, file, service, user, cmd. Analysoi ja selitä tulokset.

* **`pkg`**: Varmistetaan, että `tree`-paketti on asennettu.
    ```bash
    sudo salt-call --local -l info state.single pkg.installed name=tree
    ```
    ![Kuva pkg.installed tulosteesta](https://github.com/user-attachments/assets/f01e5725-42d2-4fb3-a1c8-e6c1084662e8)
    * **Analyysi:** Komento tarkistaa, onko paketti `tree` asennettu. Jos ei ole, se asentaa sen. Jos on, se ilmoittaa paketin olevan jo asennettu. Tulos osoittaa, että `tree` asennettiin tai oli jo asennettuna.

* **`file`**: Varmistetaan, että tiedosto `/tmp/tervehdys.txt` on olemassa ja sisältää tekstin "Hei Salt!".
    ```bash
    sudo salt-call --local -l info state.single file.managed name=/tmp/tervehdys.txt contents='Hei Salt!'
    ```
    ![Kuva file.managed ensimmäisestä ajosta](https://github.com/user-attachments/assets/47faf0fb-5f1e-4631-84dd-d703e0a25fee)
    * **Analyysi (1. ajo):** Komento loi tiedoston `/tmp/tervehdys.txt` ja kirjoitti siihen määritellyn sisällön. Tulos näyttää muutokset (`diff`).
    * **Uudelleenajo:**
    ![Kuva file.managed toisesta ajosta](https://github.com/user-attachments/assets/4345ee11-719b-448c-9e15-384819a334da)
    * **Analyysi (2. ajo):** Komento tarkisti tiedoston ja sen sisällön. Koska ne vastasivat määriteltyä tilaa, muutoksia ei tehty, ja tulos ilmoittaa tiedoston olevan oikeassa tilassa.

* **`service`**: Katsotaan, onko `cron`-palvelu käynnissä ja asetettu käynnistymään automaattisesti.
    ```bash
    sudo salt-call --local -l info state.single service.running name=cron enable=True
    ```
    * **Analyysi:** Komento tarkistaa `cron`-palvelun tilan. Tulos "The service cron is already running" kertoo, että palvelu oli jo käynnissä. `enable=True` varmistaa myös, että se on asetettu käynnistymään järjestelmän mukana.

* **`user`**: Testataan, onko käyttäjä `seba` olemassa.
    ```bash
    sudo salt-call --local -l info state.single user.present name=seba
    ```
    ![Kuva user.present tulosteesta](https://github.com/user-attachments/assets/ce07d670-ee1f-4146-93a1-7f00f94b11d1)
    * **Analyysi:** Komento tarkistaa käyttäjän `seba` olemassaolon. Jos käyttäjää ei ole, se luodaan. Tulos näyttää, että käyttäjä luotiin (tai oli jo olemassa).

* **`cmd`**: Luodaan tiedosto `touch`-komennolla.
    ```bash
    sudo salt-call --local -l info state.single cmd.run name='touch /tmp/cmd_luotu.txt'
    ```
    ![Kuva cmd.run tulosteesta](https://github.com/user-attachments/assets/d5690205-8e2b-4185-ba00-3218ff2ecf74)
    * **Analyysi:** Komento suorittaa annetun shell-komennon (`touch /tmp/cmd_luotu.txt`). Ongelmana on, että `cmd.run` suorittaa komennon *joka kerta*, riippumatta siitä, onko tiedosto jo olemassa. Se ei siis oletuksena ole idempotentti.

## d) Idempotentti. Anna esimerkki idempotenssista. Aja 'salt-call --local' komentoja, analysoi tulokset, selitä miten idempotenssi ilmenee.

* **Idempotenssi** tarkoittaa, että komennon voi suorittaa useita kertoja peräkkäin, mutta se aiheuttaa muutoksen vain ensimmäisellä kerralla (jos tila ei vastaa haluttua). Seuraavilla suorituskerroilla komento toteaa tilan olevan jo kunnossa eikä tee mitään.

* **Esimerkki:** Tehdään edellisen kohdan `cmd.run`-komennosta idempotentti käyttämällä `creates`-argumenttia.
    ```bash
    sudo salt-call --local -l info state.single cmd.run name='touch /tmp/cmd_luotu.txt' creates='/tmp/cmd_luotu.txt'
    ```
    ![Kuva idempotentista cmd.run-komennosta](https://github.com/user-attachments/assets/df7cf66c-b252-4ed2-aa5b-b57bff0e4d38)
    * **Analyysi:**
        * **Ensimmäinen ajo:** Koska tiedostoa `/tmp/cmd_luotu.txt` ei ole olemassa, `creates`-ehto ei täyty, ja `touch`-komento suoritetaan. Tulos näyttää muutoksen.
        * **Toinen ajo (ja seuraavat):** Nyt tiedosto `/tmp/cmd_luotu.txt` on olemassa. `creates`-argumentti havaitsee tämän, ja `touch`-komentoa *ei* suoriteta. Tulos ilmoittaa, että komentoa ei ajettu, koska `creates`-tiedosto löytyi.
    * **Miten idempotenssi ilmenee:** `creates`-argumentti lisää ehtotarkistuksen, joka tekee `cmd.run`-tilasta idempotenttisen. Komento suoritetaan vain, jos määritelty tiedosto *ei* ole olemassa. Useimmat Saltin tilat (kuten `pkg.installed`, `file.managed`, `service.running`, `user.present`) ovat oletuksena idempotentteja.

# Lähteet

* Karvinen 2023: [Run Salt Command Locally](https://terokarvinen.com/2021/salt-run-command-locally/)
* Karvinen 2018: [Salt Quickstart – Salt Stack Master and Slave on Ubuntu Linux](https://terokarvinen.com/2018/03/28/salt-quickstart-salt-stack-master-and-slave-on-ubuntu-linux/)
* Karvinen 2006: [Raportin kirjoittaminen](https://terokarvinen.com/2006/06/04/raportin-kirjoittaminen-4/)
* VMware Inc: [Salt Install Guide: Linux (DEB)](https://docs.saltproject.io/salt/install-guide/en/latest/topics/install-by-operating-system/linux-deb.html)
