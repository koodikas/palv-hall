# -*- mode: ruby -*-
# vi: set ft=ruby :

# Salt Masterin asennusskripti: Käytetään uutta bootstrap URLia ja suoraa suoritusta
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
# Korjattu URL ilman Markdown-linkkiä
curl -LfsS https://github.com/saltstack/salt-bootstrap/releases/latest/download/bootstrap-salt.sh | sudo sh -s -- -M -A 192.168.88.101

echo "Configuring auto-accept and file_roots..."
sudo mkdir -p /etc/salt/master.d
echo "auto_accept: True" | sudo tee /etc/salt/master.d/auto-accept.conf > /dev/null
echo "file_roots:" | sudo tee /etc/salt/master.d/roots.conf > /dev/null
echo "  base:" | sudo tee -a /etc/salt/master.d/roots.conf > /dev/null
# Varmistetaan, että Vagrant synkronoi projektin juuren /vagrant-kansioon
# ja sieltä löytyy srv/salt -hakemisto
echo "    - /vagrant/srv/salt" | sudo tee -a /etc/salt/master.d/roots.conf > /dev/null
echo "Restarting salt-master service..."
sudo systemctl enable salt-master
sudo systemctl restart salt-master
echo "--- Salt Master provisioning complete on t001 ---"
MASTER_SCRIPT

# Minion skripti: Käytetään uutta bootstrap URLia ja suoraa suoritusta
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
# Korjattu URL ilman Markdown-linkkiä
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

  # Oletussynkronointi: projektihakemisto -> /vagrant
  # Tämä sisältää srv/salt -hakemiston
  # Voit myös määritellä sen eksplisiittisesti jos haluat:
  # config.vm.synced_folder "srv/salt", "/srv/salt" # Jos haluat sen suoraan /srv/salt Masterilla
  # Mutta koska master_script käyttää /vagrant/srv/salt, oletus toimii.

  # Synkronoidaan erillinen 'shared' kansio
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
    # Porttiohjaus: Hostin portti 8080 ohjataan vieraskoneen porttiin 80
    t002.vm.network "forwarded_port", guest: 80, host: 8080

    t002.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.name = "salt-minion-t002"
    end

    t002.vm.provision "shell", inline: $minion_script
  end
end
