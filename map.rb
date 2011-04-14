#!/usr/bin/env ruby

$LOAD_PATH.unshift 'lib'

require 'job'

class Wordcount < Job

  def mapper(line)
    return unless line =~ /POST \/orders\/(\d+)\/([a-f0-9]+)\/commit/

    if line =~  /(iPhone|Android|Blackberry)/i
      yield $1.downcase, 1
    else
      yield 'browser', 1
    end
  end

  def reduce(key, value)

    aggregate(key) do |key, count|
      yield key, count
    end

  end
end

Wordcount.run
