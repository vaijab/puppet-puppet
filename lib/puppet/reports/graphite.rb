require 'puppet'
require 'socket'
require 'yaml'
require 'time'

Puppet::Reports.register_report(:graphite) do

  desc <<-DESC
    Send reports via a TCP socket to a Graphite instance. This report processor
    submits reports to the Graphite server in the required `graphite_endpoint`
    setting.

    Configuration file `graphite.yaml` needs to be placed in $confdir location.
    Valid values:

      :graphite_endpoint
      :graphite_port
      :graphite_prefix
  DESC

  configfile = File.join([File.dirname(Puppet.settings[:config]), "graphite.yaml"])
  raise(Puppet::ParseError, "Graphite report config file #{configfile} not readable") unless File.exist?(configfile)

  CONFIG = YAML.load_file(configfile)
  GRAPHITE_ENDPOINT = CONFIG[:graphite_endpoint]
  GRAPHITE_PORT = CONFIG[:graphite_port] || 2003

  def push_metrics(payload)
    socket = TCPSocket.new(GRAPHITE_ENDPOINT, GRAPHITE_PORT)
    socket.puts payload
    socket.close
  end

  def process
    default_prefix = "servers.#{self.host.gsub('.', '_')}.puppet.reports"
    graphite_prefix = CONFIG[:graphite_prefix] || default_prefix

    Puppet.debug "Sending metrics for #{self.host} to Graphite server at #{GRAPHITE_ENDPOINT}"
    epochtime = Time.now.utc.to_i
    self.metrics.each do |metric,data|
      data.values.each do |val|
        key_name = "#{graphite_prefix}.#{metric}.#{val[0]}"
        value = val[2]
        push_metrics "#{key_name} #{value} #{epochtime}"
      end
    end
  end
end
