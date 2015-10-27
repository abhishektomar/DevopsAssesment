####
class basenode (
    $packages,
    ) {
  ensure_packages($packages)
    file { "/root/.screenrc":
      ensure => "file",
      owner => "root",
      group => "root",
      require => Package["screen"],
      source => "puppet:///modules/basenode/screenrc"
    }
  package { 'awscli':
    ensure   => installed,
    provider => 'pip',
  }
  class { 'vim' : 
    opt_bg_shading => light,
    opt_ruler => true,
    opt_misc => ['hlsearch','showcmd','showmatch','ignorecase','smarttab','smartcase','incsearch','autowrite','hidden','number','tabstop=4','shiftwidth=4','expandtab','softtabstop=4','background=light'],
  }
}
