class Job

  def self.run
    self.new.run
  end

  def increment(group, name, amount = 1)
    STDERR.puts "reporter:counter:#{group}:#{name},#{amount}"
  end

  def status(message)
    STDERR.puts "reporter:status:#{message}"
  end

  def aggregate(name)
    if @prev_key.nil?
      @prev_key = name
      @key_total = 0
    elsif name != @prev_key && @key_total > 0
      yield @prev_key, @key_total
      @prev_key, @key_total = name, 0
    end

    @key_total += 1
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
  rescue => e
    status "#{e.class.name}: #{e.message}"
    STDERR.puts "#{e.class.name}: #{e.message}"
    STDERR.puts e.backtrace.join("\n")
  end

end

