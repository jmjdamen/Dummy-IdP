#!/bin/bash
OC_BASEDIR="/home/conext/OpenConext-vm-57"
OC_DOMAIN="demo.openconext.org"

if [ ! -d /opt/www/Dummy-IdP ]
then
  cd /opt/www
  git clone https://github.com/jmjdamen/Dummy-IdP.git
fi

# add domain to /etc/hosts
checkhost='grep "dummyidp" /etc/hosts | wc -l'
if [ $checkhost -eq 0]
then
	sed -i 's/$/ dummyidp.demo.openconext.org/g' /etc/hosts
else
fi


#copy vhost conf file, not needed when merged with OpenConext VM httpd config files
cp /opt/www/Dummy-IdP/httpd/dummy-idp.conf /etc/httpd/conf.d/

#path needed when merged with OpenConext VM
#cat $OC_BASEDIR/configs/httpd/conf.d/dummy-idp.conf | \

#cat $OC_BASEDIR/configs/httpd/conf.d/dummy-idp.conf  | \
  sed -e "s/_OPENCONEXT_DOMAIN_/$OC_DOMAIN/g" > \
  /etc/httpd/conf.d/dummy-idp.conf

# Download and install simpleSAMLphp
cd /opt/www/Dummy-IdP
wget https://simplesamlphp.googlecode.com/files/simplesamlphp-1.11.0.tar.gz
tar xzf simplesamlphp-1.11.0.tar.gz
rm simplesamlphp-1.11.0.tar.gz
ln -s simplesamlphp-1.11.0 simplesamlphp

# Copy simpleSAMLphp config files
cp /opt/www/Dummy-IdP/simplesamlphp_data/configs/authsources.php /opt/www/Dummy-IdP/simplesamlphp/config/
cp /opt/www/Dummy-IdP/simplesamlphp_data/configs/config.php /opt/www/Dummy-IdP/simplesamlphp/config/
cp /opt/www/Dummy-IdP/simplesamlphp_data/metadata/saml20-sp-remote.php /opt/www/Dummy-IdP/simplesamlphp/metadata/
cp /opt/www/Dummy-IdP/simplesamlphp_data/metadata/saml20-idp-hosted.php /opt/www/Dummy-IdP/simplesamlphp/metadata/
cp -R /opt/www/Dummy-IdP/simplesamlphp_data/modules/dummy-idp /opt/www/Dummy-IdP/simplesamlphp/modules/

# Copy static files
cp /opt/www/Dummy-IdP/static/dummy-idp-logo.jpg /opt/www/OpenConext-static/media/

# Create Dummy-IdP in Service Registry database
# ** Enter your MySQL Root password below, remove it afterwards! **
mysql -uroot -prootpassw0rd << eof
INSERT INTO serviceregistry.janus__entity VALUES(100, 'https://dummyidp.demo.openconext.org/simplesaml/saml2/idp/metadata.php', 1, 'prodaccepted', 'saml20-idp', '', 'ht$
eof


# Import sql_users database

 


