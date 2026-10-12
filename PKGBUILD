# Maintainer: Xinfoo <13994062125@163.com>
pkgname=via-proxy
pkgver=0.4
pkgrel=1
pkgdesc='Run commands with proxy environment variables from a simple config file'
arch=('any')
license=('MIT')
depends=('bash' 'gawk')
source=('via.sh')
sha256sums=('cf16b2a4523d79306816b1a1e75c435102b0d6a1d5a4595d9ba766626c79e6f0')

package() {
  install -Dm755 via.sh "$pkgdir/usr/bin/via"
}
