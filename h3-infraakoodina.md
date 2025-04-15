# Lue ja tiivistä
## Karvinen 2014: Hello Salt Infra-as-Code
- Artikkeli opastaa Salt minionin asentamisen ja "hello" nimisen moduulin tekemisen.
  - Moduuli toimii idempotenssina ja luo tiedoston vain kerran
  1. $ sudo mkdir -p /srv/salt/hello/
     - Luotiin kansio
  2. $ cd /srv/salt/hello/
     - Navigointiin kansioon
  3. $ sudoedit init.sls
     - Luo uuden sls tiedoston ja editoi sitä
     - Artikkeli ohjeistaa editorin käyttöön microa, sen saa käskyillä:
         - $ sudo apt-get -y install micro
         - $ export EDITOR=micro
  4. /tmp/hellotero:
      file.managed
     - Idempotenttia Salt koodia
  5. $ sudo salt-call --local state.apply hello
     - Käynnistetään koodi
## Salt contributors: Salt overview
### Rules of YAML

### YAML simple structure

### Lists and dictionaries - YAML block structures

# Lähteet
- Karvinen 2014: [Hello Salt Infra-as-Code](https://terokarvinen.com/2024/hello-salt-infra-as-code/)
- Salt contributors: [Salt overview](https://docs.saltproject.io/salt/user-guide/en/latest/topics/overview.html#rules-of-yaml)
- 
