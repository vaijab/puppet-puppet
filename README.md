puppet
===

This module sets up puppet agent, master, reports to graphite and
hiera.

This module is most flexible and most easier to manage when used with hiera.

## Classes

### puppet
This class installs puppet package. It should not be called directly.
It is inherited by `puppet::agent` and `puppet::master` classes.

#### Parameters
* `vardir` - Puppet working directory. Default: /var/lib/puppet`.

* `confdir` - Puppet configuration directory. Default: `/etc/puppet`.

* `logdir` - Puppet logs directory. Default: `/var/log/puppet`.

* `rundir` - Where Puppet PID files are kept. Default: `/var/run/puppet`.

* `ssldir` - Where SSL certificates are kept. Default: ``$vardir/ssl`.

* `package` - puppet package ensure. Default: `ìnstalled`.


### puppet::agent
This class configures puppet agent itself and the agent service.

#### Parameters
* `enable` - Whether to start the service on boot. Defaults to `true`.
Valid values: `true` or `false`.

* `ensure` - Whether to start the service on boot. Defaults to `running`.
Valid values: `running` or `stopped`.

* `master` - Puppet master server hostname. Default: `puppet`.

* `environment` - Puppet environment. Default: `production`.

* `report` - Enables or disables agent reports. Default: `true`.

* `pluginsync` - Whether plugins should be synced with the central server.
Default: `true`.

* `runinterval` - How often puppet agent runs in seconds. Default: `1800`.

* `certname` - Node’s certificate name, and the name it uses when requesting catalogs;
defaults to the fully qualified domain name if not set. Default: `undef`.

#### Examples
    ---
    classes:
      - puppet::agent

    puppet::agent::enable: 'false'
    puppet::agent::ensure: 'stopped'
    puppet::agent::master: 'puppet.example.com'
    puppet::agent::environment: 'staging'
    puppet::agent::certname: "%{ec2_instance_id}.example.com"


### puppet::master
This class installs puppet master and puppetdb-terminus packages and
configures puppet master server. It is tested with Puppet 3.1 or later.

#### Parameters
* `enable` - Whether to start the service on boot. Defaults to `true`.
Valid values: `true` or `false`.

* `ensure` - Whether to start the service on boot. Defaults to `running`.
Valid values: `running` or `stopped`.

* `storeconfigs` - Whether to store each client’s configuration, including
catalogs, facts and related data. Default: `false`.

* `storeconfigs_backend` - Configure the backend terminus used for StoreConfigs.
Currently this module supports `puppetdb` only as a backend for stored configs.
Default: `puppetdb`.

* `reports` - The list of reports to generate. All reports are looked for in
`puppet/reports/name.rb`, and multiple report names should be comma-separated
(whitespace is okay). Default: `store, puppetdb`.

* `autosign` - Whether to enable autosign. Valid values are `true` and `false`.
Default: `false`.

* `allow_duplicate_certs` - Whether to allow a new certificate request to overwrite
an existing certificate. Default: `false`.

* `environments` - A list of environments puppet master supports.
Default: `development`, `qa`, `staging`, `production`.

* `path_to_env_code` - Where to look for puppet modules data for specific environment.
The module will not create directories. Default: `/etc/puppet/environments`.

* `path_to_hieradata` - Where to look for hieradata data. Puppet will not create
hiera data directories, it depends on your hierarchy. Default: `$confdir/hieradata`.

* `hiera_hierarchy` - A list of hiera hierarchy items to use for data searching.
Use ``${}`` instead of ``%{}`` as the latter will be interpolated by hiera.
    Default:
    - 'environments/${environment}/nodes/${fqdn}'
    - 'environments/${environment}/roles/${noderole}'
    - 'environments/${environment}/sites/${nodesite}'
    - 'environments/${environment}/common'


* `hiera_backends` - What hiera backends to use. Default: `yaml`. Available backends:
`yaml`, `json`, `eyaml` - it depends on `puppet::hiera::eyaml` class to be included for
your puppet master.

* `puppetdb_server` - PuppetDB server name. This tells puppet master where to find PuppetDB.
Default: $::fqdn`.

* `puppetdb_port` - PuppetDB port number. This tells puppet master what port to use to connect
to the PuppetDB server. Default: `8081`.

* `routes_enabled` - Whether to use `routes.yaml` terminus granular configuration.
Enable it only if puppet master is configured to use PuppetDB. Default: `false`.

#### Examples
    # Using puppet master w/o a backend to store configs, facts, catalogs
    ---
    classes:
      - puppet::master

    puppet::master::environments:
      - 'development'
      - 'qa'


    # Using puppet master with PuppetDB as a backend
    ---
    classes:
      - puppet::master

    puppet::master::environments:
      - 'development'
      - 'qa'

    puppet::master::puppetdb_server: 'puppetdb.example.com'
    puppet::master::routes_enabled: true


### puppet::hiera::eyaml
This class installs rubygem-hiera-eyaml package, hiera eyaml backend libs and can
generate private/public key pair for you.

More info can be found at: https://github.com/TomPoulton/hiera-eyaml

#### Requires
It expects `rubygem-hiera-eyaml` package to be available in apt/yum repositories.

#### Parameters
* `generate_keys` - Whether to generate OpenSSL keys for encryption/decryption.
Default: `false`.


### puppet::master::reports::graphite
This class configures puppet report processor for graphite. Make sure
`puppet::master::reports:` parameter has `graphite` listed as well (see examples).

#### Parameters
* `endpoint` - Graphite plaintext socket server to send reports to. Default: `undef`.
It is a required parameter. This class will fail if this parameter is missing.

* `prefix` - Graphite key space prefix.
Default: `servers.<server-name_example_com>.puppet.reports`.

* `port` - Graphite server port number for plaintext socket protocol. Default: `2003`.

#### Examples
    ---
    classes:
      - puppet::master::reports::graphite
      - puppet::master

    puppet::master::reports: 'store, graphite'

    puppet::master::reports::graphite::endpoint: mygraphite.example.com

## Authors
* Vaidas Jablonskis <jablonskis@gmail.com>

