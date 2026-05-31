# Maintainer: xinfoo
pkgname=via-proxy
pkgver=0.1.0
pkgrel=1
pkgdesc='Run commands with proxy environment variables from a simple config file'
arch=('any')
license=('unknown')
depends=('bash' 'gawk')
source=('via.sh')
sha256sums=('f3ce40a89bbbfb71066089bbdeafc67276479d3b12190f8385f825d1d9139543')

package() {
  install -Dm755 via.sh "$pkgdir/usr/bin/via"
}
