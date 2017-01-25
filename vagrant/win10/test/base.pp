node 'default' {
  package { "git" :
        ensure => "latest",
        provider => 'chocolatey'
  }
}