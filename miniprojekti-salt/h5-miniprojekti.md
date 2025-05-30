# h5 Miniprojekti: Automaattinen Apache-asennus Saltilla

Tässä miniprojektissa käytin vanhaa Vagrantilla tehtyä kahden virtuaalikoneen ympäristöä (Salt Master [t001] ja Salt Minion [t002]) ja käytin SaltStackia asentamaan ja konfiguroimaan Apache-verkkopalvelimen automaattisesti Minion-koneeseen. Projekti hyödyntää keskitettyä hallintaa, infraa koodina ja idempotenssia Saltin avulla.

### Projektin alustus ja hakemistorakenne

1.  **Tee projektihakemisto:**
    ```bash
    mkdir miniprojekti-salt
    cd miniprojekti-salt
    ```
2.  **Tee Salt State -hakemistot:** Salt etsii oletuksena tilatiedostoja `/srv/salt`-kansiosta Master-koneella. Vagrant synkronoi host-koneen hakemistoja virtuaalikoneeseen. Loin vastaavan rakenteen host-koneelle, jonka Vagrant synkronoi Masterille.
    ```bash
    # Tee pääkansio Salt-tiloille
    srv/salt
    # Tee alikansio apache-tilalle
    srv/salt/apache
    # Tee alikansio apache-tilaan liittyville tiedostoille (esim. index.html)
    srv/salt/apache/files
    # (Valinnainen) Luo kansio jaettaville tiedostoille Vagrantin kautta
    mkdir shared
    ```
    * **Analyysi:** Hakemistorakenne `srv/salt` host-koneella kopioidaan Master-koneen `/vagrant/srv/salt`-hakemistoon (Vagrantfile määrittää tämän). `apache`-alikansio sisältää Apacheen liittyvät Salt-tilat ja `files`-alikansio tiedostot, joita tila käyttää (`index.html`).

### Vagrantfile: Virtuaalikoneet ja provisiointi

1.  **Tee `Vagrantfile`:** Luo `miniprojekti-salt`-hakemiston juureen `Vagrantfile`-niminen tiedosto seuraavalla sisällöllä:

    ```ruby
    # -*- mode: ruby -*-
    # vi: set ft=ruby :

    $master_script = <<MASTER_SCRIPT
    echo "--- Provisioning Salt Master on t001 ---"
    set -e
    set -o verbose
    echo "Applying temporary DNS fix..."
    echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null
    echo "nameserver 1.1.1.1" | sudo tee -a /etc/resolv.conf > /dev/null
    echo "Updating package lists after DNS fix..."
    sudo apt-get update -y
    echo "Ensuring curl is installed..."
    sudo apt-get install -y curl
    echo "Installing Salt Master via bootstrap (piped from GitHub)..."
    curl -LfsS https://github.com/saltstack/salt-bootstrap/releases/latest/download/bootstrap-salt.sh | sudo sh -s -- -M -A 192.168.88.101

    echo "Configuring auto-accept and file_roots..."
    sudo mkdir -p /etc/salt/master.d
    echo "auto_accept: True" | sudo tee /etc/salt/master.d/auto-accept.conf > /dev/null
    echo "file_roots:" | sudo tee /etc/salt/master.d/roots.conf > /dev/null
    echo "  base:" | sudo tee -a /etc/salt/master.d/roots.conf > /dev/null
    echo "    - /vagrant/srv/salt" | sudo tee -a /etc/salt/master.d/roots.conf > /dev/null
    echo "Restarting salt-master service..."
    sudo systemctl enable salt-master
    sudo systemctl restart salt-master
    echo "--- Salt Master provisioning complete on t001 ---"
    MASTER_SCRIPT

    $minion_script = <<MINION_SCRIPT
    echo "--- Provisioning Salt Minion on t002 ---"
    set -e
    set -o verbose
    echo "Applying temporary DNS fix..."
    echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null
    echo "nameserver 1.1.1.1" | sudo tee -a /etc/resolv.conf > /dev/null
    echo "Updating package lists after DNS fix..."
    sudo apt-get update -y
    echo "Ensuring curl is installed..."
    sudo apt-get install -y curl
    echo "Installing Salt Minion via bootstrap (piped from GitHub)..."
    curl -LfsS https://github.com/saltstack/salt-bootstrap/releases/latest/download/bootstrap-salt.sh | sudo sh -s -- -A 192.168.88.101

    echo "Configuring master address explicitly..."
    sudo mkdir -p /etc/salt/minion.d
    echo "master: 192.168.88.101" | sudo tee /etc/salt/minion.d/master.conf > /dev/null
    echo "Restarting salt-minion service..."
    sudo systemctl enable salt-minion
    sudo systemctl restart salt-minion
    echo "--- Salt Minion provisioning complete on t002 ---"
    MINION_SCRIPT

    Vagrant.configure("2") do |config|
      config.vm.box = "debian/bullseye64"

      config.vm.synced_folder "shared/", "/home/vagrant/shared", create: true

      config.vm.define "t001" do |t001|
        t001.vm.hostname = "t001"
        t001.vm.network "private_network", ip: "192.168.88.101"

        t001.vm.provider "virtualbox" do |vb|
          vb.memory = "2048"
          vb.name = "salt-master-t001"
        end

        t001.vm.provision "shell", inline: $master_script
      end

      config.vm.define "t002" do |t002|
        t002.vm.hostname = "t002"
        t002.vm.network "private_network", ip: "192.168.88.102"
        t002.vm.network "forwarded_port", guest: 80, host: 8080

        t002.vm.provider "virtualbox" do |vb|
          vb.memory = "1024"
          vb.name = "salt-minion-t002"
        end

        t002.vm.provision "shell", inline: $minion_script
      end
    end
    ```
    * **Analyysi:**
        * Määrittää kaksi Debian 11 -konetta: `t001` (Master, IP 192.168.88.101) ja `t002` (Minion, IP 192.168.88.102).
        * Käyttää `$master_script` ja `$minion_script` -muuttujia Saltin asentamiseen `shell`-provisioijalla.
        * Synkronoi oletuksena host-koneen projektihakemiston (`.`) Masterin `/vagrant`-hakemistoon, jolloin `srv/salt` on saatavilla Masterilla polussa `/vagrant/srv/salt`. Lisäksi `shared`-kansio synkronoidaan.
        * Määrittää porttiohjauksen Minionille (`t002`): hostin portti 8080 -> Minionin portti 80.
        * Antaa koneille nimet VirtualBoxissa (`vb.name`) ja säätää muistia (`vb.memory`).
        * Salt state -ajo (`state.highstate`) tehdään manuaalisesti `vagrant up` -komennon jälkeen.

