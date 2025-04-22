#!/bin/sh

if [ "$#" -ne 2 ]
then
  echo "Usage: Must supply a domain"
  exit 1
fi

DOMAIN=$1
CRTNAME=$2
SUBJECT="/C=PT/ST=Sobral de Monte Agraço/L=Lisboa/O=OneMarc.io/CN=$CRTNAME"

# private key
openssl genrsa -out "$DOMAIN-private.key" 2048
# public key
openssl rsa -in "$DOMAIN-private.key" -out "$DOMAIN-public.key" -pubout -outform PEM
#request for certificate
openssl req -new -key "$DOMAIN-private.key" -out $DOMAIN.csr -subj "$SUBJECT"

cat > $DOMAIN.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = $DOMAIN
EOF

openssl x509 -req -in $DOMAIN.csr -CA "onemarc-ca-cert.crt" -CAkey "onemarc-ca-public.key" -CAcreateserial \
-out "$DOMAIN.crt" -days 1825 -sha256 -extfile $DOMAIN.ext

rm $DOMAIN.csr
rm $DOMAIN.ext
