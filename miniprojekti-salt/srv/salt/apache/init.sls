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