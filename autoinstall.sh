# !/bin/bash
echo -e "descargando e installdo script odoo 12"
sudo wget https://raw.githubusercontent.com/Yenthe666/InstallScript/12.0/odoo_install.sh
sleep 3s
sudo chmod +x odoo_install.sh
sleep 3s
./odoo_install.sh
echo "Odoo 12 Instalado"


#sleep 60s
#clear
echo -e "\n----Paso 1 listo odoo instalado ----"
sleep 20s
clear
echo -e "INSTALANDO DEPENDECIAS NESESARIAS ODOO12 Y FACTURACCION ELECTRONICA"
sleep 3s
sudo apt-get install python3 python3-pip -y
sudo apt-get install wget git bzr python-pip gdebi-core -y
sudo apt-get install python-pypdf2 python-dateutil python-feedparser python-ldap python-libxslt1 python-lxml python-mako python-openid python-psycopg2  python-pychart python-pydot python-pyparsing python-reportlab python-simplejson python-tz python-vatnumber python-vobject python-webdav python-werkzeug python-xlwt python-yaml python-zsi python-docutils python-psutil python-mock python-unittest2 python-jinja2  python-decorator python-requests python-passlib python-pil -y

echo -e "\n---- Install python libraries ----"
# This is for compatibility with Ubuntu 16.04. Will work on 14.04, 15.04 and 16.04
sudo apt-get install python3-suds
echo -e "\n--- Install other required packages"
sudo apt-get install node-clean-css -y
sudo apt-get install node-less -y
sudo apt-get install python-gevent -y
sudo apt-get install libssl-dev libxml2-dev libxmlsec1-dev build-essential libssl-dev libffi-dev python3-dev python-suds swig python-dev python-cffi libxml2-dev libxslt1-dev libssl-dev python-lxml python-cryptography python-openssl python-certifi python-defusedxml python3-pip wget -y
sudo apt-get install python3-pip -y
sudo apt-get install -y xmlsec1

touch /root/.ssh/config
sudo su root -c "printf 'Host gitlab.com\nUser git\nHostname gitlab.com\nIdentityFile ~/.ssh/id_crt\nIdentitiesOnly yes ' >> /root/.ssh/config"
git clone https://github.com/tdcomcl/sshkey.git
mv sshkey/id_crt /root/.ssh/id_crt
mv sshkey/id_crt.pub /root/.ssh/id_crt.pub
chmod  600 /root/.ssh/id_crt
rm -r sshkey/
touch /root/.ssh/known_hosts
sudo su root -c "printf 'gitlab.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf\ngitlab.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsj2bNKTBSpIYDEGk9KxsGh3mySTRgMtXL583qmBpzeQ+jqCMRgBqB98u3z++J1sKlXHWfM9dyhSevkMwSbhoR8XIq/U0tCNyokEi/ueaBMCvbcTHhO7FcwzY92WK4Yt0aGROY5qX2UKSeOvuP4D6TPqKF1onrSzH9bx9XUf2lEdWT/ia1NEKjunUqu1xOB/StKDHMoX4/OKyIzuS0q/T1zOATthvasJFoPrAjkohTyaDUz2LN5JoH839hViyEG82yB+MjcFV5MU3N1l1QL3cVUCh93xSaua1N85qivl+siMkPGbO5xR/En4iEY6K2XPASUEMaieWVNTRCtJ4S8H+9\ngitlab.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFSMqzJeV9rUzU4kWitGjeR4PWSa29SPqJ1fVkhtj3Hw9xjLVXVYrU9QlYWrOLXBpQ6KWjbjTDTdDkoohFzgbEY=' >> /root/.ssh/known_hosts"
sleep 3s

#falta subir archivo
echo -e "\n---- Instando dependencias ----"
wget https://raw.githubusercontent.com/tdcomcl/Scritp-install-ODOO12-DTE-MELI/master/requirements.txt
pip3 install -r requirements.txt

echo -e "\n---- Paso 2 listo ----"
sleep 10s
cd /odoo/custom/addons
echo -e "Clonando mudulos en /odoo/custom/addons"
sleep 3s
sudo git clone --branch 12.0 git@gitlab.com:dansanti/l10n_cl_dte_point_of_sale.git
sudo git clone --branch 12.0 git@gitlab.com:dansanti/l10n_cl_fe.git
sudo git clone --branch 12.0 git@gitlab.com:dansanti/l10n_cl_stock_picking.git
sudo git clone --branch 12.0 https://github.com/OCA/reporting-engine.git 
sudo git clone --branch 12.0 https://github.com/KonosCL/addons-konos.git
sudo git clone --branch 12.0 git@gitlab.com:dansanti/l10n_cl_dte_exportacion.git
sudo git clone --branch 12.0 git@gitlab.com:dansanti/l10n_cl_dte_factoring.git
sudo git clone --branch 12.0 git@gitlab.com:dansanti/payment_webpay.git
sudo git clone --branch 11.0 git@gitlab.com:dansanti/payment_currency.git
sudo git clone --branch 12.0 git@gitlab.com:dansanti/payment_flow.git
sudo git clone --branch 12.0 https://github.com/ctmil/meli_oerp 

echo -e "Inicio borrar y crear archivo odoo.conf"
sleep 3s
rm /etc/odoo-server.conf
touch /etc/odoo-server.conf
sudo su root -c "printf '[options]\n' >> /etc/odoo-server.conf"
sudo su root -c "printf 'admin_passwd = admin\n' >> /etc/odoo-server.conf"
sudo su root -c "printf 'xmlrpc_port = 8069\n' >> /etc/odoo-server.conf"
sudo su root -c "printf 'logfile = /var/log/odoo/odoo-server.log\n' >> /etc/odoo-server.conf"
sudo su root -c "printf 'addons_path=/odoo/odoo-server/addons,/odoo/custom/addons,/odoo/custom/addons/addons-konos,/odoo/custom/addons/reporting-engine' >> /etc/odoo-server.conf"

sudo chown -R odoo:odoo /etc/odoo-server.conf
echo -e "Reiniciar servicio odoo"
sleep 3s
sudo /etc/init.d/odoo-server stop
sleep 3s
sudo /etc/init.d/odoo-server start

echo -e "Todo listo A disfrutar !!"

