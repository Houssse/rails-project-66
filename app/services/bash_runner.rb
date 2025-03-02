# frozen_string_literal: true

class BashRunner
  def self.execute(command)
    output, exit_status = Open3.popen3(command) do |_stdin, stdout, _stderr, wait_thr|
      [stdout.read, wait_thr.value]
    end

    [output, exit_status.exitstatus]
  end
end
