#
# Copyright (C) 2017 Lenovo, Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'puppet/type'
require 'cnos-rbapi'
require 'cnos-rbapi/telemetry'
require 'yaml'

Puppet::Type.type(:cnos_telemetry).provide :gem do
  desc 'Manage BST feature on Lenovo CNOS. Requires cnos-rbapi'

  mk_resource_methods

  def self.instances
    provider_val = []
    param = YAML.load_file('./config.yml')
    conn = Connect.new(param)
    resp = Telemetry.get_bst_feature(conn)
    return 'no bst feature' if !resp
    provider_val << new(name: 'telemetry_feature',
                        bst_enable: resp['bst-enable'],
                        send_async_reports: resp['send-async-reports'],
                        collection_interval: resp['collection-interval'],
                        trigger_rate_limit: resp['trigger-rate-limit'],
                        ensure: :present,
                        trigger_rate_limit_interval: resp['trigger-rate-limit-interval'],
                        send_snapshot_on_trigger: resp['send-snapshot-on-trigger'])
    return provider_val
  end

  def self.prefetch(resources)
    feature = instances
    resources.keys.each do |name|
      if provider = feature.find { |feature| TRUE }
        resources[name].provider = provider
      end
    end
  end

  def params_setup
    params = {}
    params =
      {
        "collection-interval" => resource[:collection_interval],
        "send-async-reports" => resource[:send_async_reports],
        "send-snapshot-on-trigger" => resource[:send_snapshot_on_trigger],
        "trigger-rate-limit" => resource[:trigger_rate_limit],
        "async-full-report" => resource[:async_full_report],
        "trigger-rate-limit-interval" => resource[:trigger_rate_limit_interval],
        "bst-enable" => resource[:bst_enable]
      }
    return params
  end

  def exists?
    @property_hash[:ensure] == :present
    return true
  end

  def flush
    puts @property_hash
    if @property_hash
      param = YAML.load_file('./config.yml')
      conn = Connect.new(param)
      params = params_setup
      Telemetry.set_bst_feature(conn, params)
    end
    @property_hash = resource.to_hash
  end

  def destroy
   # setting it to default values when destroy is called
   params =
      {
        "collection-interval" => 5,
        "send-async-reports" => 0,
        "send-snapshot-on-trigger" => 0,
        "trigger-rate-limit" => 1,
        "async-full-report" => 0,
        "trigger-rate-limit-interval" => 10,
        "bst-enable" => 0
      }
   param = YAML.load_file('./config.yml')
   conn = Connect.new(param)
   Telemetry.set_bst_feature(conn, params)
   @property_hash.clear
  end
end
