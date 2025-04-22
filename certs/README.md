# Creaste Self-Signed Certificates

Resources: <https://mariadb.com/docs/security/encryption/in-transit/create-self-signed-certificates-keys-openssl/>

## Creating the Certificate Authority's Certificate and Keys

```bash
cp ./tools/onemarc.io.ext ./onemarc.io.ext
openssl genrsa -out "onemarc-ca-public.key" 2048
CONFIG="
[ req ]
encrypt_key = no
utf8 = yes
string_mask = utf8only
prompt=no
distinguished_name = root_dn
x509_extensions = extensions
[ root_dn ]
# Country Name (2 letter code)
countryName = PT
# Locality Name (for example, city)
localityName = Sobral de Monte Agraço
# Organization Name (for example, company)
0.organizationName = OneMarc.io
# Name for the certificate
commonName = OneMarc.io Authority Certificate
[ extensions ]
# keyUsage = keyCertSign,cRLSign
basicConstraints = CA:TRUE
subjectKeyIdentifier = hash
authorityKeyIdentifier = keyid,issuer
"
openssl req -config <(echo "$CONFIG") -x509 -new -nodes -key "onemarc-ca-public.key" -subj '/C=PT/ST=Sobral de Monte Agraço/L=Sobral de Monte Agraço/O=OneMarc.io/CN=OneMarc.io Authority Certificate' -sha256 -days 1825 -out "onemarc-ca-cert.crt"
```

## Creating the Server's/Domain's Certificate and Keys (wildcard certificate)

```bash
# private key
openssl genrsa -out "onemarc-wildcard-private.key" 2048
# public key
openssl rsa -in "onemarc-wildcard-private.key" -out "onemarc-wildcard-public.key" -pubout -outform PEM
# certificate
openssl req -new -key "onemarc-wildcard-private.key" -out onemarc.io.csr -subj '/C=PT/ST=Sobral de Monte Agraço/L=Lisboa/O=OneMarc.io/CN=OneMarc.io'
openssl x509 -req -in onemarc.io.csr -CA "onemarc-ca-cert.crt" -CAkey "onemarc-ca-public.key" -CAcreateserial -out "onemarc-wildcard.crt" -days 1825 -sha256 -extfile onemarc.io.ext
# cleanup files
rm onemarc.io.csr
rm onemarc.io.ext
```

## Creating the rest of the certificates

```bash
sh ./tools/batchGenerator.sh hera.onemarc.io "PVE - hera.onemarc.io"
sh ./tools/batchGenerator.sh kronos.onemarc.io "PVE - kronos.onemarc.io"
sh ./tools/batchGenerator.sh poseidon.onemarc.io "PVE - poseidon.onemarc.io"
sh ./tools/batchGenerator.sh zeus.onemarc.io "PVE - zeus.onemarc.io"
sh ./tools/batchGenerator.sh rivendell.onemarc.io "NAS - rivendell.onemarc.io"
```

## Install certificates (Linux)

```bash
cd .\certs
cp *.crt /usr/local/share/ca-certificates/extra
sudo update-ca-certificates
```

## Install certificates (Windows)

Powershell with admin privileges

```ps
cd .\certs
Get-ChildItem -Path "." -Recurse -Filter *.crt | Foreach-Object { certutil -f -addstore "ROOT" $_.FullName }
```
