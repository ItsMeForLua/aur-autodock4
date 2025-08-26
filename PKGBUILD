# Maintainer: Andrew D. France <andrewforlua@gmail.com>
pkgname=autodock4
pkgver=4.2.6
pkgrel=1
pkgdesc="Automated docking of flexible ligands to proteins"
arch=('x86_64' 'i686')
url="http://autodock.scripps.edu/"
license=('GPL')
depends=('gcc-libs')
makedepends=('gcc' 'make' 'tcsh')
source=("http://autodock.scripps.edu/downloads/autodock-registration/tars/dist426/autodocksuite-${pkgver}-src.tar.gz")
sha256sums=('4b24ce4baf216a5e1a6a79bb664eeed684aed17cede64ff0061aa1bcc17874c4')

build() {
    cd "$srcdir/src/autodock"
    
    echo "==> Configuring AutoDock..."
    ./configure --prefix=/usr
    
    echo "==> Manually generating parameter header..."
    # Generate the header file using the same logic as the csh script
    cat > default_parameters.h << 'EOF'
const char *param_string_4_0[MAX_LINES] = {
EOF
    
    # Process first parameter file AD4_parameters.dat
    egrep -v '^#|^$' ./AD4_parameters.dat | sed 's/\(.*\)$/"\1\\n", /' >> default_parameters.h
    
    cat >> default_parameters.h << 'EOF'
 };
const char *param_string_4_1[MAX_LINES] = {
EOF
    
    # Process second parameter file AD4.1_bound.dat
    egrep -v '^#|^$' ./AD4.1_bound.dat | sed 's/\(.*\)$/"\1\\n", /' >> default_parameters.h
    
    cat >> default_parameters.h << 'EOF'
 };
// EOF
EOF
    
    echo "==> Building AutoDock..."
    make
    
    cd "$srcdir/src/autogrid"
    
    echo "==> Configuring AutoGrid..."
    ./configure --prefix=/usr
    
    echo "==> Building AutoGrid..."
    make
}

package() {
    install -Dm755 "$srcdir/src/autodock/autodock4" "$pkgdir/usr/bin/autodock4"
    install -Dm755 "$srcdir/src/autogrid/autogrid4" "$pkgdir/usr/bin/autogrid4"
    install -Dm644 "$srcdir/src/README" "$pkgdir/usr/share/doc/$pkgname/README"
    install -Dm644 "$srcdir/src/RELEASENOTES" "$pkgdir/usr/share/doc/$pkgname/RELEASENOTES"
}