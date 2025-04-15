# Lue ja tiivistä
## Karvinen 2014: Hello Salt Infra-as-Code
- Artikkeli opastaa Salt minionin asentamisen ja `hello` nimisen moduulin tekemisen.
  - Moduuli toimii idempotenssina ja luo tiedoston vain kerran
  1. `sudo mkdir -p /srv/salt/hello/`
     - `-p` luo myös yläkansiot jos niitä ei ennestään ollut.
  2. `cd /srv/salt/hello/`
     - Navigointiin kansioon mistä Salt käynnistää tehtyjä state tiedostoja
  3. `sudoedit init.sls`
     - Luo uuden sls tiedoston ja editoi sitä
     - `init.sls` on oletusarvoinen nimi tilatiedostolle.
     - `sudoedit` on turvallisempi tapa editoida kuin `sudo nano init.sls`
     - Salt käyttää 
     - Artikkeli ohjeistaa editorin käyttöön microa, sen saa käskyillä:
         - `sudo apt-get -y install micro`
         - `export EDITOR=micro`
  4. ```
     /tmp/hellotero:
       file.managed
     ```
     - Idempotenttia Salt koodia
  5. `sudo salt-call --local state.apply hello`
     - Käynnistetään koodi Saltin kansiosta
## Salt contributors: Salt overview
### Rules of YAML
YAML on Saltin oletusmuotoilu
- Rakenne on: key: value -pareina
- Avaimen ja arvon erottimena toimii kaksoispiste ja välilyönti.
- Avaimet ovat kirjainkoossta riippuvaisia.
- Sisentämisessä saa käyttää ainoastaan välilyöntejä, tabulaattoria ei tunnisteta.
- Kommentit ovat aina # -merkillä
### YAML simple structure
Kolme perusrakennetta:
1. Skalaarit: Yksinkertaiset key: value -parit, joissa arvo voi olla numero, teksti tai totuusarvo
2. Listat: Avaina jota seuraa lista arvoja. Jokainen arvo on omalla rivillään sisennettynä kahdella välilyönnillä ja on listattu ranksalaisin viivoin.
3. Sanakirjat: Kokoelma key: value -pareja ja listoja, jotka voivat sisältää myös sisäkkäisiä rakenteita.
   - Esimerkiksi lista ruuista jotka sisältävät listat ainesosista.
### Lists and dictionaries - YAML block structures
YAML järjestyy lohkorakenteisiin.
- Sisentäminen määrittää rakenteen ja kontekstin. Kaksi välilyöntiä on standarin mukaista, mutta niitä saa olla enemmän.
- Listojen alkiot merkitään ranskalaisin viivoin (välilyönti välissä) omilla sisennetyillä riveillään.
# Tehtävät
## a) Hei infrakoodi! Kokeile paikallisesti (esim 'sudo salt-call --local') infraa koodina. Kirjota sls-tiedosto, joka tekee esimerkkitiedoston /tmp/ -kansioon.
- Aloitin edellisen tehtävän valmiiksi asetetulla master (t001) ja minioni (t002) koneilla.
  1. Kirjauduin sisään masteriin
      - `vagrant ssh t001`
  2. Loin saltin hakemiston alle `hello` -kansion (ja samalla saltin hakemiston jos sitä ei ollut [`-p` komennolla])
      - `sudo mkdir -p /srv/salt/hello`
  3. Ennen tekstieditointia vaihdan editoria.
      - `sudo apt-get -y install micro`
      - `export EDITOR=micro`
  4. Navigoidaan uuteen kansioon
      - `cd /srv/salt/hello`
  5. Luodaan ja editoidaan uusi tiedosto
      - `sudoedit init.sls`
        - Kirjoitetaan sinne:
          ```
          /tmp/helloseba:
            file.managed
          ```
        - `CTRL + Q` ja `y` tallentaaksesi ja poistuaksesi tiedostosta.
  6. Paikallisesti testataan
     - `sudo salt-call --local state.apply hello`
     - ![image](https://github.com/user-attachments/assets/2529bbf4-3c05-4597-a509-c3a3d06663aa)
     - Uudelleen juoksutettuna varmistuu että koodi oli idempotenssi, muutoksia ei tehty
     - ![image](https://github.com/user-attachments/assets/df38f933-6ed5-4b44-8dc9-c4a839bfb063)

## b) Aja esimerkki sls-tiedostosi verkon yli orjalla.
- `sudo salt 't002' state.apply hello`
- ![image](https://github.com/user-attachments/assets/67fefc10-61c4-4a36-be9f-09679c9fa428)
- ![image](https://github.com/user-attachments/assets/5ab8081e-c6b1-4a86-9474-dde551015230)


## c) Tee sls-tiedosto, joka käyttää vähintään kahta eri tilafunktiota näistä: package, file, service, user. Tarkista eri ohjelmalla, että lopputulos on oikea. Osoita useammalla ajolla, että sls-tiedostosi on idempotentti.
- Aluksi varmuudenvuoksi `cd ~`
1. `sudo mkdir -p /srv/salt/testing`
2. `cd /srv/salt/testing`
3. `sudoedit init.sls`
   ```
   pkg.installed:
     - name: micro
   user.present:
     - name: testing
   ```
   `CTRL + Q` ja `y`
4. sudo salt 't002' state.apply testing
   - ![image](https://github.com/user-attachments/assets/1dfff0ac-905b-4109-a483-be7483b53bc0)
     - Hups, pitäisi varmaan tehdä sanakirjana koko homma, kokeillaan uudelleen hieman eritavoin.
     ```
     is_micro_installed:
       pkg.installed:
         - name: micro
     create_user_testing:
       user.present:
         - name: testing
     ```
     - Nyt uudelleen `sudo salt 't002' state.apply testing`
         - microsta tuli pitkä lista eri pieniä paketteja, ei mahdu kuvaan 😁
         - ![image](https://github.com/user-attachments/assets/e667f486-9c50-4f09-b4aa-f259c215126b)
         - käyttäjällä näkyy paljon mielenkiintoisia asetuksia, niitäkin olisi voinut asettaa itse:
         - ![image](https://github.com/user-attachments/assets/b5adb9a9-40a2-47a1-a827-ac7d151200d0)
5. Uudelleen juoksutettuna ohjelma totesi että paketit ja käyttäjä ovat jo läsnä:
     ![image](https://github.com/user-attachments/assets/166f09ae-7dcd-4373-a2a4-1c1fa3964f3f)
6. `t002` koneelle kirjautumineen
   - `exit` ja `vagrant ssh t002`
   - `cd ..` ja sitten katsotaan onko kansio tullut `ls`
   - ![image](https://github.com/user-attachments/assets/e9777f2e-250c-492c-bd08-caadcf912b9c)




# Lähteet
- Karvinen 2014: [Hello Salt Infra-as-Code](https://terokarvinen.com/2024/hello-salt-infra-as-code/)
- Salt contributors: [Salt overview](https://docs.saltproject.io/salt/user-guide/en/latest/topics/overview.html#rules-of-yaml)
- Tehtävienanto ja vihjeet: https://terokarvinen.com/palvelinten-hallinta/#h3-infraa-koodina
- Gemini 2.5 Pro (experimental)
  - kääntämisessä englannista suomeksi
  - avaamaan komentojen merkintöjä `-p` `-y` jne.
