class Job

  def self.run
    self.new.run
  end

  def run
    case ARGV[0]
    when '-mapper'
      STDIN.each do |line|
        next unless line
        mapper(line.chomp) { |*a| puts a.join("\t") }
      end

    when '-reduce'
      STDIN.each do |line|
        next unless line
        args = line.chomp.split("\t")
        reduce(*args) { |*a| puts a.join("\t") }
      end
      reduce(nil, nil) { |*a| puts a.join("\t") }
    else
      cmd = "#{$0} -mapper | sort | #{$0} -reduce"
      STDERR.puts "no parameter, running \"#{cmd}\""
      exec cmd
    end

  end

end

