#!/bin/bash

DOMAINDIR=domain.tld
VENVDIR=/opt/letsencrypt-venv
cd $VENVDIR
source bin/activate
python $VENVDIR/acme-tiny/acme_tiny.py --account /etc/ssl/letsencrypt/account.key  --csr /etc/ssl/domains/$DOMAINDIR/csr/domain.csr --acme-dir /opt/letsencrypt-venv/acme_outputbin/.well-known/acme-challenge > /etc/ssl/domains/$DOMAINDIR/certs/signed.crt

deactivate
cd /etc/ssl/domains/$DOMAINDIR/certs
wget -O - https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem > intermediate.pem
# for oscp stapling:
# wget -O - https://letsencrypt.org/certs/isrgrootx1.pem.txt > root.pem
# cat root.pem intermediate.pem  > ca-certs.pem 


cat signed.crt intermediate.pem > chained.pem
service nginx reload