### Salt Top File (`top.sls`)

1.  **Tee `srv/salt/top.sls`:** Luo tiedosto seuraavalla sisällöllä:

    ```yaml
    # /srv/salt/top.sls
    # Määrittää, että base-ympäristössä kaikille minioneille ('*')
    # ajetaan 'apache'-tila.
    base:
      '*':
        - apache
    ```
    * **Analyysi:** Tämä tiedosto ohjaa Salt Masteria ajamaan `apache`-nimisen tilan (joka löytyy `srv/salt/apache/init.sls`) kaikilla minioneilla, jotka ottavat yhteyttä.

### Salt State Apachelle (`apache/init.sls`)

1.  **Tee `srv/salt/apache/init.sls`:** Luo tiedosto seuraavalla sisällöllä:

    ```yaml
    # /srv/salt/apache/init.sls
    # Salt State Apache-verkkopalvelimen asennukseen ja konfigurointiin.

    # 1. Varmista paketin asennus (pkg)
    apache2_package:
      pkg.installed:
        - name: apache2

    # 2. Hallinnoi konfiguraatiotiedostoa (file) - tässä tapauksessa index.html
    apache_index_page:
      file.managed:
        - name: /var/www/html/index.html
        - source: salt://apache/files/index.html # Haetaan tiedosto masterilta
        - user: root
        - group: root
        - mode: '0644'
        - require: # Varmistetaan, että paketti on asennettu ensin
          - pkg: apache2_package

    # 3. Varmista palvelun tila (service)
    apache2_service:
      service.running:
        - name: apache2
        - enable: True # Varmistaa, että palvelu käynnistyy bootissa
        - watch: # Seuraa muutoksia index.html-tiedostossa
          - file: apache_index_page
    ```
    * **Analyysi:**
        * Toteuttaa Pkg-File-Service -mallin Apachelle.
        * `pkg.installed` varmistaa `apache2`-paketin.
        * `file.managed` hallinnoi `/var/www/html/index.html` ja hakee sen sisällön Masterilta `salt://`-polun kautta. `require` varmistaa oikean suoritusjärjestyksen.
        * `service.running` varmistaa, että `apache2`-palvelu on käynnissä ja `enabled`. `watch` käynnistää palvelun uudelleen, jos `index.html` muuttuu. Kaikki tilat ovat idempotentteja.

### Index.html - Apache-testisivu

1.  **Tee `srv/salt/apache/files/index.html`:** Luo tiedosto seuraavalla sisällöllä:

    ```html
    <!DOCTYPE html>
    <html lang="fi">
    <head>
        <meta charset="UTF-8">
        <title>Salt Miniprojekti</title>
        <style>
            body { font-family: sans-serif; background-color: #f0f0f0; text-align: center; padding-top: 50px; }
            h1 { color: #333; }
            p { color: #555; }
            .salt-logo { color: #00a9e0; font-weight: bold; } /* Saltin sininen väri */
        </style>
    </head>
    <body>
        <h1>Tervetuloa!</h1>
        <p>Tämä Apache-palvelin on konfiguroitu automaattisesti <span class="salt-logo">SaltStackilla</span> Vagrantin kautta.</p>
        <p>Infra koodina toimii!</p>
    </body>
    </html>
    ```
    * **Analyysi:** Yksinkertainen HTML-sivu, joka toimii Apache-palvelimen testisivuna. `file.managed`-tila kopioi tämän Minionille.

