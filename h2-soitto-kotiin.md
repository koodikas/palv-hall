# Lue ja tiivistä
## Karvinen 2021: Two Machine Virtual Network With Debian 11 Bullseye and Vagrant
- Vagrantilla voi luoda nopeasti kahden koneen virtuaaliverkon Debian käyttöjärjestelmällä.
- Se automatisoi VirtualBox-koneiden pystyttämisen ja SSH-kirjautumisen ilman graafista käyttöliittymää.
- Asennus on helppoa Debianilla ja Ubuntulla (`apt-get`) tai lataamalla asennusohjelmat Macille ja Windowsille.
- `Vagrantfile`-tiedosto määrittää verkon asetukset (kaksi konetta, IP-osoitteet, jaetut kansiot).
- Koneisiin voi kirjautua SSH:lla (`vagrant ssh <koneen_nimi>`), ja ne voivat kommunikoida keskenään sekä Internetin kanssa.
- Koneet on helppo tuhota (`vagrant destroy`) ja luoda uudelleen (`vagrant up`) harjoittelua varten.
- Ohje sisältää myös vianetsintävinkkejä yleisiin ongelmiin, kuten IP-osoitteiden sallittuihin alueisiin liittyen.
