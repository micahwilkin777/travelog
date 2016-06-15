
# CarrierWave.configure do |config|
#   config.fog_provider = 'fog/aws'                        # required
#   config.fog_credentials = {
#     :provider               => 'AWS',
#     :aws_access_key_id      => 'AKIAINNCYAVGDPU7GZGA',
#     :aws_secret_access_key  => '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',
#     :region                 => 'us-west-2'
#   }
#   config.fog_directory  = 'travelog'
#   config.fog_public = true
#   config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}"}
# end


CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'                        # required
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => 'AKIAJQKKUV6YAMM223SQ',
    :aws_secret_access_key  => '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',
    :region                 => 'us-west-2'
  }
  config.fog_directory  = 'travelog'
  config.fog_public = true
  config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}"}
end