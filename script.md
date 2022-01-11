# Apache Script

[TOC]

<div style="page-break-after: always; break-after: page;"></div>

## Installation

```shell
sudo apt update
sudo apt install apache2
```

## Virtual Hosts Einrichten

[virtual_hosts.sh](https://github.com/laniwfhnw/sysad_pres_scripts/blob/main/virtual_hosts.sh)

### Kontext

Ordner erstellen:

```shell
sudo mkdir -p /var/www/hello.com/html /var/www/sysad.fhnw.ch/html
```

### Virtual Hosts

Configurationsdatei kopieren:

```shell
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/hello.com.conf
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/sysad.fhnw.ch.conf
```

Inhalt anpassen:

```shell
vim /etc/apache2/sites-available/hello.com.conf
```

```xml
<VirtualHost *:80>
	ServerAdmin webmaster@localhost
    ServerName hello.com
    ServerAlias www.hello.com
	DocumentRoot /var/www/hello.com/html
	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

```shell
vim /etc/apache2/sites-available/sysad.fhnw.ch.conf
```

```html
<VirtualHost *:80>
	ServerAdmin webmaster@localhost
    ServerName sysad.fhnw.ch
    ServerAlias www.sysad.fhnw.ch
	DocumentRoot /var/www/sysad.fhnw.ch/html
	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

### Aktualisierung

Virtual Hosts aktivieren und apache2 Konfiguration neu laden:

```shell
sudo a2ensite hello.com.conf
sudo a2ensite sysad.fhnw.ch.conf
sudo a2dissite 000-default.conf
sudo systemctl reload apache2
```

## Webseiteninhalte erstellen

[website_content.sh](https://github.com/laniwfhnw/sysad_pres_scripts/blob/main/website_content.sh)

Inhalt fuer `hello.com` erstellen:

```shell
sudo bash -c "echo \"Hello hello.com\" > /var/www/hello.com/html/index.html"
```

Inhalt fuer `sysad.fhnw.ch` erstellen:

```shell
sudo bash -c "echo \"Hello sysad.fhnw.ch\" > /var/www/sysad.fhnw.ch/html/index.html"
```

## Inhalte lesen

### VM

Wenn der Server auf einer virtuellen Machine laeuft und vom Host aus erreichbar sein sollte, muss man noch Port-Forwarding unter "Settings" > "Network" > "Advanced" > "Port Forwarding" einrichten.

| **Name**  | **Protocol** | **Host Port** | **Guest Port** |
| --------- | ------------ | ------------- | -------------- |
| localhost | TCP          | 8000          | 80             |

Nun muessen wir zuerst mit `ip a` herausfinden unter welcher IP-Adresse unser Server erreichbar ist. Sobald wir die IP haben, koennen wir diese mit dem entsprechenden Port, den wir im Port-Forwarding definiert haben, aufrufen `10.0.2.15:8000`.

### Lokal

[hosts.sh](https://github.com/laniwfhnw/sysad_pres_scripts/blob/main/hosts.sh)

Um die Darstellung der virtuellen Hosts lokal zu testen muessen die beiden Domains in der `/etc/hosts` Datei hinzugefuegt werden, denn Apache verwendet die Domainnamen um zu entscheiden welche der Virtuellen Hosts dargestellt werden.

Zur `/etc/hosts` Datei hinzufuegen:

```
127.0.0.1	hello.com
127.0.0.1	sysad.fhnw.ch
```

## Geheime Dateien

[confidential_data.sh](https://github.com/laniwfhnw/sysad_pres_scripts/blob/main/confidential_data.sh)

Zugriff zu geheimen Dateien kann durch `.htaccess` Konfigurationen eingeschraenkt werden. `.htaccess` Dateien muessen zuerst aktiviert werden, also muss der Eintrag `AllowOverride None` in der `/etc/apache2/apache2.conf` Datei zu `AllowOverride All` geaendert werden. Dann koennen wir unsere vertrauliche Datei erstellen.

```shell
sudo mkdir -p /var/www/hello.com/html/confidential
echo $'username;pw\nlani.wagner;1234' > /var/www/hello.com/html/confidential/conf.txt
echo "RedirectMatch 403 ^/confidential/.*$" > /var/www/hello.com/html/.htaccess
```

Diese koennen wir aber noch ueber die URL [hello.com/confidential/conf.txt](http://hello.com/confidential/conf.txt) oeffnen. Das liegt daran, dass wir die Konfiguration nicht angepasst haben. Es muss also nur noch die die Konfiguration neu geladen werden:

```bash
sudo systemctl reload apache2
```

## Fehlerumleitung

[403_redirect.sh](https://github.com/laniwfhnw/sysad_pres_scripts/blob/main/403_redirect.sh)

Um den 403 Fehler "Forbidden" umzuleiten, koennen wir ein Dokument erstellen, das anstelle der Apache Meldungangezeigt wird. Wir erstellen `403.html`:

```shell
echo "403, Permission denied" > /var/www/hello.com/html/403.html
```

und leiten den den Fehler mithilfe der `/etc/apache2/sites-available/hello.com.conf` um. Wir fuegen die folgende Zeile hinzu:

```xml
	ErrorDocument 403 /403.html
```

## Scripts

GitHub: [github.com/laniwfhnw/sysad_pres_scripts](https://github.com/laniwfhnw/sysad_pres_scripts)

1. Installation

   ```bash
   #!/bin/bash
   sudo apt update
   sudo apt install apache2
   ```

2. Virtual Hosts Einrichten

   ```bash
   #!/bin/bash
   sudo mkdir -p /var/www/hello.com/html /var/www/sysad.fhnw.ch/html
   sudo echo $'<VirtualHost *:80>\n\tServerAdmin\twebmaster@localhost\n\tServerName\thello.com\n\tServerAlias\twww.hello.com\n\tDocumentRoot\t/var/www/hello.com/html\n\tErrorLog\t${APACHE_LOG_DIR}/error.log\n\tCustomLog\t${APACHE_LOG_DIR}/access.log combined\n</VirtualHost>' > /etc/apache2/sites-available/hello.com.conf
   sudo echo $'<VirtualHost *:80>\n\tServerAdmin\twebmaster@localhost\n\tServerName\tsysad.fhnw.ch\n\tServerAlias\twww.sysad.fhnw.ch\n\tDocumentRoot\t/var/www/sysad.fhnw.ch/html\n\tErrorLog\t${APACHE_LOG_DIR}/error.log\n\tCustomLog\t${APACHE_LOG_DIR}/access.log combined\n</VirtualHost>' > /etc/apache2/sites-available/sysad.fhnw.ch.conf
   
   sudo a2ensite hello.com.conf
   sudo a2ensite sysad.fhnw.ch.conf
   sudo a2dissite 000-default.conf
   sudo systemctl reload apache2
   ```

3. Webseiteninhalt

   ```bash
   #!/bin/bash
   sudo bash -c "echo \"Hello hello.com\" > /var/www/hello.com/html/index.html"
   sudo bash -c "echo \"Hello sysad.fhnw.ch\" > /var/www/sysad.fhnw.ch/html/index.html"
   ```

4. Inhalte Lesen

   ```bash
   #!/bin/bash
   echo $'127.0.0.1\thello.com\n127.0.0.1\tsysad.fhnw.ch' >> /etc/hosts
   ```

5. Geheime Dateien (`AllowOverride` in `/etc/apache2/apache2.conf` auf `All` setzen)

   ```bash
   #!/bin/bash
   sudo mkdir -p /var/www/hello.com/html/confidential
   echo $'username;pw\nlani.wagner;1234' > /var/www/hello.com/html/confidential/conf.txt
   echo "RedirectMatch 403 ^/confidential/.*$" > /var/www/hello.com/html/.htaccess
   ```

6. Fehlerumleitung (`ErrorDocument 403 /403.html` zu `.conf` Datei hinzufuegen)

   ```bash
   #!/bin/bash
   echo "403, Permission denied" > /var/www/hello.com/html/403.html
   ```

Ablauf mit scripts:

1. `virtual_hosts.sh` laufen lassen
2. `website_content.sh` laufen lassen
3. `hosts.sh` laufen lassen
4. Webseiten hello.com und sysad.fhnw.ch anzeigen
5. `AllowOverride` in `/etc/apache2/apache2.conf` auf `All` setzen
6. `confidential_data.sh` laufen lassen
7. Zeigen, dass conf Datei erreichbar ist
8. `sudo systemctl apache2 reload` laufen lassen
9. Zeigen das conf Datei nicht erreichbar ist
10. `403_redirect.sh` laufen lassen
11. `ErrorDocument 403 /403.html` zu `.conf` Datei hinzufuegen
12. `sudo systemctl apache2 reload` laufen lassen
13. Zeigen, dass 403 weitergeleitet wird

## Cleanup Prozedur

1. Ordner loeschen

   ```bash
   #!/bin/bash
   rm -r /var/www/hello.com
   rm -r /var/www/sysad.fhnw.ch
   rm /etc/apache2/sites-available/hello.com.conf
   rm /etc/apache2/sites-available/sysad.fhnw.ch.conf
   sudo a2ensite 000-default.conf
   sudo a2dissite hello.com.conf
   sudo a2dissite sysad.fhnw.ch.conf
   sudo systemctl reload apache2
   ```

2. `/etc/hosts` Eintraege entfernen.

2. In `/etc/apache2/apache2.conf` `AllowOverride All` auf `AllowOverride None` aendern.
