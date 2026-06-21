# Maintainer: Xinfoo <13994062125@163.com>
pkgname=via-proxy
pkgver=0.3.0
pkgrel=1
pkgdesc='Run commands with proxy environment variables from a simple config file'
arch=('any')
license=('MIT')
depends=('bash' 'gawk')
source=('via.sh')
sha256sums=('0390f6ef62c26ffca119561ff798d1b62a5e2e46601e43794b25feb95369d05a')

package() {
  install -Dm755 via.sh "$pkgdir/usr/bin/via"
}
