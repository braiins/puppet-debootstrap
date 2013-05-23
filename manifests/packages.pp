# vim: tabstop=2 shiftwidth=2 softtabstop=2

# Module: 'debootstrap'
# Author: Morphlabs - Aimon Bustardo <abustardo at morphlabs dot com>
# Descr:  Puppet Module for managing Chrooted apps via 'debootstrap'

class debootstrap::packages() {

  $debootstrap_packages=['debootstrap', 'schroot']
  package{$debootstrap_packages:
    ensure  =>  latest,
  }

}