### Projektin ajaminen

1.  **Käynnistä Vagrant-ympäristö:** Siirry komentorivillä `miniprojekti-salt`-hakemistoon ja aja komento:
    ```bash
    vagrant up
    ```
    * **Ohje:** Komento käynnistää ja provisioi molemmat virtuaalikoneet (`t001`, `t002`) `Vagrantfile`:n mukaisesti. Salt asennetaan ja peruskonfiguroidaan, mutta Apache-tilaa ei vielä ajeta automaattisesti. Odota, kunnes molemmat koneet ovat valmiita.

2.  **Aja Salt State manuaalisesti:** Kun `vagrant up` on valmis, kirjaudu sisään Master-koneeseen (`t001`) ja aja `state.highstate`-komento levittääksesi konfiguraation Minionille (`t002`):
    ```bash
    vagrant ssh t001
    ```
    Kun olet kirjautunut Master-koneeseen (`t001`):
    ```bash
    # Ajaa top.sls:n mukaiset tilat kaikille hyväksytyille minioneille
    sudo salt '*' state.highstate
    ```
    Kirjaudu ulos Masterilta:
    ```bash
    exit
    ```
    * ![image](https://github.com/user-attachments/assets/42a3f125-178b-4207-983c-9be8e4c0cb0d)
    * **Analyysi:** `state.highstate` (tai `state.apply apache`) komento Masterilla saa aikaan sen, että Master lähettää `apache`-tilan Minionille, joka suorittaa sen: asentaa Apachen, kopioi `index.html`:n ja käynnistää palvelun.


### Tulosten tarkistus

1.  **Selaimella:** avasin tietokoneellani verkkoselaimen ja siirryin osoitteeseen `http://localhost:8080`.
    * **Odotettu tulos:** Näen luomani `index.html`-sivun sisällön.
    * ![image](https://github.com/user-attachments/assets/4acf9ff1-6076-4c3a-b7e6-a0966a5f2c2f)
    * Toimii.

2.  **Masterilta käsin (Idempotenssi):**
    * Kirjauduin sisään Master-koneeseen:
        ```bash
        vagrant ssh t001
        ```
    * Testasin yhteyden Minioniin:
        ```bash
        sudo salt '*' test.ping
        ```
        * **Odotettu tulos:** `t002: True`
        * ![image](https://github.com/user-attachments/assets/0a5ce440-8e5d-4c96-948d-a9f40a095119)
        * Toimii

    * Ajoin Apache-tila uudelleen:
        ```bash
        sudo salt 't002' state.apply apache
        ```
        * **Odotettu tulos:** Komennon tuloste näyttää, että kaikki on jo kunnossa (esim. `Result: True`, `Comment: Package apache2 is already installed.`, `Changes: {}`). Tämä osoittaa idempotenssin.
        * ![image](https://github.com/user-attachments/assets/c66c4898-a3cf-432f-a7c6-f9c98c90961c)
        * Kaikki toimii odotetusti.

    * Kirjauduin ulos Masterilta:
        ```bash
        exit
        ```

### Siivous
1.  **Sammuta virtuaalikoneet:** Kun et enää tarvitse ympäristöä:
    ```bash
    vagrant halt
    ```
2.  **Tuhoa virtuaalikoneet:** Poista koneet ja niiden levytiedostot pysyvästi:
    ```bash
    vagrant destroy -f
    ```
    * **Analyysi:** `vagrant halt` sammuttaa koneet. `vagrant destroy -f` poistaa ne kokonaan.

## Lähteet
* Aiemmat harjoitukset (h1-h4) ja niiden lähteet.
* Tämän dokumentin pohjana käytetyt tiedostot:
    * `Vagrantfile`
    * `srv/salt/top.sls`
    * `srv/salt/apache/init.sls`
    * `srv/salt/apache/files/index.html`
* SaltStack Dokumentaatio: https://docs.saltproject.io/
* Vagrant Dokumentaatio: https://developer.hashicorp.com/vagrant/docs
* Salt Bootstrap Repository: https://github.com/saltstack/salt-bootstrap
* Traversy Media - Vagrant Tutorial for Beginners: https://www.youtube.com/watch?v=vBreXjkizgo
* Gemini 2.5 Pro (experimental)
  - kieliasussa
  - termeissä
  - koodin rakentamisessa
