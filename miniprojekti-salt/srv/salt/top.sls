# /srv/salt/top.sls
# Määrittää, että base-ympäristössä kaikille minioneille ('*')
# ajetaan 'apache'-tila.
base:
  '*':
    - apache