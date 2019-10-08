# proxysettings
Export proxy settings to environment variables.
- http_proxy
- HTTP_PROXY
- https_proxy
- HTTPS_PROXY
- ftp_proxy
- FTP_PROXY

![proxysettings](https://raw.githubusercontent.com/takubokudori/proxysettings/master/screenshots/pic1.PNG)
## Usage

```
$ mv proxy.sh ~
$ source ~/proxy.sh
```

Input proxy host, port, username, password

No exported the settings if host is empty.
No credential if username is empty.

Start when the tarminal starts.

```
$ echo "source ~/proxy.sh" >> ~/.bashrc
```

Saved settings ( host, port, username ) to ~/.proxysettings

The password is URL encoded automatically if nkf exists.
