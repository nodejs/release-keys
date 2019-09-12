# Node.js Release Keys

GPG keys used to sign Node.js releases:

* **Beth Griggs** &lt;bethany.griggs@uk.ibm.com&gt;
`4ED778F539E3634C779C87C6D7062848A1AB005C`
* **Colin Ihrig** &lt;cjihrig@gmail.com&gt;
`94AE36675C464D64BAFA68DD7434390BDBE9B9C5`
* **Evan Lucas** &lt;evanlucas@me.com&gt;
`B9AE9905FFD7803F25714661B63B535A4C206CA9`
* **Gibson Fahnestock** &lt;gibfahn@gmail.com&gt;
`77984A986EBC2AA786BC0F66B01FBB92821C587A`
* **James M Snell** &lt;jasnell@keybase.io&gt;
`71DCFD284A79C3B38668286BC97EC7A07EDE3FC1`
* **Jeremiah Senkpiel** &lt;fishrock@keybase.io&gt;
`FD3A5288F042B6850C66B31F09FE44734EB7990E`
* **Michaël Zasso** &lt;targos@protonmail.com&gt;
`8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600`
* **Myles Borins** &lt;myles.borins@gmail.com&gt;
`C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8`
* **Rod Vagg** &lt;rod@vagg.org&gt;
`DD8F2338BAE7501E3DD5AC78C273792F7D83545D`
* **Ruben Bridgewater** &lt;ruben@bridgewater.de&gt;
`A48C2BEE680E841632CD4E44F07496B3EB3C1762`
* **Shelley Vohr** &lt;shelley.vohr@gmail.com&gt;
`B9E2F5981AA6E0CD28160D9FF13993A75599653C`

Other keys used to sign some previous releases:

* **Chris Dickinson** &lt;christopher.s.dickinson@gmail.com&gt;
`9554F04D7259F04124DE6B476D5A82AC7E37093B`
* **Isaac Z. Schlueter** &lt;i@izs.me&gt;
`93C7E9E91B49E432C2F75674B0A78B0A6C481CF6`
* **Italo A. Casas** &lt;me@italoacasas.com&gt;
`56730D5401028683275BD23C23EFEFE93C4CFFFE`
* **Julien Gilli** &lt;jgilli@fastmail.fm&gt;
`114F43EE0176B71C7BC219DD50A3051F888C628D`
* **Timothy J Fontaine** &lt;tjfontaine@gmail.com&gt;
`7937DFD2AB06298B2293C3187D33FF9D0246406D`

## Verifying Release Packages

This repo contains the raw release signing keys in two forms:

 1. The **keys/** directory contains the raw ASCII-armored release signing keys listed above.

 2. The **gpg/** directory contains a GPG keyring preloaded with these release signing keys.

For additional verification of both the keys' content *and* of the list of authorized signing
keys, you may cross-reference the list with [nodejs.org](https://nodejs.org) and attempt to
fetch keys from alternative sources (instead of or in addition to this repo).

### Using the preloaded GPG keyring

First, clone this repo:

```bash
git clone https://github.com/canterberry/nodejs-keys.git
```

Then, prefix your `gpg` commands with the path to the cloned repo's **gpg/** directory.
For example, if you cloned the repo to **/path/to/nodejs-keys**, then the `gpg` command
to verify a release package will look something like this:

```bash
GNUPGHOME=/path/to/nodejs-keys/gpg gpg --verify SHASUMS256.txt.sig SHASUMS256.txt
```

### Using your own GPG keyring

First, clone this repo:

```bash
git clone https://github.com/canterberry/nodejs-keys.git
```

Then, import the release signing keys from this repo into your GPG keychain by invoking
the **cli.sh** script in this repo. For example, immediately after cloning the repo above,
the following command will import all release signing keys:

```
nodejs-keys/cli.sh import
```
