class BashRunnerStub
  class << self
    attr_accessor :custom_response, :command_filter
  end

  DEFAULT_RESPONSE = ['', 0].freeze

  def self.stub_command(command_filter = nil, stdout: '', exit_status: 0)
    self.command_filter = command_filter
    self.custom_response = [stdout, exit_status]
  end

  def self.execute(command)
    if command_filter && command.include?(command_filter)
      custom_response
    else
      DEFAULT_RESPONSE
    end
  end
end
